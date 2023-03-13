from datetime import datetime, timezone, date
from typing import List, Dict

from pydantic import BaseModel, validator
import uuid
from pydantic.networks import EmailStr


class User(BaseModel):
    full_name: str = None
    email: str = None
    password: str = None
    age: int = None
    spotify_artist_profile: str = None
    favourite_music_style: str = None
    favourite_music_mood: str = None
    yourown_music: str = None
    favourite_music_topic: str = None
    master: str = None
    publish_control: str = None
    outside_income: str = None
    established_artist: str = None
    company: str = None
    linkedin_profile: str = None
    project_seek_music: str = None
    turn_around_time: str = None
    project_budject: str = None
    syncs_seek: str = None

    country: str = None
    state: str = None
    city: str = None
    zip: str = None

    token: str = None
    user_role: str = None
    spotify_user_id: str = None
    spotify_user_name: str = None
    music_rating: str = None
    song_writer: list = None
    own_masters: list = None
    music_publishing: str = None
    music_publishing_owners: list = None
    master_recording: str = None
    master_recording_owners: list = None
    legal_name: str = None
    coupon_code: str = None

    class Config:
        orm_mode = True


class UserLogin(BaseModel):
    email: str
    password: str


class BankDetails(BaseModel):
    first_name: str
    last_name: str
    email: str = None
    date_of_birth: date = None
    address1: str
    address2: str = None
    country: str = None
    city: str = None
    state: str = None
    zip: str
    phone_number: str
    ssn: str
    website: str

    @validator("date_of_birth", pre=True)
    def parse_birthdate(cls, value):
        return datetime.strptime(value, "%d/%m/%Y").date()


class Spotify_token(BaseModel):
    user_id: uuid.UUID
    token: str = None

    class Config:
        orm_mode = True


class ForgetPassword(BaseModel):
    email: EmailStr

    class Config:
        orm_mode = True


class ResetPassword(BaseModel):
    reset_token: str
    new_password: str

    class Config:
        orm_mode = True


class ResetToken(BaseModel):
    reset_token: str

    class Config:
        orm_mode = True


class User_update(BaseModel):
    id: uuid.UUID = None
    full_name: str = None
    email: str = None
    age: int = None
    spotify_artist_profile: str = None
    favourite_music_style: str = None
    favourite_music_mood: str = None
    yourown_music: str = None
    favourite_music_topic: str = None
    master: str = None
    publish_control: str = None
    outside_income: str = None
    established_artist: str = None
    company: str = None
    linkedin_profile: str = None
    project_seek_music: str = None
    turn_around_time: str = None
    project_budject: str = None
    syncs_seek: str = None
    token: str = None
    user_role: str = None
    spotify_user_id: str = None
    password: str = None


class user_rate(BaseModel):
    id: uuid.UUID = None
    reviewee_id: str = None
    reviewer_id: str = None
    rate: int = None

    class Config:
        orm_mode = True


class song_rate(BaseModel):
    id: uuid.UUID = None
    song_id: str = None
    reviewer_id: str = None
    rate: int = None

    class Config:
        orm_mode = True


class user_notify(BaseModel):
    full_name: str = None
    email: str = None
    user_role: str = None

    class Config:
        orm_mode = True


class Contact(BaseModel):
    name: str = None
    last_name: str = None
    email: str = None
    user_role: str = None
    message: str = None
    company_name: str = None
    number_of_employees: str = None

    class Config:
        orm_mode = True


class Update_Contact(BaseModel):
    id: uuid.UUID = None
    reply: str = None
    name: str = None
    email: str = None
    message: str = None

    class Config:
        orm_mode = True


class Update_Password(BaseModel):
    user_id: uuid.UUID
    password: str

    class Config:
        orm_mode = True


class Songs(BaseModel):
    user_id: uuid.UUID
    project_id: uuid.UUID = None

    artist_title: str = None
    music_title: str = None
    genre: str = None
    own_recording: bool = None

    parties: List[dict] = None  # [{"name": "", "email": "", "percentage": ""}]
    writers: List[dict] = None
    # [{"writerName": "", "writerPRO": "", "writerIPI": "", "writerPerc": "", "writerEmail": ""}]
    publishers: List[dict] = None
    # [{"publisherName": "", "publisherPRO": "", "publisherIPI": "", "publisherPerc": "", "publisherEmail": ""}]

    writing_credits: int = None
    publisher_credits: int = None
    origin_url: str = None
    clean_url: str = None
    instrumental_url: str = None
    cover_photo: str = None

    music_duration: str = None
    track_id: str = None
    spotify_id: str = None
    bpm: str = None

    class Config:
        orm_mode = True


class UpdateSong(BaseModel):
    song_id: uuid.UUID = None
    project_id: uuid.UUID = None

    artist_title: str = None
    music_title: str = None
    genre: str = None
    own_recording: bool = None

    parties: List[dict] = None
    writers: List[dict] = None
    publishers: List[dict] = None

    writing_credits: int = None
    publisher_credits: int = None

    origin_url: str = None
    clean_url: str = None
    instrumental_url: str = None
    cover_photo: str = None

    music_duration: str = None
    track_id: str = None
    spotify_id: str = None
    bpm: str = None

    class Config:
        orm_mode = True


class Atach_Songs(BaseModel):
    project_id: uuid.UUID

    class Config:
        orm_mode = True


class Projects(BaseModel):
    user_id: uuid.UUID
    name: str = None
    description: str = None

    # songs: Songs | None = None

    class Config:
        orm_mode = True


class Edit_projects(BaseModel):
    name: str = None
    description: str = None

    class Config:
        orm_mode = True


class Edit_artist(BaseModel):
    user_id: uuid.UUID
    artist_name: str = None
    legal_name: str = None
    profile_pic: str = None

    writerPRO: str = None
    writerIPI: str = None

    publisherName: str = None
    publisherPRO: str = None
    publisherIPI: str = None

    spotify_profile: str = None

    label: str = None
    country: str = None
    state: str = None
    city: str = None
    email: str = None
    zip: str = None
    about_me: str = None

    class Config:
        orm_mode = True


class Count_likes(BaseModel):
    user_id: uuid.UUID
    song_id: uuid.UUID
    status: str = None

    class Config:
        orm_mode = True


class Edit_supervisor(BaseModel):
    user_id: uuid.UUID
    name: str = None
    company: str = None
    linkedin_profile: str = None
    profile_pic: str = None
    email: str = None
    country: str = None
    state: str = None
    city: str = None
    zip: str = None
    about_me: str = None

    class Config:
        orm_mode = True


class Feedback(BaseModel):
    user_id: uuid.UUID
    easyto_understand: str = None
    songs_satisfaction: str = None
    easyto_navigate: str = None
    licensing_effective: str = None
    improve_ideas: str = None

    class Config:
        orm_mode = True


class Licence_data(BaseModel):
    user_id: uuid.UUID
    song_id: uuid.UUID
    # project_id: uuid.UUID = None
    # project_type_id: uuid.UUID = None
    # artist_id: uuid.UUID

    label: str = None
    email: str = None
    percentage: int = None
    writers: List[dict] = None
    # [{"writerName": "", "writerPRO": "", "writerIPI": "", "writerPerc": "", "writerEmail": ""}]
    publishers: List[dict] = None
    # [{"publisherName": "", "publisherPRO": "", "publisherIPI": "", "publisherPerc": "", "publisherEmail": ""}]

    # date: str = None
    fee: int = None
    use: str = None

    supervisor_invoice_info: List[dict] = None  # [{"address": "", "city": "", "supervisor": ""}]

    step: int = None
    licence_agreement: bool = None
    payment_status: bool = None
    status: int = None

    project: Dict = None


class Config:
    orm_mode = True


class Apply_licence(BaseModel):
    user_id: uuid.UUID
    song_id: uuid.UUID
    status: int
    licensor: list = None
    producer: list = None

    class Config:
        orm_mode = True


class Song_clearenceform(BaseModel):
    artist_id: uuid.UUID
    song_id: uuid.UUID
    artist_name: str
    song_title: str
    description: str
    message: str

    class Config:
        orm_mode = True


class Song_approval(BaseModel):
    song_id: uuid.UUID

    class Config:
        orm_mode = True


class Notification(BaseModel):
    user_id: uuid.UUID
    song_id: uuid.UUID
    artist_id: uuid.UUID
    music_title: str = None
    track_id: str = None
    status: int = None  # licence approved 1 ,quoted 0

    class Config:
        orm_mode = True


class Similar_tracks(BaseModel):
    supervisor_id: uuid.UUID
    artist_id: uuid.UUID = None
    song_id: uuid.UUID = None
    search_artistid: str
    search_artistname: str = None
    track_id: str
    search_trackname: str = None
    song_details: list

    class Config:
        orm_mode = True


class Notificationseen_update(BaseModel):
    notification_id: uuid.UUID
    seen: int = None

    class Config:
        orm_mode = True


class Payment(BaseModel):
    supervisor_id: uuid.UUID
    card_number: int = None
    expmonth: str = None
    expyear: str = None
    cvv: str = None
    amount: str
    invoice_number: int

    class Config:
        orm_mode = True


class Artist_disapproval(BaseModel):
    song_id: uuid.UUID
    name: str
    role: str
    email: str

    class Config:
        orm_mode = True


class Transfer_amount(BaseModel):
    artist_id: uuid.UUID
    amount: str
    account_number: str
    email: str
    routing_number: str
    company_legal_name: str
    business_tax_id: str
    business_name: str
    business_url: str = None

    class Config:
        orm_mode = True


class ACH_Payment(BaseModel):
    supervisor_id: uuid.UUID
    invoice_number: int

    class Config:
        orm_mode = True
