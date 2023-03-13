from statistics import mode
import logging
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer
import uuid
from sqlalchemy.sql import func
from sqlalchemy import cast, desc, case

app = APIRouter()


# search artists
@app.get("/search_artists", tags=["Search Methods"], dependencies=[Depends(JWTBearer())])
async def search_artists(db: Session = Depends(get_db)):
    try:
        show_artists = db.query(models.User_details.id, models.User_details.full_name).filter(
            models.User_details.user_role == "Artist").filter(models.User_details.active_status == 0).all()
        if show_artists is not None:
            return {"status": "success", "response": show_artists}
        else:
            logging.info(
                "artist not found", exc_info=True
            )
            return {
                "status": "failed",
                "response": "artist not found",
            }
    except:
        logging.error("artist not found", exc_info=True)


# search tracks
@app.get("/search_tracks/{id}", tags=["Search Methods"], dependencies=[Depends(JWTBearer())])
async def search_tracks(id: str, db: Session = Depends(get_db)):
    try:
        show_tracks = db.query(models.Songs.music_title, models.Songs.genre).filter(models.Songs.track_id == id).all()
        if show_tracks is not None:
            return {"status": "success", "response": show_tracks}
        else:
            logging.info(
                "no tracks found", exc_info=True
            )
            return {
                "status": "failed",
                "response": "no tracks found",
            }
    except:
        logging.error("no tracks found", exc_info=True)
    # get similar tracks


@app.get("/get_tracks/{supervisor_id}", tags=["Search Methods"], dependencies=[Depends(JWTBearer())])
async def get_tracks(supervisor_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        tracks = db.query(models.Songs, models.Count_likes,
                          func.count(case([(models.Licence.user_id == supervisor_id, 1)])).label("licence_status"
                                                                                                 ),
                          func.array_agg(models.Licence.id
                                         ).label("licence_id")).join(models.Count_likes, isouter=True).join(
            models.Licence, isouter=True).filter(models.Songs.status == 1
                                                 ).group_by(models.Songs.id, models.Count_likes.id).all()
        song_data = []
        if tracks is not None:
            for track in tracks:
                artist = db.query(models.Songs, models.User_details).join(models.User_details, isouter=True).filter(
                    models.Songs.id == track['Songs'].id).filter(
                    models.User_details.active_status == 0).first()
                if artist is not None:
                    like = len(list(filter(lambda x: x.get('like') == 'True', track['Count_likes'].action))) if track[
                        'Count_likes'] else 0
                    dislike = len(list(filter(lambda x: x.get('dislike') == 'True', track['Count_likes'].action))) if \
                        track['Count_likes'] else 0
                    user_like = list(
                        filter(lambda x: x['user_id'] == str(supervisor_id), track['Count_likes'].action)) if track[
                        'Count_likes'] else []
                    songs_detail = {
                        "id": track['Songs'].id,
                        "user_id": track['Songs'].user_id,
                        "music_title": track['Songs'].music_title,
                        "image_url": track['Songs'].image_url,
                        "audio_url": track['Songs'].audio_url,
                        "music_duration": track['Songs'].music_duration,
                        "bpm": track['Songs'].bpm,
                        "track_id": track['Songs'].track_id,
                        "status": track['Songs'].status,
                        "spotify_id": track['Songs'].spotify_id,
                        "genre": track['Songs'].genre,
                        "licenced_status": track['licence_status'],
                        "like_count": like,
                        "dislike_count": dislike,
                        "user_like": user_like[0]['like'] if user_like else "False",
                        "user_dislike": user_like[0]['dislike'] if user_like else "False"}
                    song_data.append(songs_detail)
            return {"status": "success", "response": song_data}
        else:
            logging.info(
                "no tracks found", exc_info=True
            )
            return {
                "status": "failed",
                "response": "no tracks found",
            }
    except:
        logging.error("no tracks found", exc_info=True)

    # to get the matched songs according to licence


@app.get("/song_match/{id}", tags=["Search Methods"], dependencies=[Depends(JWTBearer())])
async def get_song_match(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        tracks = db.query((func.count(models.Licence.song_id
                                      ).label('song_count')), models.Licence.date,
                          (func.array_agg(models.Licence.song_id).label('song')
                           ), (models.Licence.to.label('artist_name')), (models.Songs.user_id.label('artist_id')
                                                                         ),
                          ((models.User_details.profile_pic).label('artist_image')), ((models.Songs.music_duration
                                                                                       ).label('duration'))
                          ).select_from(models.Licence).join(models.Songs).join(models.User_details
                                                                                ).filter(models.Licence.user_id == id
                                                                                         ).filter(
            models.User_details.active_status == 0).group_by(models.Licence.date, models.Licence.to,
                                                             models.Songs.user_id, models.User_details.profile_pic,
                                                             models.Songs.music_duration).all()
        if tracks is not None:
            return {"status": "success", "response": tracks}
        else:
            return {"status": "failed", "response": "Tracks not found for given supervisor"}
    except:
        logging.error("no tracks found", exc_info=True)


# to get the songs of artist according to matched songs
@app.get("/artist_match", tags=["Search Methods"], dependencies=[Depends(JWTBearer())])
async def get_tracks(supervisor_id: uuid.UUID, artist_id: uuid.UUID, date: str, db: Session = Depends(get_db)):
    try:
        artists = db.query(models.Licence.date, ((models.Licence.song_id).label('song')
                                                 ), models.Licence.to, (models.Songs.user_id.label('artist_id')
                                                                        ), (models.Songs.audio_url.label('audio')),
                           ((models.Songs.image_url).label('song_image')
                            ), (models.Count_likes.action.label('action')),
                           (models.Songs.music_duration.label('duration')
                            ), (models.Songs.music_title.label('music_title')), (models.Songs.genre.label('genre'))
                           ).select_from(models.Licence).join(models.Songs).join(models.User_details).join(
            models.Count_likes
        ).filter(models.Licence.user_id == supervisor_id
                 ).filter(models.Licence.date == date).filter(models.Songs.user_id == artist_id
                                                              ).group_by(models.Licence.date, models.Licence.to,
                                                                         models.Songs.user_id,
                                                                         models.Songs.image_url,
                                                                         models.Licence.song_id,
                                                                         models.Count_likes.action,
                                                                         models.Songs.audio_url,
                                                                         models.Songs.music_duration,
                                                                         models.Songs.music_title,
                                                                         models.Songs.genre).all()
        if artists:
            artist_data = []
            for artist in artists:
                like = len(list(filter(lambda x: x.get('like') == 'True', artist.action)))
                dislike = len(list(filter(lambda x: x.get('dislike') == 'True', artist.action)))
                artist_details = {
                    "date": artist.date,
                    "song_id": artist.song,
                    "song_audio_url": artist.audio,
                    "artist_id": artist.artist_id,
                    "artist_name": artist.to,
                    "song_image": artist.song_image,
                    "like_count": like,
                    "dislike_count": dislike,
                    "duration": artist.duration,
                    "music_title": artist.music_title,
                    "genre": artist.genre,
                    "like_count": like if like else 0,
                    "dislike_count": dislike if dislike else 0
                }
                artist_data.append(artist_details)
            return {"status": "success", "response": artist_data}
        else:
            return {"status": "failed", "response": "Songs not found for given artist"}
    except:
        logging.error("no artists found", exc_info=True)
