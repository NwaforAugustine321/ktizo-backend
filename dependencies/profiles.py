from operator import and_
import uuid
import logging
from fastapi import APIRouter, Depends, HTTPException, Path
from sqlalchemy.orm import Session
from db.database import get_db
from db import models

from db.errors import EntityDoesNotExist
from utils import strings


async def get_active_profile_by_id(user_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        active_user = db.query(models.User_details).filter(
            and_(
                models.User_details.id == user_id,
                models.User_details.active_status == 0
            )
        ).first()

        if not active_user:
            logging.info(strings.USER_DOES_NOT_EXIST_ERROR.format(id=user_id), exc_info=True)
            raise HTTPException(
                status_code=404,
                detail=strings.USER_DOES_NOT_EXIST_ERROR.format(id=user_id)
            )

        return active_user
    except EntityDoesNotExist:
        logging.info(strings.DB_BASE_ERROR_DETAIL, exc_info=True)
        raise HTTPException(
            status_code=404,
            detail=strings.DB_BASE_ERROR_DETAIL
        )
