import schemas
import logging
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from hash.hash import Hasher
from auth.jwt_bearer import JWTBearer
import uuid

app = APIRouter()


# for changing the password of user account
@app.patch("/update_password", tags=["auth"], dependencies=[Depends(JWTBearer())])
def update_password(
        change_password: schemas.Update_Password, db: Session = Depends(get_db)
):
    try:
        user_data = (
            db.query(models.User_details).filter(
                models.User_details.id == change_password.user_id).filter(
                models.User_details.active_status == 0).first()
        )
        if user_data is not None:
            update_data = {
                "password": Hasher.get_hash_password(change_password.password)
            }
            for name, value in update_data.items():
                setattr(user_data, name, value)
            db.add(user_data)
            db.commit()
            logging.info("password changed successfully", exc_info=True)
            return {
                "status": "success",
                "response": f"password changed successfully for user with user_id {change_password.user_id}",
            }
        else:
            logging.info(
                f"user with id {change_password.user_id} doesn't exists", exc_info=True
            )
            return {
                "status": "failed",
                "response": f"user with id {change_password.user_id} doesn't exists",
            }
    except Exception:
        logging.error("Exception occurred. Password cannot be changed", exc_info=True)
        return {"status": "failed", "response": "password changed successfully"}


# Edit artist profile page
@app.patch("/edit_artist", tags=["users"], dependencies=[Depends(JWTBearer())])
async def edit_artist(edit_profile: schemas.Edit_artist, db: Session = Depends(get_db)):
    try:
        user_data = (
            db.query(models.User_details).filter(
                models.User_details.id == edit_profile.user_id).filter(models.User_details.active_status == 0).first()
        )
        if user_data is not None:
            update_data = {
                "full_name": edit_profile.artist_name,
                "spotify_artist_profile": edit_profile.spotify_profile,
                "legal_name": edit_profile.legal_name,
                "email": edit_profile.email,
                "profile_pic": edit_profile.profile_pic,
                "about_me": edit_profile.about_me,
                "country": edit_profile.country,
                "state": edit_profile.state,
                "city": edit_profile.city,
                "zip": edit_profile.zip,
                "label": edit_profile.label,
                "writerPRO": edit_profile.writerPRO,
                "writerIPI": edit_profile.writerIPI,
                "publisherName": edit_profile.publisherName,
                "publisherPRO": edit_profile.publisherPRO,
                "publisherIPI": edit_profile.publisherIPI
            }
            for name, value in update_data.items():
                setattr(user_data, name, value)
            db.add(user_data)
            db.commit()
            user_data = db.query(models.User_details).filter(models.User_details.id == edit_profile.user_id).first()
            user_data.__dict__.pop("password")
            logging.info("profile updated successfully", exc_info=True)
            return {
                "status": "success",
                "response": f"profile updated successfully for user with user_id {edit_profile.user_id}",
                "user_data": {user_data}
            }
        else:
            logging.info(
                f"user with id {edit_profile.user_id} doesn't exists", exc_info=True
            )
            return {
                "status": "failed",
                "response": f"user with id {edit_profile.user_id} doesn't exists",
            }
    except Exception:
        logging.error("Exception occurred. profile cannot be update", exc_info=True)
        return {"status": "failed", "response": "profile cannot be update"}


# Edit supervisor profile page
@app.patch("/edit_supervisor", tags=["users"], dependencies=[Depends(JWTBearer())])
async def edit_supervisor(edit_profile: schemas.Edit_supervisor, db: Session = Depends(get_db)):
    try:
        user_data = (
            db.query(models.User_details).filter(
                models.User_details.id == edit_profile.user_id).filter(models.User_details.active_status == 0).first()
        )
        if user_data is not None:
            update_data = {
                "full_name": edit_profile.name,
                "company": edit_profile.company,
                "email": edit_profile.email,
                "linkedin_profile": edit_profile.linkedin_profile,
                "profile_pic": edit_profile.profile_pic,
                "about_me": edit_profile.about_me,
                "country": edit_profile.country,
                "state": edit_profile.state,
                "city": edit_profile.city,
                "zip": edit_profile.zip

            }
            for name, value in update_data.items():
                setattr(user_data, name, value)
            db.add(user_data)
            db.commit()
            user_data = db.query(models.User_details).filter(models.User_details.id == edit_profile.user_id).first()
            user_data.__dict__.pop("password")
            logging.info("profile updated successfully", exc_info=True)
            return {
                "status": "success",
                "response": f"profile updated successfully for user with user_id {edit_profile.user_id}",
                "user_data": user_data
            }
        else:
            logging.info(
                f"user with id {edit_profile.user_id} doesn't exists", exc_info=True
            )
            return {
                "status": "failed",
                "response": f"user with id {edit_profile.user_id} doesn't exists",
            }
    except Exception:
        logging.error("Exception occurred. profile cannot be update", exc_info=True)
        return {"status": "failed", "response": "profile cannot be update"}


@app.post("/feedback", tags=["users"], dependencies=[Depends(JWTBearer())])
async def user_feedback(feedbacks: schemas.Feedback, db: Session = Depends(get_db)):
    try:
        user_data = (
            db.query(models.User_details)
                .filter(models.User_details.id == feedbacks.user_id).filter(models.User_details.active_status == 0)
                .first()
        )
        if user_data is not None:
            id = uuid.uuid4()
            review_data = models.Feedback(
                id=id,
                user_id=feedbacks.user_id,
                easyto_understand=feedbacks.easyto_understand,
                songs_satisfaction=feedbacks.songs_satisfaction,
                easyto_navigate=feedbacks.easyto_navigate,
                licensing_effective=feedbacks.licensing_effective,
                improve_ideas=feedbacks.improve_ideas)
            db.add(review_data)
            db.commit()
            rating = db.query(models.Feedback).filter(models.Feedback.id == id).first()
            logging.info("Feedback submitted successfully", exc_info=True)
            return {
                "status": "success",
                "response": "Feedback submitted successfully"
            }
        else:
            logging.info(
                f"Unable to submit feedback", exc_info=True
            )
            return {
                "status": "failed",
                "response": "Unable to submit feedback",
            }
    except Exception:
        logging.error("Unable to submit feedback", exc_info=True)
        return {"status": "failed", "response": "Unable to submit feedback"}
