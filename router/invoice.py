import uuid
import logging
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer
from sqlalchemy.sql import func

app = APIRouter()


# get invoice data
@app.get("/invoice", tags=["payments"], dependencies=[Depends(JWTBearer())])
async def invoice(id: uuid.UUID, artist_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user_details = db.query(models.Invoice.id.label("invoice_id"), models.Invoice.song_id,
                                func.to_char(models.Invoice.date, 'MM/DD/YYYY').label("date"), models.Songs.music_title,
                                models.User_details.id.label("artist_id"),
                                models.User_details.full_name.label("artist_name")).select_from(models.Invoice).join(
            models.Songs, isouter=True).join(
            models.User_details, isouter=True).filter(models.Invoice.supervisor_id == id).filter(
            models.Songs.user_id == artist_id).filter(
            models.User_details.id == artist_id).filter(models.User_details.active_status == 0).all()
        if user_details:
            return {"status": "success", "response": user_details}
        else:
            logging.info(
                "Unable to get invoice details", exc_info=True
            )
            return {
                "status": "failed",
                "response": "Unable to get invoice details",
            }

    except:
        logging.error("Exception occurred. Unable to get invoice details", exc_info=True)


# get invoice lastpage data
@app.get("/final_invoice", tags=["payments"], dependencies=[Depends(JWTBearer())])
async def invoice(invoice_id: int, artist_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        get_artist_data = db.query(models.User_details).filter(models.User_details.id == artist_id).filter(
            models.User_details.active_status == 0).first()
        if get_artist_data is not None:
            user_details = db.query(models.Invoice, models.Licence, models.Songs, models.Payment).select_from(
                models.Invoice).join(
                models.Licence, isouter=True).join(models.Songs, isouter=True).join(models.Payment,
                                                                                    isouter=True).filter(
                models.Invoice.id == invoice_id).first()
            if user_details is not None:
                get_artist = db.query(models.User_details).filter(models.User_details.id == artist_id).first()
                get_user = db.query(models.User_details).filter(
                    models.User_details.id == user_details['Licence'].user_id).first()
                total_value = int(user_details['Licence'].onetime_fee) + int(
                    user_details['Licence'].direct_performancefee) + int(
                    user_details['Licence'].master_licencefee) + int(user_details['Licence'].sync_licencefee) + int(
                    user_details['Licence'].master_licencefee) + int(user_details['Licence'].performance_fee)
                result = {
                    "onetime_fee": user_details['Licence'].onetime_fee,
                    "direct_performancefee": user_details['Licence'].direct_performancefee,
                    "master_licencefee": user_details['Licence'].direct_performancefee,
                    "sync_licencefee": user_details['Licence'].sync_licencefee,
                    "master_licencefee": user_details['Licence'].master_licencefee,
                    "performance_fee": user_details['Licence'].performance_fee,
                    "total": total_value,
                    "date": user_details['Invoice'].date.strftime("%m/%d/%Y"),
                    "invoice_number": invoice_id,
                    "music_title": user_details['Songs'].music_title,
                    "supervisor_name": get_user.full_name,
                    "supervisor_address": get_user.company,
                    "supervisor_email": get_user.email,
                    "artist_name": get_artist.full_name,
                    "Legal_name": get_artist.legal_name,
                    "payment_status": user_details['Payment'].status if user_details['Payment'] else None

                }
                return {"status": "success", "response": result}

            else:
                logging.info(
                    "Unable to get invoice details", exc_info=True
                )
                return {
                    "status": "failed",
                    "response": "Unable to get invoice details",
                }
        else:
            logging.info(
                "No Data Found", exc_info=True
            )
            return {
                "status": "failed",
                "response": "No Data Found",
            }

    except:
        logging.error("Exception occurred. Unable to get invoice details", exc_info=True)
