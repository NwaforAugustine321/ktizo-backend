from operator import and_
import uuid
import logging
from fastapi import APIRouter, Depends, HTTPException, Path
from sqlalchemy.orm import Session
from db.database import get_db
from db import models

from db.errors import EntityDoesNotExist
from dependencies.profiles import get_active_profile_by_id
from utils import strings


async def get_song_by_id(song_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        song = db.query(models.Songs).filter(models.Songs.id == song_id).first()

        if not song:
            logging.info(strings.SONG_DOES_NOT_EXIST_ERROR.format(id=song_id), exc_info=True)
            raise HTTPException(
                status_code=404,
                detail=strings.SONG_DOES_NOT_EXIST_ERROR.format(id=song_id)
            )

        return song
    except EntityDoesNotExist:
        logging.info(strings.DB_BASE_ERROR_DETAIL, exc_info=True)
        raise HTTPException(
            status_code=404,
            detail=strings.DB_BASE_ERROR_DETAIL
        )


async def get_user_and_his_song_by_id(user_id: uuid.UUID, song_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user = get_active_profile_by_id(user_id, db)

        if user:
            song = get_song_by_id(song_id, db)

            return song

    except EntityDoesNotExist:
        logging.info(strings.DB_BASE_ERROR_DETAIL, exc_info=True)
        raise HTTPException(
            status_code=404,
            detail=strings.DB_BASE_ERROR_DETAIL
        )
