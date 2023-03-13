import logging
import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from fastapi import File, UploadFile, Query
import boto3
from config.config import settings
from botocore.exceptions import ClientError
from botocore.client import BaseClient
from auth.jwt_bearer import JWTBearer
from dependencies.profiles import get_active_profile_by_id
from utils import strings

app = APIRouter()


def s3_auth() -> BaseClient:
    s3 = boto3.client(service_name='s3', aws_access_key_id=settings.AWS_ACCESS_KEY,
                      aws_secret_access_key=settings.AWS_SECRET_KEY
                      )
    return s3


def _set_upload_info_to_db(db, user_id, url, obj_name):
    try:
        set_info = models.Upload_User_Files(
            id=uuid.uuid4(),
            user_id=user_id,
            s3_file_url=url,
            filename=obj_name
        )
        db.add(set_info)
        db.commit()

        logging.info("File info successfully add to upload_user_files", exc_info=True)

    except ClientError as e:
        logging.error(e)
        return False


async def upload_file_to_bucket(s3_client, file_obj, bucket, folder=None, object_name=None):
    # If S3 object_name was not specified, use file_name
    if object_name is None:
        object_name = file_obj

    # Upload the file
    try:
        if folder is None:
            response = s3_client.upload_fileobj(file_obj, bucket, f"{object_name}")
        else:
            response = s3_client.upload_fileobj(file_obj, bucket, f"{folder}/{object_name}")

    except ClientError as e:
        logging.error(e)
        return False
    return object_name


# UPLOAD ORIGIN VERSION
# UPLOAD INSTRUMENTAL VERSION
# Upload CLEAN VERSION
@app.post('/upload_audio_files', tags=["uploads"], summary="Upload Audios to AWS S3 Buckets",
          dependencies=[Depends(JWTBearer())])
async def upload_file(user_id: uuid.UUID, tag: str = Query("origin", enum=["origin", "instrumental", "clean"]),
                      db: Session = Depends(get_db), s3: BaseClient = Depends(s3_auth),
                      file_obj: UploadFile = File(...)):
    user = await get_active_profile_by_id(user_id, db)

    try:

        folder_location = f"{user_id}/audio"

        upload_obj = await upload_file_to_bucket(
            s3_client=s3,
            file_obj=file_obj.file,
            bucket=settings.S3_BUCKET_NAME,
            folder=folder_location,
            object_name=f"{tag}_{file_obj.filename}"
        )

        url = f"{settings.S3_URL}/{folder_location}/{upload_obj}"

        _set_upload_info_to_db(db, user.id, url, upload_obj)

        return {
            "status": "success",
            "Response": "audio has been uploaded to bucket successfully",
            "original_name": file_obj.filename,
            "object_name": upload_obj,
            "version": tag,
            "url": url
        }

    except:
        logging.error("Exception occurred. Uploading of audio failed", exc_info=True)
        raise HTTPException(
            status_code=404,
            detail=strings.FILE_CANT_BE_UPLOADED
        )


@app.post('/upload_album_cover_photo', tags=["uploads"], summary="Upload Images to AWS S3 Buckets",
          dependencies=[Depends(JWTBearer())])
async def upload_album_cover_photo(user_id, db: Session = Depends(get_db), s3: BaseClient = Depends(s3_auth),
                                   file_obj: UploadFile = File(...)):
    user = await get_active_profile_by_id(user_id, db)

    try:
        folder_name = "cover_photo"
        folder_location = f"{user_id}/{folder_name}"

        upload_obj = await upload_file_to_bucket(
            s3_client=s3,
            file_obj=file_obj.file,
            bucket=settings.S3_BUCKET_NAME,
            folder=folder_location,
            object_name=file_obj.filename
        )
        url = f"{settings.S3_URL}/{folder_location}/{upload_obj}"

        _set_upload_info_to_db(db, user.id, url, upload_obj)

        return {
            "status": "success",
            "Response": "Cover photo has been uploaded to bucket successfully",
            "url": url,
            "user_id": user_id
        }

    except:
        logging.error("Exception occurred. Uploading of cover_photo failed", exc_info=True)
        raise HTTPException(
            status_code=404,
            detail=strings.FILE_CANT_BE_UPLOADED
        )


@app.post('/upload_image_files', tags=["uploads"], summary="Upload Images to AWS S3 Buckets",
          dependencies=[Depends(JWTBearer())])
async def upload_file(user_id, db: Session = Depends(get_db), s3: BaseClient = Depends(s3_auth),
                      file_obj: UploadFile = File(...)):
    user = await get_active_profile_by_id(user_id, db)

    try:
        folder_name = "photo"
        folder_location = f"{user_id}/{folder_name}"

        upload_obj = await upload_file_to_bucket(
            s3_client=s3,
            file_obj=file_obj.file,
            bucket=settings.S3_BUCKET_NAME,
            folder=folder_location,
            object_name=file_obj.filename
        )
        url = f"{settings.S3_URL}/{folder_location}/{upload_obj}"

        _set_upload_info_to_db(db, user.id, url, upload_obj)

        return {
            "status": "success",
            "Response": "User photo has been uploaded to bucket successfully",
            "url": url,
            "user_id": user_id
        }

    except:
        logging.error("Exception occurred. Uploading of cover_photo failed", exc_info=True)
        raise HTTPException(
            status_code=404,
            detail=strings.FILE_CANT_BE_UPLOADED
        )


@app.post('/upload_profile_pic', tags=["uploads"], summary="Upload Images to AWS S3 Buckets",
          dependencies=[Depends(JWTBearer())])
async def upload_file(user_id, db: Session = Depends(get_db), s3: BaseClient = Depends(s3_auth),
                      file_obj: UploadFile = File(...)):
    user = await get_active_profile_by_id(user_id, db)

    try:
        folder_name = "profile_pic"
        folder_location = f"{user_id}/{folder_name}"

        upload_obj = await upload_file_to_bucket(
            s3_client=s3,
            file_obj=file_obj.file,
            bucket=settings.S3_BUCKET_NAME,
            folder=folder_location,
            object_name=file_obj.filename
        )
        url = f"{settings.S3_URL}/{folder_location}/{upload_obj}"

        _set_upload_info_to_db(db, user.id, url, upload_obj)

        return {
            "status": "success",
            "Response": "User photo has been uploaded to bucket successfully",
            "url": url,
            "user_id": user_id
        }

    except:
        logging.error("Exception occurred. Uploading of cover_photo failed", exc_info=True)
        raise HTTPException(
            status_code=404,
            detail=strings.FILE_CANT_BE_UPLOADED
        )
