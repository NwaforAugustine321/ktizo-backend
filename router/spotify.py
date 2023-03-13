import base64
import math
import os
from random import random
from urllib.parse import urlencode
import requests
import schemas
import uuid
import logging
from fastapi import APIRouter, Depends, Response, Request, HTTPException  # , requests
from fastapi.responses import RedirectResponse, HTMLResponse
from sqlalchemy.orm import Session

from config.config import settings
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer
from datetime import date
from datetime import datetime

import schemas
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models

app = APIRouter()

STATE_KEY = "spotify_auth_state"
CLIENT_ID = settings.SPOTIFY_CLIENT_ID
CLIENT_SECRET = settings.SPOTIFY_CLIENT_SECRET
URI = settings.SPOTIFY_URI
REDIRECT_URI = "http://localhost:8000/callback"


@app.post('/set_spotify_token_in_db', tags=["auth"])
def spotify_token(spotify_user_token: schemas.Spotify_token, db: Session = Depends(get_db)):
    user_spotify = db.query(models.User_details).filter(models.User_details.id == spotify_user_token.user_id).first()

    update_data = {"token": spotify_user_token.token}

    for name, value in update_data.items():
        setattr(user_spotify, name, value)

    db.add(user_spotify)

    db.commit()
    user_spotify = db.query(models.User_details).filter(models.User_details.id == spotify_user_token.user_id).first()

    return {"response": f'successfully updated', "user_details": user_spotify}

#
# def generate_random_string(string_length):
#     possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#     text = "".join(
#         [
#             possible[math.floor(random() * len(possible))]
#             for i in range(string_length)
#         ]
#     )
#
#     return text
#
#
# from fastapi.responses import HTMLResponse
#
#
# def get_access_token(auth_code: str):
#     response = requests.post(
#         "https://accounts.spotify.com/api/token",
#         data={
#             "grant_type": "authorization_code",
#             "code": auth_code,
#             "redirect_uri": "http://localhost:8000/callback",
#         },
#         auth=(CLIENT_ID, CLIENT_SECRET),
#     )
#     access_token = response.json()["access_token"]
#     return {"Authorization": "Bearer " + access_token}
#
#
# @app.get("/get_spotify_access_code", tags=["auth only for backend"])
# def read_root(response: Response):
#     scope = ["user-read-private", "user-read-email", "playlist-modify-private", "playlist-modify-public"]
#     auth_url = f"https://accounts.spotify.com/authorize?response_type=code&client_id={CLIENT_ID}&redirect_uri={REDIRECT_URI}&scope={' '.join(scope)}"
#     return HTMLResponse(content=f'<a href="{auth_url}">Authorize</a>')
#
#
# @app.get("/auth/spotify", tags=["auth"])
# def callback(calback_code: str, request: Request, response: Response):
#     code = calback_code
#     state = generate_random_string(20)
#     url = "https://accounts.spotify.com/api/token"
#     request_string = CLIENT_ID + ":" + CLIENT_SECRET
#     encoded_bytes = base64.b64encode(request_string.encode("utf-8"))
#     encoded_string = str(encoded_bytes, "utf-8")
#     header = {"Authorization": "Basic " + encoded_string}
#
#     form_data = {
#         "code": code,
#         "redirect_uri": REDIRECT_URI,
#         "grant_type": "authorization_code",
#     }
#
#     api_response = requests.post(url, data=form_data, headers=header)
#
#     if api_response.status_code == 200:
#         return api_response.json()
#     else:
#         logging.warning("Error to connect %s", url)
#
#
# @app.get("/refresh_token", tags=["auth"])
# def refresh_token(refresh_token: str, request: Request):
#     request_string = CLIENT_ID + ":" + CLIENT_SECRET
#     encoded_bytes = base64.b64encode(request_string.encode("utf-8"))
#     encoded_string = str(encoded_bytes, "utf-8")
#     header = {"Authorization": "Basic " + encoded_string}
#
#     form_data = {"grant_type": "refresh_token", "refresh_token": refresh_token}
#     url = "https://accounts.spotify.com/api/token"
#
#     response = requests.post(url, data=form_data, headers=header)
#     if response.status_code != 200:
#         raise HTTPException(status_code=400, detail="Error with refresh token")
#     else:
#         data = response.json()
#         access_token = data["access_token"]
#
#         return {"access_token": access_token}

