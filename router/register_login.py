import schemas
import uuid
import logging
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from config.config import settings
from db.database import get_db
from db import models
from hash.hash import Hasher
from utils import emailutil
from datetime import datetime, timedelta
from auth.jwt_handler import signJWT
from auth.jwt_bearer import JWTBearer

app = APIRouter()
CLIENT_ID = settings.SPOTIFY_CLIENT_ID
CLIENT_SECRET = settings.SPOTIFY_CLIENT_SECRET

client_credentials_manager = SpotifyClientCredentials(
    client_id=CLIENT_ID, client_secret=CLIENT_SECRET
)
sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)


# To signup a user
@app.post("/signup", tags=["auth"])
async def user_signup(user_input: schemas.User, db: Session = Depends(get_db)):
    try:
        user_register = db.query(models.User_details).filter(models.User_details.email == user_input.email).first()
        if user_register is None:
            id = uuid.uuid4()
            today_date = datetime.now().strftime("%Y/%m/%d %H:%M:%S")

            new_user = models.User_details(
                id=id,
                full_name=user_input.full_name,
                email=user_input.email,
                password=Hasher.get_hash_password(user_input.password),

                country=user_input.country,
                state=user_input.state,
                city=user_input.city,
                zip=user_input.zip,

                age=user_input.age,
                spotify_artist_profile=user_input.spotify_artist_profile,
                favourite_music_style=user_input.favourite_music_style,
                favourite_music_mood=user_input.favourite_music_mood,
                yourown_music=user_input.yourown_music,
                favourite_music_topic=user_input.favourite_music_topic,
                master=user_input.master,
                publish_control=user_input.publish_control,
                outside_income=user_input.outside_income,
                established_artist=user_input.established_artist,
                company=user_input.company,
                linkedin_profile=user_input.linkedin_profile,
                project_seek_music=user_input.project_seek_music,
                turn_around_time=user_input.turn_around_time,
                project_budject=user_input.project_budject,
                syncs_seek=user_input.syncs_seek,
                token=user_input.token,
                user_role=user_input.user_role,
                spotify_user_id=user_input.spotify_user_id,
                spotify_user_name=user_input.spotify_user_name,
                master_recording_owners=user_input.master_recording_owners,
                music_rating=user_input.music_rating,

                song_writer=user_input.song_writer,
                own_masters=user_input.own_masters,
                music_publishing=user_input.music_publishing,
                music_publishing_owners=user_input.music_publishing_owners,
                master_recording=user_input.master_recording,
                legal_name=user_input.legal_name,
                coupon_code=user_input.coupon_code,
                coupon_created_date=today_date

            )
            db.add(new_user)
            db.commit()
            db.refresh(new_user)

            # link should be as 'https://open.spotify.com/artist/7dGJo4pcD2V6oG8kP0tJRR'
            if user_input.spotify_artist_profile:
                url = user_input.spotify_artist_profile
                urn = f"spotify:artist:{url.split('/')[-1]}"
                try:
                    artist = sp.artist(urn)
                    update_user = {
                        'spotify_user_id': artist.get('id'),
                        'spotify_user_name': artist.get('name'),
                        'profile_pic': artist.get('images')[0].get('url')
                    }

                    for name, value in update_user.items():
                        setattr(new_user, name, value)

                        db.add(new_user)
                        db.commit()
                        db.refresh(new_user)

                    find_tracks = sp.search(q=f"artist:{artist.get('name')}", type="track", limit=50)
                    for song in find_tracks.get('tracks').get('items'):
                        id = uuid.uuid4()
                        new_song = models.Songs(
                            id=id,
                            music_titile=song.get('name'),
                            track_id=song.get('id'),
                            user_id=new_user.id,
                            spotify_id=song.get('id'),
                            spotify_artist_id=[artist.get("i") for artist in song.get('artistis')],
                            cover_photo=song.get('preview_url'),
                            status=0
                        )
                        db.add(new_song)
                        db.commit()
                except:
                    logging.error("Exception occurred. User not able to get info from Spotify", exc_info=True)

            await user_email(new_user.email, new_user.full_name, new_user.user_role)
            user_details = db.query(models.User_details).filter(models.User_details.id == id).first()
            user_details.__dict__.pop("password")

            return {"status": "success", "response": f'Successfully registerd', "user_details": user_details}
        else:
            return {"response": "User Already Exists"}
    except:
        logging.error("Exception occurred. User not able to register", exc_info=True)


# To login a user
@app.post('/login', tags=["auth"])
def login(user: schemas.UserLogin, db: Session = Depends(get_db)):
    try:
        user_login = db.query(models.User_details).filter(models.User_details.email == user.email).filter(
            models.User_details.active_status == 0).first()
        if user_login is None:
            return {"status": "Failed", "response": "Invalid Email"}
        if not Hasher.verify_password(user.password, user_login.password):
            return {"status": "Failed", "response": "Invalid password"}
        user_login.__dict__.pop("password")
        return {"status": "Success", "response": f'Successfully Logged In',
                "access_token": signJWT(user.email)["access token"], "user_details": user_login}
    except Exception:
        logging.error("Exception occurred. User cannot login", exc_info=True)


@app.post('/user/{user_id}/bank_details', tags=["users"], dependencies=[Depends(JWTBearer())])
async def add_bank_details(user_id: uuid.UUID, details: schemas.BankDetails, db: Session = Depends(get_db)):
    try:
        user = db.query(models.User_details).filter(models.User_details.id == user_id).first()
        if user:
            if user.bank_details:
                bank_id = uuid.uuid4()

                bank_details = models.BankDetails(
                    id=bank_id,
                    user_id=user.id,

                    first_name=details.first_name,
                    last_name=details.last_name,
                    email=details.email,
                    date_of_birth=details.date_of_birth,
                    country=details.country,
                    address1=details.address1,
                    address2=details.address2,
                    city=details.city,
                    state=details.state,
                    zip=details.zip,
                    phone_number=details.phone_number,
                    ssn=details.ssn,
                    website=details.website,
                )

                db.add(bank_details)
                db.commit()
                db.refresh(bank_details)

                user.is_stripe_connected = True
                db.add(user)
                db.commit()
                return {"status": "success", "response": bank_details}
            else:
                return {
                    "status": "failed",
                    "response": "User already has a card",
                }

    except:
        logging.error("Exception occurred. User not able to register", exc_info=True)


@app.get('/user/{user_id}/bank_details', tags=["users"], dependencies=[Depends(JWTBearer())])
def get_bank_details(user_id: uuid.UUID, details: schemas.BankDetails, db: Session = Depends(get_db)):
    try:
        user = db.query(models.User_details).filter(models.User_details.id == user_id).first()
        if user:
            bank_details = db.query(models.BankDetails).filter(models.BankDetails.user_id == user_id).first()
            return {"status": "success", "response": bank_details}
        else:
            return {
                "status": "failed",
                "response": "Project for this user does not exist"
            }
    except:
        logging.error("Exception occurred. User not able to register", exc_info=True)


# To get all users
@app.get('/users', tags=["users"], dependencies=[Depends(JWTBearer())])
def get_users(db: Session = Depends(get_db)):
    users = db.query(models.User_details).all()

    return users


@app.get("/users/{id}", tags=["users"], dependencies=[Depends(JWTBearer())])
def find_user_by_id(id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        user_details = db.query(models.User_details).filter(models.User_details.id == id).filter(
            models.User_details.active_status == 0).first()
        if user_details is not None:
            user_details.__dict__.pop("password")
            return {
                "status": "success",
                "response": f"details of user with id {user_details.id}", "user_data": user_details
            }
        else:
            logging.info(
                "user details not available", exc_info=True
            )
            return {
                "status": "failed",
                "response": "user details not available",
            }
    except Exception:
        logging.error("Exception occurred. userdetails not available", exc_info=True)
        return {"status": "failed", "response": "userdetails not available"}


# To update user data
@app.post('/update_user/', tags=["users"], dependencies=[Depends(JWTBearer())])
def update_user(user: schemas.User_update, db: Session = Depends(get_db)):
    update_data = db.query(models.User_details).filter(models.User_details.id == user.id).filter(
        models.User_details.active_status == 0).first()
    if update_data is not None:

        for name, value in dict(user).items():
            setattr(update_data, name, value)

        db.add(update_data)
        db.commit()
        update_data = db.query(models.User_details).filter(models.User_details.id == user.id).all()
        return {"response": f'successfully updated', "user_details": update_data}
    else:
        return {"response": "User doesnot exist"}


# forget password
@app.post('/forget_password', tags=["auth"])
async def forget_password(forget_password: schemas.ForgetPassword, db: Session = Depends(get_db)):
    # check user exists
    for_password = db.query(models.User_details).filter(models.User_details.email == forget_password.email).filter(
        models.User_details.active_status == 0).first()
    if for_password is None:
        return {"status": "failed", "response": "User doesnot exist"}
    # check whether reset token is created before
    check_token = db.query(models.ResetPassword).filter(models.ResetPassword.email == forget_password.email).first()
    if check_token is not None:
        db.delete(check_token)
        db.commit()
        # create reset token and save in database
    reset_token = str(uuid.uuid4())
    reset = models.ResetPassword(
        id=uuid.uuid4(),
        email=forget_password.email,
        status=True,
        reset_token=reset_token,
        expired_in=datetime.now() + timedelta(minutes=30)
    )

    db.add(reset)
    db.commit()
    # sending email
    subject = "Hello {}".format(for_password.full_name)
    recipient = [forget_password.email]
    message = """
    <!DOCTYPE html>
    <html>
    <title>Reset Password</title>
    <body>
    <div style="width:100%; font-family: monospace;">
    <h1>Hello<h1>
    <p>change your password by clicking the below link</p>
    <a href="https://ktizo.io/userss/reset_token?token={}">Please click the link to reset your password</a>
    <div>
    <body>
    </html>
    """.format(reset_token)
    await emailutil.send_email(recipient, subject, message)
    return {"reset_token": reset_token, "response": "Email send successfully", "id": for_password.id}


@app.patch('/reset_password', tags=["auth"])
def reset_password(reset_password: schemas.ResetPassword, db: Session = Depends(get_db)):
    try:
        # check valid reset password token
        re_password = db.query(models.ResetPassword).filter(
            models.ResetPassword.reset_token == reset_password.reset_token).first()
        if re_password.expired_in < datetime.now():
            return {"status": "failed", "response": "Reset password token has expired, please request a new token"}
        # reset new password
        user = db.query(models.User_details).filter(models.User_details.email == re_password.email).first()
        update_data = {"password": Hasher.get_hash_password(reset_password.new_password)}
        for name, value in update_data.items():
            setattr(user, name, value)

        db.add(user)
        db.commit()
        # delete the user with reset_token after resetting the password
        db.delete(re_password)
        db.commit()
    except Exception as e:
        logging.error("Exception occurred.reset_token doesnot exists", exc_info=True)
    return {"status": "success", "response": "Password changed successfully"}


# to verify reset token
@app.post('/reset_password_token', tags=["auth"])
def reset_password(reset_token: schemas.ResetToken, db: Session = Depends(get_db)):
    try:
        # check valid reset password token
        re_token = db.query(models.ResetPassword).filter(
            models.ResetPassword.reset_token == reset_token.reset_token).first()
        if re_token is not None:
            if re_token.expired_in < datetime.now():
                db.delete(re_token)
                db.commit()
                return {"response": "Reset Token does not exist"}
            else:
                return {"response": "Reset Token exists"}
        else:
            return {"response": "Reset Token does not exist"}
    except Exception as e:
        logging.error("Exception occurred.reset_token doesnot exists", exc_info=True)


async def user_email(email, full_name, user_role):
    if user_role == "Artist":

        subject = "Welcome to Ktizo!"
        recipient = [email]
        message = f"""Hi {full_name.capitalize()},
        <!DOCTYPE html>
        <html>
        <body>
        <div>
        <p>You’ve successfully joined Ktizo!</p>
    
        <p>Getting started is easy:</p>
        <ol>
            <li>Sign into your account</li>
            <li>Upload your song files (MP3 or WAV)</li> 
            <li>Enter your split sheet information for each song uploaded (This is required)</li>
        </ol> 
    
        <p>After you complete this onboarding process, we highly recommend that you connect with any of your collaborators,
         publishers, or labels to give them a heads-up that you’ve joined Ktizo. Our Syncable app can only sync songs that 
         have been approved and cleared, so having all your copyright information correct is important!</p>
    
        <p>In the meantime, we’re grateful for your trust and look forward to working with you. We're excited to empower 
        your artistry and serve all your music licensing needs.</p>
    
        <p>If you have any questions or concerns, please contact us at music@ktizo.io.</p>
        
        <p>Thanks,</p>
        <p>Malcolm Coronel</p>
        <p>Founder & CEO of Ktizo </p>  
        </div>
        </body>
        </html>
        """
    else:
        subject = "Welcome to Ktizo!"
        recipient = [email]
        message = f"""Hi {full_name.capitalize()},
        <!DOCTYPE html>
        <html>
        <body>
        <div>
        <p>Thanks for joining Ktizo!</p>
        
        <p>We know that being a music supervisor means managing various responsibilities at once, so we’re excited to 
        accelerate your workflow and help you license pre-cleared quality music in one single platform.</p>
    
        <p>Getting started is easy:</p>
        <ol>
            <li>Sign into your account</li>
            <li>Start discovering song matches with Syncable</li> 
            <li>Download, license, and pay for songs when you’re ready</li>
        </ol> 
    
        <p>With Ktizo, you can access incredible music from some of the most talented emerging artists. 
        More importantly, our licensing process is fast and intuitive without missing any important steps.</p>
    
    
        <p>On your dashboard, you’ll have the ability to provide user feedback. As an early-stage company, we welcome any
         feedback to refine our product to serve your licensing needs better.</p>
    
        <p>We hope to have a long-term working relationship with you, and we’re grateful for your trust.</p>
    
        <p>If you have any questions or concerns, please contact us at music@ktizo.io.</p>
    
        <p>Thanks,</p>
        <p>Malcolm Coronel</p>
        <p>Founder & CEO of Ktizo </p>  
        </div>
        </body>
        </html>
        """
    await emailutil.send_email(recipient, subject, message)
