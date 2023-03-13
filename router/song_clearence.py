import uuid
import schemas
import logging
from db.models import User_details
from utils import emailutil
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from auth.jwt_bearer import JWTBearer

app = APIRouter()


async def user_email(artist_name, song_title, message, description, song_id, writers):
    for writer in writers:
        subject = "Ktizo - Song Clearence Request"
        recipient = [writer['email']]
        message = """Hi {} 
            <!DOCTYPE html>
            <html>
            <body>
            <div style="width:100%;">
            <p>You're involved in the song <b>{}</b> that will be on Ktizo's platform and potentially licensed.</p>

            <p>if you don't want this song to be licensed to TV, movies, or commercials, please click below:</p>
            <a href="http://localhost:3000/disapprove?song_id={}"> <input type="button" style="background-color:blue;color:white;width:190px;height:40px;border: 1px solid #0000FF;" value="Click here to disapprove"></a>

            <p>Otherwise, no response is an acknowledgment of approval for this song to be licensed.</p>

            <p>Thank you,</p
            <p>Team at Ktizo</p>
            </div>
            </body>
            </html>
            """.format(writer['name'], song_title, song_id)
        await emailutil.send_email(recipient, subject, message)


# song_clearence
@app.post("/song_clearence", tags=["songs"], dependencies=[Depends(JWTBearer())])
async def contact_artist(clearence_form: schemas.Song_clearenceform, db: Session = Depends(get_db)):
    try:

        contact_user = db.query(models.User_details, models.Songs).join(models.Songs).filter(
            models.Songs.id == clearence_form.song_id).filter(
            models.User_details.id == clearence_form.artist_id).first()
        writers = []
        for writer in contact_user['Songs'].writers:
            email = writer['writerEmail']
            name = writer['writerName']
            data = {"email": email, "name": name}
            writers.append(data)
        for publisher in contact_user['Songs'].publishers:
            email = publisher['publisherEmail']
            name = publisher['publisherName']
            data = {"email": email, "name": name}
            writers.append(data)
        await user_email(clearence_form.artist_name, clearence_form.song_title, clearence_form.message,
                         clearence_form.description, clearence_form.song_id, writers)
        return {"status": "success", "response": "Email send successfully"}
    except:
        logging.error("Exception occurred. Unable to send email", exc_info=True)


@app.get("/song_invoice/{id}", tags=["payments"], dependencies=[Depends(JWTBearer())])
async def approved_songs_list(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        show_result = db.query(models.Licence, models.Songs.id).join(models.Songs).filter(
            models.Licence.user_id == id).filter(models.Licence.status == 1).all()
        if show_result:
            values = []
            for results in show_result:
                get_songdetails = db.query(models.User_details, models.Songs).join(models.Songs).filter(
                    models.Songs.id == results.id).filter(models.User_details.active_status == 0).first()
                if get_songdetails is not None:
                    data = {
                        "artist_id": get_songdetails['User_details'].id,
                        "profile_pic": get_songdetails['User_details'].profile_pic,
                        "Name": get_songdetails['User_details'].full_name,
                    }
                    values.append(data)
                res_list = []
                for i in range(len(values)):
                    if values[i] not in values[i + 1:]:
                        res_list.append(values[i])
            return {"status": "success", "response": res_list}
        else:
            logging.info(
                "no songs found", exc_info=True
            )
            return {
                "status": "failed",
                "response": "No Songs Found",
            }
    except:
        logging.error("no songs  found", exc_info=True)


@app.post("/song_disapproval", tags=["songs"])
async def artist_disapproval(user_details: schemas.Artist_disapproval, db: Session = Depends(get_db)):
    try:
        user_data = db.query(models.Songs, User_details).join(models.User_details).filter(
            models.Songs.id == user_details.song_id).first()
        music_title = user_data['Songs'].music_title
        artistemail = user_data['User_details'].email
        artist_name = user_data['User_details'].full_name
        name = user_details.name
        role = user_details.role
        email = user_details.email

        await send_disapproval_email(music_title, artistemail, artist_name, name, role, email)
        return {"status": "success", "response": "Email send successfully"}
    except:
        logging.error("Exception occurred. Unable to send email", exc_info=True)


async def send_disapproval_email(music_title, artistemail, artist_name, name, role, email):
    subject = "Ktizo - Song approval rejected"
    recipient = ["music@ktizo.io"]
    message = f"""
<!DOCTYPE html>
<html>
<body>
<div style="width:100%; font-family: monospace;">

<p> Artist Name - {artist_name} </p>

<p> Artist Email - {artistemail} </p>

<p>Music Title - {music_title}</p>

<p>Writer Name - {name}</p>

<p>Writer Email - {email}</p>

<p>Writer Role - {role}</p>


<p>Rejected Approval</p>
</div>
</body>
</html>
        """
    # format(artistname,artistemail,music_title,artist_message)
    await emailutil.send_email(recipient, subject, message)
