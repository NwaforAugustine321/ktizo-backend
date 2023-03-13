import uuid
import logging
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer
from sqlalchemy.sql import func
from sqlalchemy import case

app = APIRouter()


# Get all songs which are approved
# Take the count of songs which is lincence quoted
# Take the count of songs which is licence approved
@app.get("/sync_songs/{id}", tags=["songs"], dependencies=[Depends(JWTBearer())])
def sync_songs(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user_details = db.query(models.User_details).filter(models.User_details.id == id).filter(
            models.User_details.active_status == 0).first()

        if user_details is not None:
            songs = db.query(models.Songs, func.to_char(
                models.Songs.upload_date, 'MM/DD/YYYY').label("upload_date"),
                             func.count(models.Licence.song_id).label("like_count"),
                             func.count(case([(models.Licence.status == "1", 1)])).label("sync_count")
                             ).join(models.Licence, isouter=True
                                    ).filter(models.Songs.user_id == id
                                             ).filter(models.Songs.status == 1).group_by(models.Songs.id).all()

            logging.info("Sync songs are fetched", exc_info=True)
            return {"status": "success", "response": songs}
        else:
            logging.info("User doesnot exists", exc_info=True)
            return {"status": "failed", "response": "User doesnot exists"}
    except:
        logging.error("Exception occurred. Unable to take sync songs", exc_info=True)


# top ten songs
@app.get("/topten_songs/{id}", tags=["songs"], dependencies=[Depends(JWTBearer())])
def topten_songs(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user_details = db.query(models.User_details).filter(models.User_details.id == id).filter(
            models.User_details.active_status == 0).first()
        if user_details is not None:
            songs = db.query(models.Songs,
                             func.count(models.Licence.song_id).label("like_count"),
                             func.count(case([(models.Licence.status == "1", 1)])).label("sync_count"),
                             func.count(case([(models.Licence.status == "1", 1)])).label("licenses_count")
                             ).join(models.Licence, isouter=True
                                    ).filter(models.Songs.user_id == id
                                             ).filter(models.Songs.status == 1).group_by(models.Songs.id).all()
            song_data_sorted = sorted(songs, key=lambda i: i['like_count'], reverse=True)[:10]

            logging.info("Top ten songs are fetched", exc_info=True)
            return {"status": "success", "response": song_data_sorted}
        else:
            logging.info("User doesnot exists", exc_info=True)
            return {"status": "failed", "response": "User doesnot exists"}
    except:
        logging.error("Exception occurred. Unable to get top ten songs", exc_info=True)


@app.get("/sync_count/{id}", tags=["songs"], dependencies=[Depends(JWTBearer())])
def sync_count(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user_details = db.query(models.User_details).filter(models.User_details.id == id).filter(
            models.User_details.active_status == 0).first()
        if user_details is not None:
            syncs_count = db.query(models.Songs, models.Licence
                                   ).join(models.Licence
                                          ).filter(models.Songs.user_id == id
                                                   ).filter(models.Licence.status == 1).count()
            logging.info("Sync songs are fetched", exc_info=True)
            return {"status": "success", "response": {"user_id": id, "sync_count": syncs_count}}
        else:
            logging.info("User doesnot exists", exc_info=True)
            return {"status": "failed", "response": "User doesnot exists"}
    except:
        logging.error("Exception occurred. Unable to take sync songs", exc_info=True)
