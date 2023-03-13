import uuid
import schemas
import logging
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer
from sqlalchemy.sql import func
from datetime import datetime
from datetime import date

app = APIRouter()


# save similar_track details
@app.post("/similar_tracks", dependencies=[Depends(JWTBearer())])
async def similar_tracks(songs: schemas.Similar_tracks, db: Session = Depends(get_db)):
    try:
        id = uuid.uuid4()
        today_date = date.today()
        song_data = models.Similar_track(
            id=id,
            supervisor_id=songs.supervisor_id,
            search_artistid=songs.search_artistid,
            search_artistname=songs.search_artistname,
            search_trackid=songs.track_id,
            search_trackname=songs.search_trackname,
            similar_songs=songs.song_details,
            date=today_date
        )
        db.add(song_data)
        db.commit()
        for song in songs.song_details:
            get_data = db.query(models.Songs).filter(models.Songs.id == song['id']).first()
            id2 = uuid.uuid4()
            today_date = date.today()
            notification_data = models.Notification(
                id=id2,
                user_id=songs.supervisor_id,
                song_id=song['id'],
                date=today_date,
                artist_id=get_data.user_id,
                music_title=get_data.music_title,
                datetime=datetime.now().strftime("%Y/%m/%d %H:%M:%S"),
                track_id=get_data.track_id,
                status="4")
            db.add(notification_data)
            db.commit()
        response = {
            "id": id,
            "supervisor_id": songs.supervisor_id,
            "artist_id": songs.search_artistid,
            "track_id": songs.track_id,
            "song_details": songs.song_details,
            "date": today_date
        }
        return {"status": "success", "response": response}
    except:
        logging.error("Exception occurred. Unable to store song details", exc_info=True)


# save similar_track details
@app.get("/match_songs", dependencies=[Depends(JWTBearer())])
async def get_similar_tracks(supervisor_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        songs = db.query(models.Similar_track.id, models.Similar_track.supervisor_id,
                         models.Similar_track.search_artistid,
                         models.Similar_track.search_artistname,
                         models.Similar_track.search_trackid,
                         models.Similar_track.search_trackname,
                         models.Similar_track.date,
                         func.jsonb_array_length(models.Similar_track.similar_songs).label('song_count')
                         ).filter(models.Similar_track.supervisor_id == supervisor_id).all()
        song_details = []
        if songs:
            for song in songs:
                artist = db.query(models.User_details.profile_pic, models.User_details.id, models.User_details.full_name
                                  ).filter(models.User_details.spotify_user_id == song.search_artistid).filter(
                    models.User_details.active_status == 0).first()
                if artist:
                    song_data = {"id": song.id,
                                 "supervisor_id": song.supervisor_id,
                                 "artist_id": song.search_artistid,
                                 "artist_name": song.search_artistname,
                                 "artist_profile_pic": artist.profile_pic if artist is not None else None,
                                 "song_count": song.song_count,
                                 "track_id": song.search_trackid,
                                 "track_name": song.search_trackname,
                                 "date": song.date.strftime("%m/%d/%Y")}
                    song_details.append(song_data)

            logging.info("Songs exists", exc_info=True)
            return {"status": "success", "response": song_details}
        else:
            logging.info("Songs doesnot exists", exc_info=True)
            return {"status": "failed", "response": "song doesnot exists for given supervisor"}
    except:
        logging.error("Exception occurred. Unable to take song details", exc_info=True)


@app.get("/match_artist_songs", dependencies=[Depends(JWTBearer())])
async def get_similar_tracks_artists(id: uuid.UUID, supervisor_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        songs = db.query(models.Similar_track.similar_songs, models.Similar_track.search_artistname,
                         models.Similar_track.search_trackname
                         ).filter(models.Similar_track.id == id).first()
        song_details = []
        if songs:
            for song in songs["similar_songs"]:
                licence = db.query(models.Licence).filter(models.Licence.song_id == song["id"]).filter(
                    models.Licence.user_id == supervisor_id).all()
                if licence:
                    if licence[0].status == 0:
                        licence_status = 0
                    elif licence[0].status == 1:
                        licence_status = 1
                else:
                    licence_status = 2
                like = db.query(models.Count_likes.action).filter(models.Count_likes.song_id == song["id"]).first()
                like_count = len(list(filter(lambda x: x.get('like') == 'True', like.action))) if like else 0
                user_like = list(filter(lambda x: x['user_id'] == str(supervisor_id), like.action)) if like else []
                song_data = {"song_id": song["id"],
                             "audio_url": song["audio_url"],
                             "music_title": song["music_title"],
                             "genre": song["genre"],
                             "music_duration": song["music_duration"],
                             "bpm": song["bpm"],
                             "image_url": song["image_url"],
                             "like_count": like_count if like else 0,
                             "artist_name": songs.search_artistname,
                             "artist_id": song['user_id'],
                             "track_id": song['track_id'],
                             "licience_status": licence_status,
                             "track_name": songs.search_trackname,
                             "user_like": user_like[0]['like'] if user_like else "False"
                             }
                song_details.append(song_data)
            logging.info("Songs exists", exc_info=True)
            return {"status": "success", "response": song_details}
        else:
            logging.info("Songs doesnot exists", exc_info=True)
            return {"status": "failed", "response": "song doesnot exists"}
    except:
        logging.error("Exception occurred. Unable to take song details of similar_songs of artist", exc_info=True)
