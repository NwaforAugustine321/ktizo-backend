import uuid
import schemas
import logging
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer

app = APIRouter()


# get notification data
@app.get("/notification/{id}", tags=["notification"], dependencies=[Depends(JWTBearer())])
async def notification(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user_details = db.query(models.Notification.song_id, models.Notification.id, models.Notification.seen,
                                models.Notification.date,
                                models.Notification.music_title, models.Notification.status,
                                models.Notification.user_id, models.Notification.artist_id,
                                models.Notification.datetime).filter(
            models.Notification.artist_id == id).filter(models.Notification.seen == 0).all()
        if user_details:
            result = []
            for user in user_details:
                user_data = db.query(models.Songs).filter(models.Songs.id == user.song_id).first()
                get_data = db.query(models.User_details.full_name).filter(
                    models.User_details.id == user.user_id).first()
                data = {"song_id": user.song_id,
                        "music_title": user.music_title,
                        "date": user.date.strftime("%m/%d/%Y"),
                        "status": user.status,
                        "song_image": user_data.image_url,
                        "supervisor_name": get_data.full_name,
                        "seen": user.seen,
                        "notification_id": user.id,
                        "datetime": user.datetime
                        }
                result.append(data)
            data_sorted = sorted(result, key=lambda i: i['datetime'], reverse=True)[:20]

            return {"status": "success", "response": data_sorted}
        else:
            logging.info(
                "No Data Found", exc_info=True
            )
            return {
                "status": "failed",
                "response": "No Data Found",
            }

    except:
        logging.error("Exception occurred.No Data Found", exc_info=True)


# Notification seen status update
@app.patch("/notification_seenstatus_update", tags=["notification"], dependencies=[Depends(JWTBearer())])
async def notification_update(edit_seen: schemas.Notificationseen_update, db: Session = Depends(get_db)):
    try:
        user_data = (
            db.query(models.Notification).filter(
                models.Notification.id == edit_seen.notification_id).first()
        )
        if user_data is not None:
            update_data = {
                "seen": edit_seen.seen,
            }
            for name, value in update_data.items():
                setattr(user_data, name, value)
            db.add(user_data)
            db.commit()
            logging.info("status updated ", exc_info=True)
            return {
                "status": "success",
                "response": "seen status updated"
            }
        else:
            logging.info(
                "seen status not updated", exc_info=True
            )
            return {
                "status": "failed",
                "response": "seen status not updated",
            }
    except Exception:
        logging.error("Exception occurred.seen status cannot be update", exc_info=True)
        return {"status": "failed", "response": "seen status cannot be update"}
