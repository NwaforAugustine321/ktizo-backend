import schemas
import uuid
import logging
from db.models import User_details
from utils import emailutil
from fastapi import APIRouter, Depends, Header
from sqlalchemy.orm import Session
import stripe
from db.database import get_db, SessionLocal
from datetime import date
from db import models
from datetime import datetime
import socket
from fastapi import Request
from auth.jwt_bearer import JWTBearer
from fastapi_utils.tasks import repeat_every
from config.config import settings

app = APIRouter()

stripe.api_key = settings.STRIPE_SECRET_KEY
endpoint_secret = settings.WEBHOOK_SECRET_KEY


@app.post("/payment", tags=["payments"])
def generate_card_token(user_data: schemas.Payment, db: Session = Depends(get_db)):
    try:
        user_details = db.query(models.Invoice, models.Licence).join(models.Licence, isouter=True).filter(
            models.Invoice.supervisor_id == user_data.supervisor_id).filter(
            models.Invoice.id == user_data.invoice_number).first()
        if user_details is not None:
            amount_check = int(user_details['Licence'].onetime_fee) + int(
                user_details['Licence'].direct_performancefee) + int(user_details['Licence'].sync_licencefee) + int(
                user_details['Licence'].master_licencefee) + int(user_details['Licence'].performance_fee)
            data = stripe.Token.create(
                card={
                    "number": user_data.card_number,
                    "exp_month": user_data.expmonth,
                    "exp_year": user_data.expyear,
                    "cvc": user_data.cvv,
                })
            card_token = data['id']
            payment = stripe.Charge.create(
                amount=int(user_data.amount) * 100,
                currency='usd',
                description='Example charge',
                source=card_token
            )
            if amount_check == int(user_data.amount):
                percentage_amount = amount_check * (70 / 100)
                today_date = date.today()
                payment_data = models.Payment(
                    supervisor_id=user_data.supervisor_id,
                    invoice_id=user_data.invoice_number,
                    stripe_id=payment.id,
                    email=payment['billing_details'].email,
                    amount=int(percentage_amount),
                    receipt_url=payment.receipt_url,
                    amount_before_reduction=user_data.amount,
                    status=payment.status,
                    date=today_date)
                db.add(payment_data)
                db.commit()
                check_success = db.query(models.Payment).filter(
                    models.Payment.invoice_id == user_data.invoice_number).first()
                if check_success is not None:
                    if check_success.status == "succeeded":
                        get_songdata = db.query(models.Invoice, models.Songs).join(
                            models.Songs, isouter=True).filter(models.Invoice.id == user_data.invoice_number).first()
                        get_artistdata = db.query(models.User_details).filter(
                            models.User_details.id == get_songdata['Songs'].user_id).first()
                        id = uuid.uuid4()
                        myearnings_data = models.My_Earnings(
                            id=id,
                            artist_id=get_artistdata.id,
                            invoice_number=user_data.invoice_number,
                            date=date.today(),
                            artist_name=get_artistdata.full_name,
                            total_amount=int(percentage_amount))
                        db.add(myearnings_data)
                        db.commit()
                        return {"status": "success"}
                    else:
                        return {"status": "payment failed"}
            else:
                return {"status": "Please check amount"}
        else:
            return {"status": "failed", "response": "Payment not successfull"}
    except Exception as err:
        logging.error("Exception occurred. payment not successfull", exc_info=True)
        return err._message


@app.post("/transfer_to_artist", tags=["payments"], dependencies=[Depends(JWTBearer())])
def transfer_to_artist(user_input: schemas.Transfer_amount, db: Session = Depends(get_db)):
    try:
        element = datetime.now()
        timestamp = datetime.timestamp(element)
        host_name = socket.gethostname()
        host_ip = socket.gethostbyname(host_name)
        # to create the account connected 
        user_details = db.query(models.User_details).filter(models.User_details.id == user_input.artist_id).first()
        if user_details.account_id == None:
            create_account = stripe.Account.create(
                type="custom",
                country="US",
                email=user_input.email,
                capabilities={
                    "transfers": {"requested": True},
                },
                external_account=
                {
                    "account_number": user_input.account_number,
                    "object": "bank_account",
                    "country": "US",
                    "currency": "usd",
                    "routing_number": user_input.routing_number
                },
                tos_acceptance={
                    "date": int(timestamp),
                    "ip": host_ip},
                business_type="company",
                company={"name": user_input.company_legal_name, "tax_id": user_input.business_tax_id},
                business_profile={
                    "url": "www.ktizo.com",
                    "name": user_input.business_name,
                }
            )
            update_value = {
                "account_id": create_account.external_accounts.data[0].account
            }
            for name, value in update_value.items():
                setattr(user_details, name, value)
            db.add(user_details)
            db.commit()
            a = stripe.Account.modify(
                create_account.external_accounts.data[0].account,
                settings={"payouts": {"schedule": {"interval": "manual"}}},
            )
            # to transfer the amount
            transfer = stripe.Transfer.create(
                amount=int(user_input.amount) * 100,
                currency="usd",
                destination=create_account.external_accounts.data[0].account,
            )
            id = uuid.uuid4()
            withdrawal_data = models.Withdrawal(
                id=id,
                artist_id=user_input.artist_id,
                amount=user_input.amount,
                date=date.today())
            db.add(withdrawal_data)
            db.commit()
            return transfer
        else:
            # to transfer the amount
            user_account = db.query(models.User_details.account_id).filter(
                models.User_details.id == user_input.artist_id).first()
            stripe.Account.modify(
                user_account.account_id,
                email=user_input.email,
                capabilities={
                    "transfers": {"requested": True},
                },
                external_account=
                {
                    "account_number": user_input.account_number,
                    "object": "bank_account",
                    "country": "US",
                    "currency": "usd",
                    "routing_number": user_input.routing_number
                },
                tos_acceptance={
                    "date": int(timestamp),
                    "ip": host_ip
                },
                business_type="company",
                company={"name": user_input.company_legal_name, "tax_id": user_input.business_tax_id},
                business_profile={
                    "url": "www.ktizo.com",
                    "name": user_input.business_name,
                }
            )
            transfer = stripe.Transfer.create(
                amount=int(user_input.amount) * 100,
                currency="usd",
                destination=user_details.account_id,
            )
            id = uuid.uuid4()
            withdrawal_data = models.Withdrawal(
                id=id,
                artist_id=user_input.artist_id,
                amount=user_input.amount,
                date=date.today())
            db.add(withdrawal_data)
            db.commit()
            if transfer is not None:
                update_value = {
                    "status": 1
                }
                for name, value in update_value.items():
                    setattr(withdrawal_data, name, value)
                db.add(withdrawal_data)
                db.commit()
                return {"status": "success"}
            else:
                return {"status": " Withdrawal failed"}
    except Exception as err:
        logging.error("Exception occurred. payment not successfull", exc_info=True)
        return err._message


@app.post("/ACH-payment", tags=["payments"], dependencies=[Depends(JWTBearer())])
def ACH_Payment(user_data: schemas.ACH_Payment, db: Session = Depends(get_db)):
    try:
        user_details = db.query(models.Invoice, models.Licence, models.Songs).select_from(models.Invoice).join(
            models.Licence, isouter=True).join(models.Songs, isouter=True).filter(
            models.Invoice.supervisor_id == user_data.supervisor_id).filter(
            models.Invoice.id == user_data.invoice_number).first()
        if user_details is not None:
            amount_check = int(user_details['Licence'].onetime_fee) + int(
                user_details['Licence'].direct_performancefee) + int(user_details['Licence'].sync_licencefee) + int(
                user_details['Licence'].master_licencefee) + int(user_details['Licence'].performance_fee)
            intent = stripe.checkout.Session.create(
                line_items=[{
                    'price_data': {
                        'currency': 'usd',
                        'product_data': {
                            'name': user_details['Songs'].music_title,
                        },
                        'unit_amount': amount_check * 100,
                    },
                    'quantity': 1,
                }],
                mode='payment',
                success_url='https://ktizo.io/supervisorDashboard/SuccessPage',
                cancel_url='https://ktizo.io/supervisorDashboard/invoice',
            )
            get_artist = db.query(models.Songs, models.User_details).join(models.User_details).filter(
                models.Songs.id == user_details['Songs'].id).first()
            if get_artist['User_details'].coupon_code is not None:
                if get_artist['User_details'].coupon_status == 0:
                    percentage_amount = amount_check * (87.5 / 100)
                    payment_data = models.Payment(
                        supervisor_id=user_data.supervisor_id,
                        invoice_id=user_data.invoice_number,
                        stripe_id=intent.payment_intent,
                        amount=int(percentage_amount),
                        amount_before_reduction=amount_check,
                        song_id=user_details['Songs'].id,
                        date=date.today())
                    db.add(payment_data)
                    db.commit()
                    coupon_status = db.query(models.User_details).filter(
                        models.User_details.id == get_artist['User_details'].id).first()
                    update_data = {
                        "coupon_status": 1,
                    }
                    for name, value in update_data.items():
                        setattr(coupon_status, name, value)
                    db.add(coupon_status)
                    db.commit()
                    return intent.url
                else:
                    percentage_amount = amount_check * (75 / 100)
                    payment_data = models.Payment(
                        supervisor_id=user_data.supervisor_id,
                        invoice_id=user_data.invoice_number,
                        stripe_id=intent.payment_intent,
                        amount=int(percentage_amount),
                        amount_before_reduction=amount_check,
                        song_id=user_details['Songs'].id,
                        date=date.today())
                    db.add(payment_data)
                    db.commit()
                    return intent.url
            else:
                percentage_amount = amount_check * (75 / 100)
                payment_data = models.Payment(
                    supervisor_id=user_data.supervisor_id,
                    invoice_id=user_data.invoice_number,
                    stripe_id=intent.payment_intent,
                    amount=int(percentage_amount),
                    amount_before_reduction=amount_check,
                    song_id=user_details['Songs'].id,
                    date=date.today())
                db.add(payment_data)
                db.commit()
                return intent.url
        else:
            return {"status": "failed", "response": "Payment not successfull"}
    except:
        logging.error("Exception occurred. payment not successfull", exc_info=True)


@app.get("/ACH-success-check", tags=["payments"])
def ACH_success_check(id: uuid.UUID, invoice_number: int, db: Session = Depends(get_db)):
    try:
        get_data = db.query(models.Payment).filter(models.Payment.supervisor_id == id).filter(
            models.Payment.invoice_id == invoice_number).first()
        if get_data is not None:
            # if get_data.status == "pending":
            intent_retrive = stripe.PaymentIntent.retrieve(
                get_data.stripe_id,
            )
            if intent_retrive['status'] == "requires_action":
                update_value = {"status": "processing"}
                for name, value in update_value.items():
                    setattr(get_data, name, value)
                db.add(get_data)
                db.commit()
                return intent_retrive['next_action'].verify_with_microdeposits.hosted_verification_url
            else:
                return {"status": "success"}
        # else:
        #     return {"status":"success"}
    except:
        logging.error("Exception occurred. payment not successfull", exc_info=True)


@app.post("/ACH-success",  tags=["payments"])
async def webhook_received(request: Request, stripe_signature: str = Header(None), db: Session = Depends(get_db)):
    try:
        data = await request.body()
        try:
            event = stripe.Webhook.construct_event(
                payload=data,
                sig_header=stripe_signature,
                secret=endpoint_secret
            )
            logging.info(event, exc_info=True)
        except Exception as e:
            logging.info("e..", e)
            return e
        if event["type"] == "charge.succeeded":
            payment_intent_id = event['data']['object']['payment_intent']
            payment_success = event['data']['object']['status']
            receipt_url = event['data']['object']['receipt_url']
            receipt_created = event['data']['object']['created']
            receipt_created_date = datetime.fromtimestamp(receipt_created)
            email = event['data']['object']["billing_details"]["email"]
            get_data = db.query(models.Payment).filter(models.Payment.stripe_id == payment_intent_id).first()
            if get_data is not None:
                update_data = {
                    "status": payment_success,
                    "receipt_created_date": receipt_created_date,
                    "receipt_url": receipt_url,
                    "email": email
                }
                for name, value in update_data.items():
                    setattr(get_data, name, value)
                db.add(get_data)
                db.commit()
                artist_data = db.query(models.Songs, User_details).join(models.User_details, isouter=True).filter(
                    models.Songs.id == get_data.song_id).first()
                id = uuid.uuid4()
                myearnings_data = models.My_Earnings(
                    id=id,
                    artist_id=artist_data['User_details'].id,
                    invoice_number=get_data.invoice_id,
                    date=date.today(),
                    artist_name=artist_data['User_details'].full_name,
                    total_amount=int(get_data.amount))
                db.add(myearnings_data)
                db.commit()
                await payment_email(email, receipt_url)
                logging.info("status updated ", exc_info=True)
                return {
                    "status": "success",
                    "response": "status updated"
                }

    except Exception as e:
        return {"error": str(e)}


async def payment_email(email, receipt_url):
    subject = "Ktizo - Payment details"
    recipient = [email]
    message = f"""
<!DOCTYPE html>
<html>
<body>
<div style="width:100%; font-family: monospace;">
<p><a href={receipt_url}> <button type ="button">click here to view your payment receipt</button></a></p>
</div>
</body>
</html>
        """
    await emailutil.send_email(recipient, subject, message)


@app.get("/coupon_expired", tags=["payments"])
def coupon_expired():
    db = SessionLocal()
    get_data = db.query(models.User_details).all()
    if get_data is not None:
        for result in get_data:
            if result.coupon_created_date is not None:
                date1 = date.today() - (result.coupon_created_date.date())
                user_data = db.query(models.User_details).filter(models.User_details.id == result.id).first()
                if (date1.days) >= 180:
                    update_data = {
                        "coupon_status": 1,
                    }
                    for name, value in update_data.items():
                        setattr(user_data, name, value)
                    db.add(user_data)
                    db.commit()
        db.close()
        return {"Successfully Updated"}
    else:
        db.close()
        return {"Not Updated"}


@app.on_event("startup")
@repeat_every(seconds=86400, wait_first=False)
def periodic():
    coupon_expired()
