import schemas
import uuid
import logging
from utils import emailutil
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer

app = APIRouter()


async def user_email(email, name, lastname, messages, role, company, employees):
    subject = "Ktizo - Contact Us Form Message Received"
    recipient = [email]
    message = f"""Hi {name.capitalize()} {lastname.capitalize()},
    <!DOCTYPE html>
    <html>
    <body>
    <div>

    <p>Thanks for contacting us.</p

    <p>We've received your following message:</p>

    <p>"{messages}"</p>

    <p>We will respond to you in a timely manner. </p>

    <p>In the meantime, stay up to date by frequently visiting our website  www.ktizo.io </p>
        
    <p> Thank you, </p>
    <p> Malcolm Coronel </p>
    <p> Founder & CEO of Ktizo </p>
    <div>
    </body>
    </html>
        """
    await emailutil.send_email(recipient, subject, message)


async def client_email(name, lastname, email, message, role, company, employees):
    subject = "Ktizo-User Query Details"
    recipient = ["launch@ktizo.io"]
    if role == "Artist":
        message = f"""Hi Malcom,
    <!DOCTYPE html>
    <html>
    <body>
    <div>

    <p>Ktizo-User  Query Details</p>

    <p>Query from {name.capitalize()} {lastname.capitalize()} is shown below :</p>

    <p>"{message.capitalize()}"</p>
    <p>{email}</p>
    <p>Role -{role}</p>
        
    <p>Thanks and Regards </p>
    <div>
    </body>
    </html>  
        """
    else:
        message = f"""Hi Malcom,
    <!DOCTYPE html>
    <html>
    <body>
    <div>

    <p>Ktizo-User  Query Details</p>

    <p>Query from {name.capitalize()} {lastname.capitalize()} is shown below :</p>

    <p>"{message.capitalize()}"</p>
    <p>{email}</p>
    <p>Role -{role}</p>
    <p>Company name - {company}</p>
    <p>Employees -{employees}</p>
        
    <p>Thanks and Regards </p>
    <div>
    </body>
    </html>  
        """
    await emailutil.send_email(recipient, subject, message)


# contact message
@app.post("/contact", tags=["Contact Us Methods"])
async def contact(contacts: schemas.Contact, db: Session = Depends(get_db)):
    try:

        contact_user = models.Contact(
            id=uuid.uuid4(),
            name=contacts.name,
            last_name=contacts.last_name,
            email=contacts.email,
            user_role=contacts.user_role,
            message=contacts.message,
            company_name=contacts.company_name,
            number_of_employees=contacts.number_of_employees
        )
        db.add(contact_user)
        db.commit()
        await user_email(contacts.email, contacts.name, contacts.last_name, contacts.message, contacts.user_role,
                         contacts.company_name, contacts.number_of_employees)
        await client_email(contacts.name, contacts.last_name, contacts.email, contacts.message, contacts.user_role,
                           contacts.company_name, contacts.number_of_employees)

        return {"status": "success", "response": "Email send successfully"}

    except:
        logging.error("Exception occurred. User not able to register", exc_info=True)


@app.get("/contact_list", tags=["Contact Us Methods"], dependencies=[Depends(JWTBearer())])
async def contact_list(db: Session = Depends(get_db)):
    contact_list = db.query(models.Contact).all()
    if contact_list is None:
        return {"status": "failed", "response": f"users cannot be listed"}

    return {"status": "success", "response": contact_list}


async def user_reply(email, name, reply, messages):
    subject = "Ktizo - Reply for Contact Message"
    recipient = [email]
    message = f"""Hi {name.capitalize()},
<!DOCTYPE html>
<html>
<body>
<div>

<p>Thanks for contacting us.</p>

<p>We've received your following message:</p>

<p>"{messages}"</p>

<p>You can see the reply below:</p>

<p>"{reply}"</p>

<p>Thank you,</p>
<p>Malcolm Coronel</p>
<p>Founder & CEO of Ktizo</p.
<div>
</body>
</html>  
    """
    await emailutil.send_email(recipient, subject, message)


# To reply a user
@app.post("/update_contact", tags=["Contact Us Methods"], dependencies=[Depends(JWTBearer())])
async def update_contact(contacts: schemas.Update_Contact, db: Session = Depends(get_db)):
    try:

        contact_details = db.query(models.Contact).filter(models.Contact.id == contacts.id).first()
        if contact_details is not None:
            for name, value in dict(contacts).items():
                setattr(contact_details, name, value)

            db.add(contact_details)
            db.commit()
        await user_reply(contacts.email, contacts.name, contacts.reply, contacts.message)

        return {"status": "success", "response": "Email send successfully"}

    except:
        logging.error("Exception occurred. User not able to register", exc_info=True)


@app.post("/view_contact", tags=["Contact Us Methods"], dependencies=[Depends(JWTBearer())])
async def view_contact(contacts: schemas.Update_Contact, db: Session = Depends(get_db)):
    try:

        contact_details = db.query(models.Contact).filter(models.Contact.id == contacts.id).first()
        return {"status": "success", "response": contact_details}

    except:
        logging.error("Exception occurred. User not able to register", exc_info=True)
