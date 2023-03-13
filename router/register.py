import schemas
import uuid
import logging
import requests
from pydantic import BaseModel

from config.config import settings
from db.models import User_details
from hash.hash import Hasher
from utils import emailutil
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from fastapi.responses import HTMLResponse
from auth.jwt_bearer import JWTBearer

app = APIRouter()


async def user_email(email, full_name):
    subject = "Early Access to Ktizo"
    recipient = [email]
    message = f"""Hi {full_name.capitalize()},
<!DOCTYPE html>
<html>
<body>
<div>
<p>Thanks for your interest in Ktizo! </p>

<p>We will update you when we officially launch and make sure you have immediate access to our platform.</p>

<p>We're excited to onboard you to Ktizo and serve all your music licensing needs. </p>

<p>Stay tuned by frequently visiting our website www.ktizo.io</p>
  
<p>Thank you,</p>
<p>Malcolm Coronel</p>
<p>Founder & CEO of Ktizo </p>  
</div>
</body>
</html>
"""
    await emailutil.send_email(recipient, subject, message)


async def client_email(email, full_name, user_role):
    subject = "Ktizo-User Registration"
    recipient = ["launch@ktizo.io"]

    message = f"""Hi Malcom,
<!DOCTYPE html>
<html>
<body>
<div>
<p>Ktizo-User Registration</p>

<p>{full_name.capitalize()}</p>
<p>{user_role.capitalize()}</p>
<p>{email}</p>
   
<p>Thanks and Regards </p>
</div>
</body>
</html>
   
    """
    await emailutil.send_email(recipient, subject, message)


# To signup a user
@app.post("/register", tags=["auth"])
async def user_register(user_data: schemas.user_notify, db: Session = Depends(get_db)):
    try:
        user_register = db.query(models.Email_details).filter(models.Email_details.email == user_data.email).first()
        if user_register is None:
            notify_user = models.Email_details(
                id=uuid.uuid4(),
                full_name=user_data.full_name,
                email=user_data.email,
                user_role=user_data.user_role,
            )
            db.add(notify_user)
            db.commit()
            await user_email(notify_user.email, notify_user.full_name)
            await client_email(notify_user.email, notify_user.full_name, notify_user.user_role)

            return {"status": "success", "response": "Email send successfully"}
        else:
            return {"status": "failed", "response": "Email  already taken"}
    except:
        logging.error("Exception occurred. User not able to register", exc_info=True)


# To signup a user
# @app.post("/login_with_spotify", tags=["auth"])
# async def user_register(access_token: str, db: Session = Depends(get_db)):
#     request_url = "	https://api.spotify.com/v1/me"
#
#     headers = {
#         "Content-Type": "application/json",
#         "Authorization": f"Bearer {access_token}"
#     }
#
#     try:
#         response = requests.get(request_url, headers=headers)
#         spotify_data = response.json()
#
#         db_user = db.query(models.User_details).filter(models.User_details.email == spotify_data.get('email')).first()
#
#         if db_user:
#             update_user = {
#                 "user_role": "Artist",
#                 "token": access_token,
#                 "spotify_user_id": spotify_data.get('id'),
#                 "country": spotify_data.get('country'),
#                 "spotify_user_name": spotify_data.get('display_name'),
#                 "account_id": spotify_data.get('uri'),
#                 "profile_pic": spotify_data.get('images', '')[0].get('url', '') if spotify_data.get('images', '')[
#                     0] else ''
#             }
#             for name, value in update_user.items():
#                 setattr(db_user, name, value)
#             db.add(db_user)
#             db.commit()
#             db.refresh(db_user)
#             return {"status": "success", "response": db_user}
#         else:
#             new_id = uuid.uuid4()
#             new_user = models.User_details(
#                 id=new_id,
#                 full_name=spotify_data.get('display_name'),
#                 password=Hasher.get_hash_password(settings.DEFAULT_USER_PASSWORD),
#                 email=spotify_data.get('email'),
#                 user_role="Artist",
#                 token=access_token,
#                 spotify_user_id=spotify_data.get('id'),
#                 country=spotify_data.get('country'),
#                 spotify_user_name=spotify_data.get('display_name'),
#                 account_id=spotify_data.get('uri'),
#                 profile_pic=spotify_data.get('images', '')[0].get('url', '') if spotify_data.get('images', '')[
#                     0] else ''
#             )
#             db.add(new_user)
#             db.commit()
#             db.refresh(new_user)
#
#             logging.info("profile updated successfully", exc_info=True)
#             return {"status": "success", "response": new_user}
#
#     except requests.exceptions.HTTPError as err:
#         raise SystemExit(err)


@app.get("/user_list", tags=["users"], dependencies=[Depends(JWTBearer())])
async def users_list(db: Session = Depends(get_db)):
    user_list = db.query(models.Email_details).all()
    if user_list is None:
        return {"status": "failed", "response": f"users cannot be listed"}

    return {"status": "success", "response": user_list}


@app.delete("/delete_user/{id}", tags=["users"], dependencies=[Depends(JWTBearer())])
def delete_user(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user_obj = db.query(models.Email_details).filter(models.Email_details.id == id).first()
        if user_obj is not None:
            db.delete(user_obj)
            db.commit()
        return {"status": "success", "response": f"user with id {id} deleted"}
    except Exception as e:
        logging.error("Exception occurred. Cannot delete the user", exc_info=True)


@app.patch("/remove_user/{id}", tags=["users"], dependencies=[Depends(JWTBearer())])
def remove_user(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user_data = db.query(models.User_details).filter(models.User_details.id == id).first()
        if user_data is not None:
            update_data = {
                "active_status": 1
            }
            for name, value in update_data.items():
                setattr(user_data, name, value)
            db.add(user_data)
            db.commit()
        return {"status": "success", "response": f"user with id {id} deleted"}
    except Exception as e:
        logging.error("Exception occurred. Cannot delete the user", exc_info=True)
