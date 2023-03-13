import schemas
import uuid
import logging
import requests

from config.config import settings
from utils import emailutil
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer

app = APIRouter()


class BearerAuth(requests.auth.AuthBase):
    def __init__(self):
        self.token = settings.AI_CLIENT_TOKEN

    def __call__(self, r):
        r.headers["Authorization"] = "Bearer " + self.token
        return r


ai_api_url = settings.AI_URL


# api_token = settings.AI_CLIENT_TOKEN


@app.get("/artists_list", tags=["ai"], dependencies=[Depends(JWTBearer())])
async def get_artists(db: Session = Depends(get_db)):
    ai_uri = "/artists"
    try:
        url = ai_api_url + ai_uri
        logging.info(f"Connecting to AI server... {url}")
        response = requests.get(url, auth=BearerAuth())

        ai_data = response.json().get('data')
        user_ids = tuple([x.get('spotify_id') for x in ai_data])

        artists_in_db = db.query(models.User_details).filter(models.User_details.spotify_user_id.in_(user_ids)).all()
        db_artists_spotify_id = [x.spotify_user_id for x in artists_in_db]

        without_db_artists = [x for x in ai_data if x.get('spotify_id') not in db_artists_spotify_id]

        if response.status_code == 200:
            return {"status": "success", "response": without_db_artists}

        elif response.status_code == 401:
            logging.warning(
                "401 Error, Credentials not correct for %s",
                response.request.url,
            )
        else:
            logging.warning(
                "Error to connect %s",
                response.request.url,
            )

    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


@app.get("/artist/{artist_id}", tags=["ai"], dependencies=[Depends(JWTBearer())])
async def get_artist(artist_id: str):
    ai_uri = f"/artists/{artist_id}"
    try:
        url = ai_api_url + ai_uri
        logging.info(f"Connecting to AI server... {url}")
        response = requests.get(url, auth=BearerAuth())

        if response.status_code == 200:
            return {"status": "success", "response": response.json()}

        elif response.status_code == 401:
            logging.warning(
                "401 Error, Credentials not correct for %s",
                response.request.url,
            )
        else:
            logging.warning("Error to connect %s", response.request.url)

    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


@app.get("/artist_tracks/{artist_id}", tags=["ai"], dependencies=[Depends(JWTBearer())])
async def get_artist_tracs(artist_id: str):
    ai_uri = f"/artists/{artist_id}/tracks"
    try:
        url = ai_api_url + ai_uri
        logging.info(f"Connecting to AI server... {url}")
        response = requests.get(url, auth=BearerAuth())

        if response.status_code == 200:
            return {"status": "success", "response": response.json()}

        elif response.status_code == 401:
            logging.warning(
                "401 Error, Credentials not correct for %s",
                response.request.url,
            )
        else:
            logging.warning(
                "Error to connect %s",
                response.request.url,
            )

    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


@app.get("/platform_artist_matches/{track_id}", tags=["ai"], dependencies=[Depends(JWTBearer())])
async def get_artist_tracs(track_id: str, db: Session = Depends(get_db)):
    ai_uri = "/recommendations"
    try:
        url = ai_api_url + ai_uri
        logging.info(f"Connecting to AI server... {url}")
        params = {
            "id": track_id
        }
        response = requests.get(url, auth=BearerAuth(), params=params)

        if response.status_code == 200:
            ai_data = response.json().get('data')

            spotify_tracks_ids = tuple([x.get('spotify_id') for x in ai_data])

            matches = db.query(models.Songs).filter(models.Songs.spotify_id.in_(spotify_tracks_ids)).all()

            return {"status": "success", "response": matches}

        elif response.status_code == 401:
            logging.warning(
                "401 Error, Credentials not correct for %s",
                response.request.url,
            )
        else:
            logging.warning(
                "Error to connect %s",
                response.request.url
            )

    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)


@app.get("/match_recommendations/{track_id}", tags=["ai"], dependencies=[Depends(JWTBearer())])
async def get_artist_tracs(track_id: str):
    ai_uri = "/recommendations"
    try:
        url = ai_api_url + ai_uri
        logging.info(f"Connecting to AI server... {url}")
        params = {
            "id": track_id
        }
        response = requests.get(url, auth=BearerAuth(), params=params)

        if response.status_code == 200:
            return {"status": "success", "response": response.json()}

        elif response.status_code == 401:
            logging.warning(
                "401 Error, Credentials not correct for %s",
                response.request.url,
            )
        else:
            logging.warning(
                "Error to connect %s",
                response.request.url,
            )

    except:
        logging.error("Exception occurred. Unable to get song details", exc_info=True)
