from operator import and_

import schemas
import uuid
import logging
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer
from datetime import date
from datetime import datetime

from dependencies.profiles import get_active_profile_by_id
from dependencies.songs import get_song_by_id, get_user_and_his_song_by_id
from utils import strings, emailutil

app = APIRouter()


# upload songs  and other details to database
@app.post("/songs", tags=["songs"], dependencies=[Depends(JWTBearer())])
async def songs(user_data: schemas.Songs, db: Session = Depends(get_db)):
    active_user = await get_active_profile_by_id(user_data.user_id, db)

    try:
        record_id = uuid.uuid4()
        today_date = date.today()
        artist_title = user_data.artist_title if user_data.artist_title else active_user.full_name

        song_data = models.Songs(
            id=record_id,
            user_id=active_user.id,
            project_id=user_data.project_id,

            artist_title=artist_title,
            music_title=user_data.music_title,
            genre=user_data.genre,
            own_recording=user_data.own_recording,

            parties=user_data.parties,
            writers=user_data.writers,
            publishers=user_data.publishers,
            writing_credits=user_data.writing_credits,
            publisher_credits=user_data.publisher_credits,

            origin_url=user_data.origin_url,
            clean_url=user_data.clean_url,
            instrumental_url=user_data.instrumental_url,
            cover_photo=user_data.cover_photo,

            upload_date=today_date,
            track_id=user_data.track_id,
            spotify_id=user_data.spotify_id,
            bpm=user_data.bpm,
            music_duration=user_data.music_duration
        )
        db.add(song_data)
        db.commit()
        db.refresh(song_data)

        await song_email(user_data)
        return {"status": "success", "response": song_data}

    except:
        logging.error(strings.BASE_SONG_ERROR, exc_info=True)
        raise HTTPException(
            status_code=404,
            detail=strings.BASE_SONG_ERROR
        )


@app.patch("/songs/{song_id}", tags=["songs"], dependencies=[Depends(JWTBearer())])
async def songs(user_id: uuid.UUID, song_data: schemas.UpdateSong, db: Session = Depends(get_db)):
    # song = await get_user_and_his_song_by_id(user_id, song_id, db)
    if song_data.song_id:
        active_user = db.query(models.User_details).filter(
            and_(
                models.User_details.id == user_id,
                models.User_details.active_status == 0
            )
        ).first()
        song = db.query(models.Songs).filter(models.Songs.id == song_data.song_id).first()

        if not song:
            logging.error(strings.SONG_NOT_FOUND_ERROR, exc_info=True)
            raise HTTPException(
                status_code=404,
                detail=strings.SONG_NOT_FOUND_ERROR
            )

        try:
            song_update_data = {
                "project_id": song_data.project_id,
                "artist_title": song_data.artist_title,
                "music_title": song_data.music_title,
                "genre": song_data.genre,
                "own_recording": song_data.own_recording,
                "parties": song_data.parties,
                "writers": song_data.writers,
                "publishers": song_data.publishers,
                "writing_credits": song_data.writing_credits,
                "publisher_credits": song_data.publisher_credits,
                "origin_url": song_data.origin_url,
                "clean_url": song_data.clean_url,
                "instrumental_url": song_data.instrumental_url,
                "cover_photo": song_data.cover_photo,
                "track_id": song_data.track_id,
                "spotify_id": song_data.spotify_id,
                "bpm": song_data.bpm,
                "status": 1 if song_data.origin_url or song_data.clean_url or song_data.instrumental_url else 0,
                "music_duration": song_data.music_duration
            }
            for name, value in song_update_data.items():
                setattr(song, name, value)

            db.add(song)
            db.commit()
            db.refresh(song)
            return {"status": "success", "response": song}

        except:
            logging.error(strings.BASE_SONG_ERROR, exc_info=True)
            raise HTTPException(
                status_code=404,
                detail=strings.BASE_SONG_ERROR
            )


@app.get("/songs_list/{id}", tags=["songs"], dependencies=[Depends(JWTBearer())])
def songs_list(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user = db.query(models.User_details).filter(models.User_details.id == id).filter(
            models.User_details.active_status == 0).first()
        if user is not None:
            songs = db.query(models.Songs, models.Count_likes).join(models.Count_likes, isouter=True).filter(
                models.Songs.user_id == id).all()
            if songs is not None:
                song_data = []
                for song in songs:
                    date = song['Songs'].upload_date.strftime("%m/%d/%Y")
                    like = len(list(filter(lambda x: x.get('like') == 'True', song['Count_likes'].action))) if song[
                        'Count_likes'] else 0
                    dislike = len(list(filter(lambda x: x.get('dislike') == 'True', song['Count_likes'].action))) if \
                        song['Count_likes'] else 0
                    user_like = list(filter(lambda x: x['user_id'] == str(id), song['Count_likes'].action)) if song[
                        'Count_likes'] else []
                    songs_detail = {"song_id": song['Songs'].id,
                                    "user_id": song['Songs'].user_id,
                                    "spotify_id": song['Songs'].spotify_id,
                                    "track_id": song['Songs'].track_id,
                                    "status": song['Songs'].status,
                                    "music_title": song['Songs'].music_title,
                                    "cover_photo": song['Songs'].cover_photo,
                                    "origin_url": song['Songs'].origin_url,
                                    "clean_url": song['Songs'].clean_url,
                                    "instrumental_url": song['Songs'].instrumental_url,
                                    "genre": song['Songs'].genre,
                                    "upload_date": date,
                                    "music_duration": song['Songs'].music_duration,
                                    "like_count": like,
                                    "dislike_count": dislike,
                                    "user_like": user_like[0]['like'] if user_like else "False",
                                    "user_dislike": user_like[0]['dislike'] if user_like else "False"}
                    song_data.append(songs_detail)
                return {"status": "success", "response": song_data}
            else:
                logging.info(
                    f"Unable to get song details", exc_info=True
                )
                return {
                    "status": "failed",
                    "response": f"Unable to get song details",
                }
        else:
            logging.info(
                "User not exist", exc_info=True
            )
            return {
                "status": "failed",
                "response": "User not exist",
            }
    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


@app.get("/songs_status_list/{id}/{status}", tags=["songs"], dependencies=[Depends(JWTBearer())])
def songs_status_list(id: uuid.UUID, status: int, db: Session = Depends(get_db)):
    try:
        user = db.query(models.User_details).filter(models.User_details.id == id).filter(
            models.User_details.active_status == 0).first()
        if user is not None:
            songs = db.query(models.Songs, models.Count_likes).join(models.Count_likes, isouter=True).filter(
                models.Songs.user_id == id).filter(models.Songs.status == status).all()
            if songs is not None:
                song_data = []
                for song in songs:
                    date = song['Songs'].upload_date.strftime("%m/%d/%Y")
                    like = len(list(filter(lambda x: x.get('like') == 'True', song['Count_likes'].action))) if song[
                        'Count_likes'] else 0
                    dislike = len(list(filter(lambda x: x.get('dislike') == 'True', song['Count_likes'].action))) if \
                        song['Count_likes'] else 0
                    user_like = list(filter(lambda x: x['user_id'] == str(id), song['Count_likes'].action)) if song[
                        'Count_likes'] else []
                    songs_detail = {"song_id": song['Songs'].id,
                                    "user_id": song['Songs'].user_id,
                                    "spotify_id": song['Songs'].spotify_id,
                                    "track_id": song['Songs'].track_id,
                                    "status": song['Songs'].status,
                                    "music_title": song['Songs'].music_title,
                                    "cover_photo": song['Songs'].cover_photo,
                                    "origin_url": song['Songs'].origin_url,
                                    "clean_url": song['Songs'].clean_url,
                                    "instrumental_url": song['Songs'].instrumental_url,
                                    "genre": song['Songs'].genre,
                                    "upload_date": date,
                                    "music_duration": song['Songs'].music_duration,
                                    "like_count": like,
                                    "dislike_count": dislike,
                                    "user_like": user_like[0]['like'] if user_like else "False",
                                    "user_dislike": user_like[0]['dislike'] if user_like else "False"}
                    song_data.append(songs_detail)
                return {"status": "success", "response": song_data}
            else:
                logging.info(
                    f"Unable to get song details", exc_info=True
                )
                return {
                    "status": "failed",
                    "response": f"Unable to get song details",
                }
        else:
            logging.info(
                "User not exist", exc_info=True
            )
            return {
                "status": "failed",
                "response": "User not exist",
            }
    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


@app.get("/song_details/{user_id}/{song_id}", tags=["songs"], dependencies=[Depends(JWTBearer())])
async def song_details(user_id: uuid.UUID, song_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user = db.query(models.User_details).filter(models.User_details.id == user_id).filter(
            models.User_details.active_status == 0).first()
        if user is not None:
            song = db.query(models.Songs).filter(models.Songs.user_id == user_id).filter(
                models.Songs.id == song_id).first()

            if song is not None:
                return {"status": "success", "response": song}
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

        # get_artist = db.query(models.Songs, models.User_details).join(models.User_details, isouter=True).filter(
        #     models.Songs.id == song_id).filter(
        #     models.User_details.active_status == 0).first()
        # if get_artist is not None:
    #         song_details = get_artist["Songs"]
    #         details = db.query(models.Licence).filter(models.Licence.user_id == user_id).filter(
    #             models.Licence.song_id == song_id).first()
    #         if details is not None:
    #             get_user = db.query(models.User_details).filter(models.User_details.id == user_id).first()
    #             result = {
    #                 "supervisor_name": get_user.full_name,
    #                 "id": details.id,
    #                 "user_id": details.user_id,
    #                 "song_id": details.song_id,
    #                 "date": details.date,
    #                 "email": details.email,
    #                 "to": details.to,
    #                 "master_recording": details.master_recording,
    #                 "written_by": details.written_by,
    #                 "published_by": details.published_by,
    #                 "performed_by": details.performed_by,
    #                 "label": details.label,
    #                 "tv_show": details.tv_show,
    #                 "show_description": details.show_description,
    #                 "use": details.use,
    #                 "onetime_fee": details.onetime_fee,
    #                 "direct_performancefee": details.direct_performancefee,
    #                 "master_licencefee": details.master_licencefee,
    #                 "sync_licencefee": details.sync_licencefee,
    #                 "performance_fee": details.performance_fee,
    #                 "reached_at": details.reached_at,
    #                 "reachedat_email": details.reachedat_email,
    #                 "status": details.status,
    #                 "approved_date": details.approved_date,
    #                 "search_artistid": details.search_artistid,
    #                 "search_trackid": details.search_trackid,
    #                 "licensor": details.licensor,
    #                 "producer": details.producer
    #
    #             }
    #             return {"status": "success", "response": result}
    #         else:
    #             data = db.query(models.Songs, models.User_details).join(models.User_details, isouter=True).filter(
    #                 models.Songs.id == song_id).first()
    #             if data is not None:
    #                 writer_names = []
    #                 publisher_names = []
    #                 for writer in data['Songs'].writers:
    #                     name = writer['writerName']
    #                     writer_names.append(name)
    #                 for publisher in data['Songs'].publishers:
    #                     name = publisher['publisherName']
    #                     publisher_names.append(name)
    #                 supervisor = db.query(models.User_details).filter(models.User_details.id == user_id).first()
    #                 licence_details = {
    #                     "date": date.today().strftime("%m/%d/%Y"),
    #                     "email": data['User_details'].email,
    #                     "performed_by": data['User_details'].full_name,
    #                     "to": data['User_details'].legal_name,
    #                     "songid": data['Songs'].id,
    #                     "own_recording": data['Songs'].own_recording,
    #                     "master_recording": data['Songs'].music_title,
    #                     "supervisor_name": supervisor.full_name,
    #                     "supervisor_id": supervisor.id,
    #                     "written_by": writer_names,
    #                     "published_by": publisher_names,
    #                     "label": data['Songs'].music_title
    #                 }
    #                 return {"status": "success", "response": licence_details}
    #     else:
    #         logging.info(
    #             "Data Not Found", exc_info=True
    #         )
    #         return {
    #             "status": "failed",
    #             "response": "Data Not Found",
    #         }
    # except:
    #     logging.error("Exception occurred. Unable to get song details", exc_info=True)


@app.post("/like_dislikes", tags=["songs"], dependencies=[Depends(JWTBearer())])
def songs(song_data: schemas.Count_likes, db: Session = Depends(get_db)):
    try:
        id = uuid.uuid4()
        songs_details = db.query(models.Count_likes).filter(models.Count_likes.song_id == song_data.song_id).first()
        if songs_details is None:
            new_action = []
            if song_data.status == "like":
                action = {"user_id": str(song_data.user_id), "like": "True", "dislike": "False"}
            else:
                action = {"user_id": str(song_data.user_id), "like": "False", "dislike": "True"}
            new_action.append(action)
            song_data_add = models.Count_likes(
                id=id,
                song_id=song_data.song_id,
                action=new_action
            )
            db.add(song_data_add)
            db.commit()
            if new_action[0]['like'] == "True":
                get_details = db.query(models.Songs).filter(models.Songs.id == song_data.song_id).first()
                if get_details is not None:
                    id2 = uuid.uuid4()
                    today_date = datetime.now().strftime("%Y/%m/%d %H:%M:%S")
                    notification_data = models.Notification(
                        id=id2,
                        user_id=song_data.user_id,
                        song_id=song_data.song_id,
                        date=date.today(),
                        artist_id=get_details.user_id,
                        music_title=get_details.music_title,
                        datetime=today_date,
                        track_id=get_details.track_id,
                        status="2")
                    db.add(notification_data)
                    db.commit()
        else:
            if any(song['user_id'] == str(song_data.user_id) for song in songs_details.action):
                user = []
                for action in songs_details.action:
                    if action["user_id"] == str(song_data.user_id):
                        if song_data.status == "like" and action["like"] == "False":
                            a = {"user_id": str(song_data.user_id), "like": "True", "dislike": "False"}
                        elif song_data.status == "like" and action["like"] == "True":
                            a = {"user_id": str(song_data.user_id), "like": "False", "dislike": action["dislike"]}
                        elif song_data.status == "dislike" and action["dislike"] == "True":
                            a = {"user_id": str(song_data.user_id), "like": action["like"], "dislike": "False"}
                        elif song_data.status == "dislike" and action["dislike"] == "False":
                            a = {"user_id": str(song_data.user_id), "like": "False", "dislike": "True"}
                        user.append(a)
                new_action = list(
                    filter(lambda i: i['user_id'] != user[0]["user_id"], list(songs_details.action))) + user
            else:
                if song_data.status == "like":
                    a = {"user_id": str(song_data.user_id), "like": "True", "dislike": "False"}
                else:
                    a = {"user_id": str(song_data.user_id), "like": "False", "dislike": "True"}
                new_action = list(songs_details.action)
                new_action.append(a)
            update_data = {"action": new_action}
            if new_action[0]['like'] == "True":
                get_details = db.query(models.Songs).filter(models.Songs.id == song_data.song_id).first()
                if get_details is not None:
                    id2 = uuid.uuid4()
                    today_date = date.today()
                    notification_data = models.Notification(
                        id=id2,
                        user_id=song_data.user_id,
                        song_id=song_data.song_id,
                        date=today_date,
                        artist_id=get_details.user_id,
                        music_title=get_details.music_title,
                        datetime=datetime.now().strftime("%Y/%m/%d %H:%M:%S"),
                        track_id=get_details.track_id,
                        status="2")
                    db.add(notification_data)
                    db.commit()
            for name, value in update_data.items():
                setattr(songs_details, name, value)
            db.add(songs_details)
            db.commit()
        songs_data = db.query(models.Count_likes).filter(models.Count_likes.song_id == song_data.song_id).first()
        return {"status": "success", "response": songs_data}
    except:
        logging.error("Exception occurred. Unable to save the details", exc_info=True)


@app.get("/song_impression/{id}", tags=["songs"], dependencies=[Depends(JWTBearer())])
def song_impresiion(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user = db.query(models.User_details).filter(models.User_details.id == id).filter(
            models.User_details.active_status == 0).first()
        if user is not None:
            songs = db.query(models.Songs, models.Count_likes).join(models.Count_likes, isouter=True).filter(
                models.Songs.user_id == id).all()
            if songs is not None:
                likes = []
                for song in songs:
                    like = len(list(filter(lambda x: x.get('like') == 'True', song['Count_likes'].action))) if song[
                        'Count_likes'] else 0
                    likes.append(like)
                like_count = {"user_id": id, "like": sum(likes)}
                return {"status": "success", "response": like_count}
            else:
                logging.info(
                    f"Unable to get song details", exc_info=True
                )
                return {
                    "status": "failed",
                    "response": f"Unable to get song details",
                }
        else:
            logging.info(
                "User not exist", exc_info=True
            )
            return {
                "status": "failed",
                "response": "User not exist",
            }
    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


@app.get("/top_songs/{id}", tags=["songs"], dependencies=[Depends(JWTBearer())])
def top_songs(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user = db.query(models.User_details).filter(models.User_details.id == id).filter(
            models.User_details.active_status == 0).first()
        if user is not None:
            songs = db.query(models.Songs, models.Count_likes).join(models.Count_likes, isouter=True).filter(
                models.Songs.user_id == id).all()
            if songs is not None:
                song_data = []
                for song in songs:
                    date = song['Songs'].upload_date.strftime("%m/%d/%Y")
                    like = len(list(filter(lambda x: x.get('like') == 'True', song['Count_likes'].action))) if song[
                        'Count_likes'] else 0
                    dislike = len(list(filter(lambda x: x.get('dislike') == 'True', song['Count_likes'].action))) if \
                        song['Count_likes'] else 0
                    user_like = list(filter(lambda x: x['user_id'] == str(id), song['Count_likes'].action)) if song[
                        'Count_likes'] else []
                    songs_detail = {"song_id": song['Songs'].id,
                                    "user_id": song['Songs'].user_id,
                                    "music_title": song['Songs'].music_title,
                                    "genre": song['Songs'].genre,
                                    "image_url": song['Songs'].image_url,
                                    "upload_date": date,
                                    "music_duration": song['Songs'].music_duration,
                                    "like_count": like,
                                    "dislike_count": dislike,
                                    "user_like": user_like[0]['like'] if user_like else "False",
                                    "user_dislike": user_like[0]['dislike'] if user_like else "False"}
                    song_data.append(songs_detail)
                song_data_sorted = sorted(song_data, key=lambda i: i['like_count'], reverse=True)[:10]
                return {"status": "success", "response": song_data_sorted}
            else:
                logging.info(
                    f"Unable to get song details", exc_info=True
                )
                return {
                    "status": "failed",
                    "response": f"Unable to get song details",
                }
        else:
            logging.info(
                "User not exist", exc_info=True
            )
            return {
                "status": "failed",
                "response": "User not exist",
            }
    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


@app.get("/song_for_approval", tags=["songs"], dependencies=[Depends(JWTBearer())])
def songapproval_list(db: Session = Depends(get_db)):
    try:
        songs = db.query(models.Songs, models.User_details).join(models.User_details).filter(
            models.Songs.status == 0).filter(models.User_details.active_status == 0).all()
        if songs is not None:
            song_data = []
            for song in songs:
                songs_detail = {"song_id": song['Songs'].id,
                                "artist_name": song['User_details'].full_name,
                                "music_title": song['Songs'].music_title,
                                "genre": song['Songs'].genre,
                                "parties": song['Songs'].parties,
                                "publisher": song['Songs'].publishers,
                                "writer": song['Songs'].writers,
                                "status": song['Songs'].status
                                }
                song_data.append(songs_detail)
            return {"status": "success", "response": song_data}
        else:
            logging.info(
                "Songs not found", exc_info=True
            )
            return {
                "status": "failed",
                "response": "songs not found",
            }
    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


@app.patch("/song_approval", tags=["songs"], dependencies=[Depends(JWTBearer())])
async def song_approval(apply_song: schemas.Song_approval, db: Session = Depends(get_db)):
    try:
        user_data = (db.query(models.Songs).filter(models.Songs.id == apply_song.song_id).first())
        if user_data is not None:
            update_data = {
                "status": 1
            }
            for name, value in update_data.items():
                setattr(user_data, name, value)
            db.add(user_data)
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
    except Exception:
        logging.error("Exception occurred.status cannot be update", exc_info=True)
        return {"status": "failed", "response": "status cannot be update"}


@app.get("/licence_applied_songs/{user_id}", tags=["licence"], dependencies=[Depends(JWTBearer())])
def licence_applied_songs(user_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        songs = db.query(models.Licence, models.Songs, models.Count_likes).select_from(models.Licence).join(
            models.Songs, isouter=True).join(
            models.Count_likes, isouter=True).filter(models.Licence.user_id == user_id).all()
        if songs:
            song_data = []
            for song in songs:
                artist = db.query(models.Songs, models.User_details).join(models.User_details, isouter=True).filter(
                    models.Songs.id == song['Songs'].id).filter(
                    models.User_details.active_status == 0).first()
                if artist is not None:
                    like = len(list(filter(lambda x: x.get('like') == 'True', song['Count_likes'].action))) if song[
                        'Count_likes'] else 0
                    user_like = list(filter(lambda x: x['user_id'] == str(user_id), song['Count_likes'].action)) if \
                        song['Count_likes'] else []
                    songs_detail = {"song_id": song['Songs'].id,
                                    "artist_id": song['Songs'].user_id,
                                    "spotify_id": song['Songs'].spotify_id,
                                    "track_id": song['Songs'].track_id,
                                    "licence_status": song['Licence'].status,
                                    "music_title": song['Songs'].music_title,
                                    "genre": song['Songs'].genre,
                                    "cover_photo": song['Songs'].cover_photo,
                                    "music_duration": song['Songs'].music_duration,
                                    "bpm": song['Songs'].bpm,
                                    "origin_url": song['Songs'].origin_url,
                                    "clean_url": song['Songs'].clean_url,
                                    "instrumental_url": song['Songs'].instrumental_url,
                                    "like_count": like,
                                    "user_like": user_like[0]['like'] if user_like else "False"}
                    song_data.append(songs_detail)
            return {"status": "success", "response": song_data}
        else:
            logging.info(
                "Unable to get song details", exc_info=True
            )
            return {
                "status": "failed",
                "response": "Unable to get song details",
            }
    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


async def song_email(user_data):
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
