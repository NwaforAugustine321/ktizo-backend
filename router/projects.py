import schemas
import logging
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer
import uuid
from datetime import date

app = APIRouter()


@app.post("/projects", tags=["projects"], dependencies=[Depends(JWTBearer())])
async def create_project(project: schemas.Projects, db: Session = Depends(get_db)):
    try:
        active_user = db.query(models.User_details).filter(models.User_details.id == project.user_id).filter(
            models.User_details.active_status == 0).first()

        if active_user is not None:
            id = uuid.uuid4()
            created_date = date.today()

            project_data = models.Projects(
                id=id,
                user_id=active_user.id,
                name=project.name,
                description=project.description,
                created_date=created_date
            )
            db.add(project_data)
            db.commit()
            db.refresh(project_data)
            return {"status": "success", "response": project_data}

        else:
            logging.info(f"user with id {project.user_id} doesnot exists", exc_info=True)
            return {
                "status": "failed",
                "response": f"user with id {project.user_id} doesnot exists",
            }

    except:
        logging.error("Exception occurred. Unable to store project details", exc_info=True)


@app.get("/artists/{user_id}/projects/", tags=["projects"], dependencies=[Depends(JWTBearer())])
def get_user_projects_list(user_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        active_user = db.query(models.User_details).filter(models.User_details.id == user_id).filter(
            models.User_details.active_status == 0).first()

        if active_user is not None:
            projects = active_user.projects

            return {"status": "success", "response": projects}

        else:
            logging.info("User not exist", exc_info=True)
            return {
                "status": "failed",
                "response": "User not exist",
            }

    except:
        logging.error("Exception occurred. Unable to get projects details", exc_info=True)


@app.get("/projects/{project_id}", tags=["projects"], dependencies=[Depends(JWTBearer())])
def get_project(user_id: uuid.UUID, project_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        active_user = db.query(models.User_details).filter(models.User_details.id == user_id).filter(
            models.User_details.active_status == 0).first()

        if active_user is not None:
            project = db.query(models.Projects).filter(models.Projects.user_id == user_id).filter(
                models.Projects.id == project_id).first()

            if not project:
                logging.info("Project for this user does not exist", exc_info=True)
                return {
                    "status": "failed",
                    "response": "Project for this user does not exist"
                }

            response = {
                "user_id": project.user_id,
                "name": project.name,
                "id": project.id,
                "description": project.description,
                "created_date": project.created_date,
                "saved_songs": project.songs,
                "licensed_songs": [song for song in project.songs if song.status == 1]
            }

            return {"status": "success", "response": response}

        else:
            logging.info(
                "User not exist", exc_info=True
            )
            return {
                "status": "failed",
                "response": "User not exist",
            }
    except:
        logging.error("Exception occurred. Unable to get projects details", exc_info=True)


@app.patch("/update_project/{project_id}", tags=["projects"], dependencies=[Depends(JWTBearer())])
async def update_project(user_id: uuid.UUID, project_id: uuid.UUID, edit_project: schemas.Edit_projects,
                         db: Session = Depends(get_db)):
    try:
        active_user = db.query(models.User_details).filter(models.User_details.id == user_id).filter(
            models.User_details.active_status == 0).first()

        if active_user is not None:
            project = db.query(models.Projects).filter(models.Projects.user_id == user_id).filter(
                models.Projects.id == project_id).first()

            if not project:
                logging.info("Project for this user does not exist", exc_info=True)
                return {
                    "status": "failed",
                    "response": "Project for this user does not exist"
                }

            update_data = {
                "name": edit_project.name,
                "description": edit_project.description
            }
            for name, value in update_data.items():
                setattr(project, name, value)
            db.add(project)
            db.commit()

            return {"status": "success", "response": f"Project with id: {project_id} successfully deleted"}

        else:
            logging.info(
                "User not exist", exc_info=True
            )
            return {
                "status": "failed",
                "response": "User not exist",
            }
    except:
        logging.error("Exception occurred. Unable to get projects details", exc_info=True)


@app.delete("/delete_project/{project_id}", tags=["projects"], dependencies=[Depends(JWTBearer())])
def add_song_to_project(user_id: uuid.UUID, project_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        active_user = db.query(models.User_details).filter(models.User_details.id == user_id).filter(
            models.User_details.active_status == 0).first()

        if active_user is not None:
            project = db.query(models.Projects).filter(models.Projects.user_id == user_id).filter(
                models.Projects.id == project_id).first()

            if not project:
                logging.info("Project for this user does not exist", exc_info=True)
                return {
                    "status": "failed",
                    "response": "Project for this user does not exist"
                }

            db.delete(project)
            db.commit()
            db.refresh(project)

            return {"status": "success", "response": project}

        else:
            logging.info(
                "User not exist", exc_info=True
            )
            return {
                "status": "failed",
                "response": "User not exist",
            }
    except:
        logging.error("Exception occurred. Unable to get projects details", exc_info=True)


@app.patch("/projects/{project_id}/add_song", tags=["projects"], dependencies=[Depends(JWTBearer())])
async def delete_song_from_project(project_id: uuid.UUID, song_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        project = db.query(models.Projects).filter(models.Projects.id == project_id).first()

        if not project:
            logging.info("Project does not exist", exc_info=True)
            return {
                "status": "failed",
                "response": "Project for this user does not exist"
            }

        song = db.query(models.Songs).filter(models.Songs.id == song_id).first()

        if not song:
            logging.info("Song does not exist", exc_info=True)
            return {
                "status": "failed",
                "response": "Song does not exist"
            }

        updated_data = {
            "project_id": project.id
        }
        for name, value in updated_data.items():
            setattr(song, name, value)

        db.add(song)
        db.commit()
        db.refresh(song)

        return {"status": "success", "response": f"Song with id: {song_id} successfully added to the project"}

    except:
        logging.error("Exception occurred. Unable to get projects details", exc_info=True)


@app.patch("/projects/{project_id}/delete_song", tags=["projects"], dependencies=[Depends(JWTBearer())])
async def update_project(project_id: uuid.UUID, song_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        project = db.query(models.Projects).filter(models.Projects.id == project_id).first()

        if not project:
            logging.info("Project does not exist", exc_info=True)
            return {
                "status": "failed",
                "response": "Project for this user does not exist"
            }

        song = db.query(models.Songs).filter(models.Songs.id == song_id).first()

        if not song:
            logging.info("Song does not exist", exc_info=True)
            return {
                "status": "failed",
                "response": "Song does not exist"
            }

        updated_data = {
            "project_id": None
        }
        for name, value in updated_data.items():
            setattr(song, name, value)

        db.add(song)
        db.commit()
        db.refresh(song)

        return {"status": "success", "response": f"Song with id: {song_id} successfully added to the project"}

    except:
        logging.error("Exception occurred. Unable to get projects details", exc_info=True)


@app.get("/project_types", tags=["projects"], dependencies=[Depends(JWTBearer())])
def songs_list(db: Session = Depends(get_db)):
    try:
        project_types = db.query(models.Project_Types).all()

        if project_types:
            return {"status": "success", "response": project_types}
        else:
            return {
                "status": "failed",
                "response": f"Unable to get project details",
            }

    except:
        logging.error("Exception occurred. Unable to get project details", exc_info=True)
