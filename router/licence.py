import logging
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer
import uuid
from datetime import datetime, date
import schemas

from dependencies.profiles import get_active_profile_by_id
from dependencies.songs import get_user_and_his_song_by_id
from utils import strings, emailutil

app = APIRouter()


@app.get("/licence", tags=["licence"], dependencies=[Depends(JWTBearer())])
async def licence(song_id: uuid.UUID, user_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        get_artist = db.query(models.Songs, models.User_details).join(models.User_details, isouter=True).filter(
            models.Songs.id == song_id).filter(
            models.User_details.active_status == 0).first()
        if get_artist is not None:
            details = db.query(models.Licence).filter(models.Licence.user_id == user_id).filter(
                models.Licence.song_id == song_id).first()
            if details is not None:
                get_user = db.query(models.User_details).filter(models.User_details.id == user_id).first()

                project_response = {}
                if details.project_id is not None:
                    project_data = db.query(models.Projects, models.Project_Types).join(models.Project_Types,
                                                                                        isouter=True).filter(
                        models.Projects.id == details.project_id).first()

                    project = project_data['Projects']
                    project_type = project_data['Project_Types']

                    project_response = {
                        "id": project.id,
                        "name": project.name,
                        "description": project.description,
                        "project_type_id": project_type.id if project_type else "",
                        "project_type": project_type.name if project_type else "",
                        "type_cost": project_type.cost if project_type else ""

                    }

                result = {
                    "artist_name": get_user.full_name,
                    "id": details.id,
                    "user_id": details.user_id,
                    "song_id": details.song_id,

                    "date": details.date,
                    "email": details.email,
                    "label": details.label,
                    "percentage": details.percentage,
                    "writers": details.writers,
                    "publishers": details.publishers,
                    "fee": details.fee,
                    "use": details.use,
                    "supervisor_invoice_info": details.supervisor_invoice_info,

                    "step": details.step,
                    "is_finished": details.is_finished,
                    "licence_agreement": details.licence_agreement,
                    "payment_status": details.payment_status,
                    "status": details.status,
                    "approved_date": details.approved_date,
                    "project": project_response
                }
                return {"status": "success", "response": result}
            else:
                data = db.query(models.Songs, models.User_details).join(models.User_details, isouter=True).filter(
                    models.Songs.id == song_id).first()
                if data is not None:
                    writer_names = []
                    publisher_names = []
                    for writer in data['Songs'].writers:
                        name = writer['writerName']
                        writer_names.append(name)
                    for publisher in data['Songs'].publishers:
                        name = publisher['publisherName']
                        publisher_names.append(name)
                    supervisor = db.query(models.User_details).filter(models.User_details.id == user_id).first()
                    licence_details = {
                        "date": date.today().strftime("%m/%d/%Y"),
                        "email": data['User_details'].email,
                        "performed_by": data['User_details'].full_name,
                        "to": data['User_details'].legal_name,
                        "songid": data['Songs'].id,
                        "own_recording": data['Songs'].own_recording,
                        "master_recording": data['Songs'].music_title,
                        "supervisor_name": supervisor.full_name,
                        "supervisor_id": supervisor.id,
                        "written_by": writer_names,
                        "published_by": publisher_names,
                        "label": data['Songs'].music_title
                    }
                    return {"status": "success", "response": licence_details}
        else:
            logging.info(
                "Data Not Found", exc_info=True
            )
            return {
                "status": "failed",
                "response": "Data Not Found",
            }
    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


# @app.get("/get_licences", tags=["licence"], dependencies=[Depends(JWTBearer())])
# async def get_licences(user_id: uuid.UUID, db: Session = Depends(get_db)):
#     active_user = await get_active_profile_by_id(user_id, db)
#
#     try:
#         licence_details = db.query(models.Licence).filter(models.Licence.user_id == user_id)
#
#         if not licence_details:
#             logging.info("Licenses for user does not exist", exc_info=True)
#             return {
#                 "status": "failed",
#                 "response": "Project for this user does not exist"
#             }
#         return {"status": "success", "response": licence_details}
#
#     except:
#         logging.error(strings.BASE_SONG_ERROR, exc_info=True)
#         raise HTTPException(
#             status_code=404,
#             detail=strings.BASE_SONG_ERROR
#         )


def _is_license_is_finished(license):
    if license.licence_agreement and license.step == 3:
        return True
    else:
        return False


# save licence details
@app.patch("/licence_agreement", tags=["licence"], dependencies=[Depends(JWTBearer())])
async def create_licence_agreement(user_data: schemas.Licence_data, db: Session = Depends(get_db)):
    song = await get_user_and_his_song_by_id(user_data.user_id, user_data.song_id, db)

    try:
        if song:
            licence_details = db.query(models.Licence).filter(models.Licence.user_id == user_data.user_id).filter(
                models.Licence.song_id == user_data.song_id).first()

            today_date = date.today().strftime("%m/%d/%Y")

            if licence_details is None:
                project_upd_data = user_data.project

                # if user_data.project_id and user_data.project_type_id:
                if project_upd_data:
                    project = db.query(models.Projects).filter(models.Projects.id == project_upd_data.get('id')).first()

                    if project:
                        update_data = {
                            "project_type_id": project_upd_data.get('project_type_id'),
                            "description": project_upd_data.get("description")
                        }
                        for name, value in update_data.items():
                            setattr(project, name, value)
                        db.add(project)
                        db.commit()
                        db.refresh(project)
                        logging.info("project updated successfully", exc_info=True)
                    logging.info("project not find", exc_info=True)

                id = uuid.uuid4()

                licence_data = models.Licence(
                    id=id,
                    user_id=user_data.user_id,
                    song_id=user_data.song_id,
                    project_id=project_upd_data.get("id") if project_upd_data else None,

                    label=user_data.label,
                    email=user_data.email,
                    percentage=user_data.percentage,
                    writers=user_data.writers,
                    publishers=user_data.publishers,

                    date=today_date,

                    fee=user_data.fee,
                    use=user_data.use,
                    supervisor_invoice_info=user_data.supervisor_invoice_info,

                    step=0,
                    is_finished=False if user_data.licence_agreement is False else True,
                    payment_status=False,
                    status=user_data.status
                )
                db.add(licence_data)
                db.commit()

                # add same details to notification table
                # TODO: CHECK WHEN YOU WILL WORK ON NOTIFICATIONS
                # id2 = uuid.uuid4()
                # today_date = datetime.now().strftime("%Y/%m/%d %H:%M:%S")
                # notification_data = models.Notification(
                #     id=id2,
                #     user_id=user_data.user_id,
                #     song_id=user_data.song_id,
                #     datetime=today_date,
                #     date=date.today(),
                #     artist_id=user_data.artist_id,
                #     music_title=user_data.label,
                #     track_id=user_data.track_id,
                #     status=user_data.status)
                # db.add(notification_data)
                # db.commit()
                # like_details = db.query(models.Count_likes).filter(
                #     models.Count_likes.song_id == user_data.song_id).first()
                # if like_details is not None:
                #     a = {"user_id": str(user_data.user_id), "like": "True", "dislike": "False"}
                #     new_action = list(like_details.action)
                #     new_action.append(a)
                #     update_data = {"action": new_action}
                #     for name, value in update_data.items():
                #         setattr(like_details, name, value)
                #     db.add(like_details)
                #     db.commit()
                # else:
                #     new_action = []
                #     action = {"user_id": str(user_data.user_id), "like": "True", "dislike": "False"}
                #     new_action.append(action)
                #     song_data = models.Count_likes(
                #         id=id,
                #         song_id=user_data.song_id,
                #         action=new_action
                #     )
                #     db.add(song_data)
                #     db.commit()

                db.refresh(licence_data)
                await license_email(song)

                return {"status": "success", "response": licence_data}

            # elif licence_details and not _is_license_is_finished(licence_details):
            #     pass
            else:

                # if user_data.project_id and user_data.project_type_id:
                #     project = db.query(models.Projects).filter(models.Projects.id == user_data.project_id).first()
                #     update_project = {"project_type_id": user_data.project_id}
                #
                #     for name, value in update_project.items():
                #         setattr(project, name, value)
                #     db.add(project)
                #     db.commit()
                #     logging.info("project updated successfully", exc_info=True)
                #
                # elif user_data.project_id:
                #     pass

                project_upd_data = user_data.project

                # if user_data.project_id and user_data.project_type_id:
                if project_upd_data:
                    project = db.query(models.Projects).filter(models.Projects.id == project_upd_data.get('id')).first()

                    if project:
                        update_data = {
                            "project_type_id": project_upd_data.get('project_type_id'),
                            "description": project_upd_data.get("description")
                        }
                        for name, value in update_data.items():
                            setattr(project, name, value)
                        db.add(project)
                        db.commit()
                        db.refresh(project)
                        logging.info("project updated successfully", exc_info=True)
                    logging.info("project not find", exc_info=True)

                licence_data = {
                    "song_id": user_data.song_id,
                    "project_id": project_upd_data.get("id") if project_upd_data else None,

                    "label": user_data.label,
                    "email": user_data.email,
                    "percentage": user_data.percentage,
                    "writers": user_data.writers,
                    "publishers": user_data.publishers,

                    "date": today_date,

                    "fee": user_data.fee,
                    "use": user_data.use,
                    "supervisor_invoice_info": user_data.supervisor_invoice_info,

                    "step": user_data.step,
                    "is_finished": False if user_data.licence_agreement is False else True,
                    "payment_status": False,
                    "status": user_data.status
                }
                for name, value in licence_data.items():
                    setattr(licence_details, name, value)

                db.add(licence_details)
                db.commit()
                db.refresh(licence_details)

                await license_email(song)
                return {"status": "success", "response": licence_details}

        else:
            return {
                "status": "failed",
                "response": "Licence for this song for the supervisor already exists",
            }

    except:
        logging.error("Exception occurred. Unable to store licence details", exc_info=True)


# licence approval
@app.patch("/licence_applied", tags=["licence"], dependencies=[Depends(JWTBearer())])
async def apply_licence(apply_licence: schemas.Apply_licence, db: Session = Depends(get_db)):
    try:
        get_artist = db.query(models.Songs, models.User_details).join(models.User_details, isouter=True).filter(
            models.Songs.id == apply_licence.song_id).filter(
            models.User_details.active_status == 0).first()
        if get_artist is not None:
            user_data = (
                db.query(models.Licence)
                    .filter(models.Licence.user_id == apply_licence.user_id).filter(
                    models.Licence.song_id == apply_licence.song_id)
                    .first()
            )
            if user_data is not None:
                compare = date.today() - user_data.date
                if compare.days > 14:
                    updated_data = {
                        "status": 2
                    }
                    for name, value in updated_data.items():
                        setattr(user_data, name, value)
                    db.add(user_data)
                    db.commit()
                    return {
                        "status": "failed",
                        "response": "rejected"
                    }
                else:
                    update_data = {
                        "status": apply_licence.status,
                        "approved_date": date.today(),
                        "licensor": apply_licence.licensor,
                        "producer": apply_licence.producer
                    }
                for name, value in update_data.items():
                    setattr(user_data, name, value)
                db.add(user_data)
                db.commit()
                update_notification = (
                    db.query(models.Notification)
                        .filter(models.Notification.user_id == apply_licence.user_id).filter(
                        models.Notification.song_id == apply_licence.song_id)
                        .first()
                )
                update_value = {
                    "status": apply_licence.status,
                    "date": date.today(),
                    "seen": 0,
                    "datetime": datetime.now().strftime("%Y/%m/%d %H:%M:%S")
                }
                for name, value in update_value.items():
                    setattr(update_notification, name, value)
                db.add(update_notification)
                db.commit()
                today_date = date.today()
                invoice_data = models.Invoice(
                    supervisor_id=apply_licence.user_id,
                    song_id=apply_licence.song_id,
                    date=today_date,
                    Licence_id=user_data.id
                )
                db.add(invoice_data)
                db.commit()

                logging.info("status updated ", exc_info=True)
                return {
                    "status": "success",
                    "response": "status updated"
                }
            else:
                logging.info(
                    "status not updated", exc_info=True
                )
                return {
                    "status": "failed",
                    "response": "status not updated",
                }
        else:
            logging.info(
                "Data Not Found", exc_info=True
            )
            return {
                "status": "failed",
                "response": "Data Not Found",
            }
    except Exception:
        logging.error("Exception occurred.status cannot be update", exc_info=True)
        return {"status": "failed", "response": "status cannot be update"}


async def license_email(user_data):
    subject = f"Ktizo - {user_data.music_title} Registration Notification"

    emails = []

    if user_data.publishers:
        for x in user_data.publishers:
            if x.get('writerEmail'):
                emails.append(x.get('writerEmail'))

    if user_data.writers:
        for x in user_data.writers:
            if x.get('publisherEmail'):
                emails.append(x.get('publisherEmail'))

    recipient = emails
    message = f"""
    <!DOCTYPE html>
    <html>
    <body>
    <div>
    <p>You're involved in the song {user_data.music_title} by {user_data.artist_title}, which will be on Ktizo's 
    platform and potentially licensed to TV shows, movies, or commercials.</p>

    <p>In accordance with the Song Registration Agreement, {user_data.artist_title} is responsible for distributing all
     royalties, fees, and other payments to other rightsholders of this song, including both the musical composition
      and sound recording.</p>

    <p>If you approve of this song being licensed to TV shows, movies, or commercials, please click below:<p>

    <p>If you do not click the approval button above, our Syncable application cannot match [SONG TITLE] to any
     projects.</p> 

    <p>If you have any questions or concerns, please contact us at music@ktizo.io.</p>

    <p>Thank you,</p>
    <p>Team at Ktizo</p>
    </div>
    </body>
    </html>
    """

    await emailutil.send_email(recipient, subject, message)
