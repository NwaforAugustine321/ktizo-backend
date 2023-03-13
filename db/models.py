from db.database import Base
from sqlalchemy import Float, ForeignKey, Integer, String, Column, Boolean, DateTime, Date
from sqlalchemy_utils import UUIDType
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import JSONB


class User_details(Base):
    __tablename__ = 'user'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    full_name = Column(String(255))
    email = Column(String(255), unique=True)
    password = Column(String(255))
    age = Column(Integer)
    legal_name = Column(String(255), nullable=True)
    spotify_artist_profile = Column(String(255))
    favourite_music_style = Column(String(255))
    favourite_music_mood = Column(String(255))
    yourown_music = Column(String(255))
    favourite_music_topic = Column(String(255))
    master = Column(String(255))
    publish_control = Column(String(255))
    outside_income = Column(String(255))
    established_artist = Column(String(255))
    company = Column(String(255))
    linkedin_profile = Column(String(255))
    project_seek_music = Column(String(255))
    turn_around_time = Column(String(255))
    project_budject = Column(String(255))
    syncs_seek = Column(String(255))

    writerPRO = Column(String(255), nullable=True)
    writerIPI = Column(String(255), nullable=True)
    publisherName = Column(String(255), nullable=True)
    publisherPRO = Column(String(255), nullable=True)
    publisherIPI = Column(String(255), nullable=True)
    label = Column(String(255), nullable=True)
    country = Column(String(255), nullable=True)
    state = Column(String(255), nullable=True)
    city = Column(String(255), nullable=True)
    zip = Column(String(255), nullable=True)

    token = Column(String(255), nullable=True)
    user_role = Column(String(255), nullable=True)
    spotify_user_id = Column(String(255), nullable=True)
    spotify_user_name = Column(String(255), nullable=True)
    profile_pic = Column(String(255), nullable=True)
    about_me = Column(String(500), nullable=True)
    music_rating = Column(String(255), nullable=True)
    song_writer = Column(JSONB, nullable=True)
    own_masters = Column(JSONB, nullable=True)
    music_publishing = Column(String(255), nullable=True)
    music_publishing_owners = Column(JSONB, nullable=True)
    master_recording = Column(String(255), nullable=True)
    master_recording_owners = Column(JSONB, nullable=True)
    account_id = Column(String(255), nullable=True)
    active_status = Column(Integer, default=0)
    coupon_code = Column(String(255), nullable=True)
    coupon_status = Column(Integer, default=0)
    coupon_created_date = Column(DateTime, nullable=True)

    is_spotify_connected = Column(Boolean, default=False)
    is_stripe_connected = Column(Boolean, default=False)


class BankDetails(Base):
    __tablename__ = 'bank_details'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    user_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    first_name = Column(String(255), nullable=True)
    last_name = Column(String(255), nullable=True)
    email = Column(String(255), nullable=True)
    date_of_birth = Column(DateTime, nullable=True)
    country = Column(String(255), nullable=True)
    address1 = Column(String(255), nullable=True)
    address2 = Column(String(255), nullable=True)
    city = Column(String(255), nullable=True)
    state = Column(String(255), nullable=True)
    zip = Column(String(255), nullable=True)
    phone_number = Column(String(255), nullable=True)
    ssn = Column(String(255), nullable=True)
    website = Column(String(255), nullable=True)

    user = relationship("User_details", backref="bank_details", cascade="all, delete", passive_deletes=True)


class ResetPassword(Base):
    __tablename__ = 'reset_password'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    email = Column(String(255), nullable=False, unique=True)
    status = Column(Boolean, nullable=False)
    reset_token = Column(String(255), nullable=False, unique=True)
    expired_in = Column(DateTime, nullable=False, unique=True)


class User_Review(Base):
    __tablename__ = 'user_ratings'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    reviewee_id = Column(String(255))
    reviewer_id = Column(String(255))
    rate = Column(Integer, default=1)


class Song_Review(Base):
    __tablename__ = 'song_ratings'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    song_id = Column(String(255))
    reviewer_id = Column(String(255))
    rate = Column(Integer, default=1)


class Email_details(Base):
    __tablename__ = 'email_details'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    full_name = Column(String(255))
    email = Column(String(255), unique=True)
    user_role = Column(String(255), nullable=True)


class Contact(Base):
    __tablename__ = 'contact_details'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    name = Column(String(255))
    last_name = Column(String(255))
    email = Column(String(255))
    user_role = Column(String(255), nullable=True)
    message = Column(String(255), nullable=True)
    reply = Column(String(255), nullable=True)
    company_name = Column(String(255), nullable=True)
    number_of_employees = Column(String(255), nullable=True)


class Upload_User_Files(Base):
    __tablename__ = 'upload_user_files'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    user_id = Column(UUIDType, ForeignKey("user.id", ondelete="SET NULL"), nullable=False)
    filename = Column((String(255)), nullable=True)
    s3_file_url = Column(String(255))


class Songs(Base):
    __tablename__ = 'Songs'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    user_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    project_id = Column(UUIDType, ForeignKey("project.id", ondelete="cascade"), nullable=True)

    artist_title = Column((String(255)), nullable=True)
    music_title = Column((String(255)), nullable=True)
    genre = Column(String((255)), nullable=True)
    own_recording = Column((Boolean), nullable=True)

    parties = Column(JSONB, nullable=True)
    writers = Column(JSONB, nullable=True)
    publishers = Column(JSONB, nullable=True)

    origin_url = Column((String(255)), nullable=True)
    clean_url = Column((String(255)), nullable=True)
    instrumental_url = Column((String(255)), nullable=True)
    cover_photo = Column(String(255), nullable=True)

    writing_credits = Column(Integer, default=0)
    publisher_credits = Column(Integer, default=0)

    upload_date = Column(Date, nullable=True)
    spotify_id = Column((String(255)), nullable=True)
    spotify_artist_id = Column((String(255)), nullable=True)
    music_duration = Column((String(255)), nullable=True)
    bpm = Column((String(255)), nullable=True)
    status = Column(Integer, default=0)
    track_id = Column((String(255)), nullable=True)

    user = relationship("User_details", backref="songs", cascade="all, delete", passive_deletes=True)


class Projects(Base):
    __tablename__ = 'project'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    user_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    name = Column((String(255)), nullable=False)
    project_type_id = Column(UUIDType, ForeignKey("project_types.id", ondelete="SET NULL"), nullable=True)
    description = Column((String(255)), nullable=False)
    created_date = Column(DateTime, nullable=True)

    user = relationship("User_details", backref="projects", cascade="all, delete", passive_deletes=True)
    songs = relationship("Songs", backref="project", passive_deletes=True)


class Count_likes(Base):
    __tablename__ = 'count_likes'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    song_id = Column(UUIDType, ForeignKey("Songs.id", ondelete="cascade"), nullable=False)
    action = Column(JSONB, nullable=True)
    sync = Column(JSONB, nullable=True)

    songs = relationship("Songs", cascade="all, delete", passive_deletes=True)


class Feedback(Base):
    __tablename__ = 'feedback'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    user_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    easyto_understand = Column((String(255)), nullable=True)
    songs_satisfaction = Column((String(255)), nullable=True)
    easyto_navigate = Column((String(255)), nullable=True)
    licensing_effective = Column((String(255)), nullable=True)
    improve_ideas = Column((String(255)), nullable=True)

    users = relationship("User_details", cascade="all, delete", passive_deletes=True)


class Licence(Base):
    __tablename__ = 'licence'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    user_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    song_id = Column(UUIDType, ForeignKey("Songs.id", ondelete="cascade"), nullable=False)
    project_id = Column(UUIDType, ForeignKey("project.id", ondelete="cascade"), nullable=True)

    email = Column((String(255)), nullable=True)
    label = Column((String(255)), nullable=True)
    percentage = Column(Integer, default=0)
    writers = Column(JSONB, nullable=True)
    publishers = Column(JSONB, nullable=True)

    date = Column(Date, nullable=True)
    fee = Column(Integer, default=0)
    use = Column((String(255)), nullable=True)

    supervisor_invoice_info = Column(JSONB, nullable=True)

    step = Column(Integer, default=0)
    is_finished = Column(Boolean, default=False)
    licence_agreement = Column(Boolean, default=False)
    payment_status = Column(Boolean, default=False)
    status = Column(Integer, default=0)
    approved_date = Column(Date)

    users = relationship("User_details", cascade="all, delete", passive_deletes=True)
    songs = relationship("Songs", backref="licenses", passive_deletes=True)


class Notification(Base):
    __tablename__ = 'notification'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    user_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    song_id = Column(UUIDType, ForeignKey("Songs.id", ondelete="cascade"), nullable=False)
    artist_id = Column(UUIDType, nullable=True)
    music_title = Column((String(255)), nullable=True)
    track_id = Column((String(255)), nullable=True)
    date = Column(Date)
    status = Column(Integer, default=0)
    seen = Column(Integer, default=0)
    datetime = Column(DateTime)

    users = relationship("User_details", cascade="all, delete", passive_deletes=True)
    songs = relationship("Songs", cascade="all, delete", passive_deletes=True)


class Similar_track(Base):
    __tablename__ = 'similar_track'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    supervisor_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    search_artistid = Column((String(255)), nullable=False)
    search_artistname = Column((String(255)), nullable=True)
    search_trackid = Column((String(255)), nullable=False)
    search_trackname = Column((String(255)), nullable=True)
    similar_songs = Column(JSONB, nullable=True)
    date = Column(Date, nullable=False)

    users = relationship("User_details", cascade="all, delete", passive_deletes=True)


class Invoice(Base):
    __tablename__ = 'invoice'
    __table_args__ = {'extend_existing': True}
    id = Column(Integer, primary_key=True, autoincrement=True)
    supervisor_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    song_id = Column(UUIDType, ForeignKey("Songs.id", ondelete="cascade"), nullable=False)
    Licence_id = Column(UUIDType, ForeignKey("licence.id", ondelete="cascade"), nullable=False)
    date = Column(Date)

    users = relationship("User_details", cascade="all, delete", passive_deletes=True)
    songs = relationship("Songs", cascade="all, delete", passive_deletes=True)
    licence = relationship("Licence", cascade="all, delete", passive_deletes=True)


class Payment(Base):
    __tablename__ = 'payment'
    __table_args__ = {'extend_existing': True}
    id = Column(Integer, primary_key=True, autoincrement=True)
    supervisor_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    invoice_id = Column(Integer, ForeignKey("invoice.id", ondelete="cascade"), nullable=False)
    stripe_id = Column((String(255)), nullable=True)
    email = Column((String(255)), nullable=True)
    amount = Column((String(255)), nullable=True)
    date = Column(Date)
    status = Column((String(255)), nullable=True)
    amount_before_reduction = Column((String(255)), nullable=True)
    receipt_url = Column((String(500)), nullable=True)
    receipt_created_date = Column(DateTime, nullable=True)
    song_id = Column((String(255)), nullable=True)

    users = relationship("User_details", cascade="all, delete", passive_deletes=True)
    invoice = relationship("Invoice", cascade="all, delete", passive_deletes=True)


class My_Earnings(Base):
    __tablename__ = 'my_earnings'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    artist_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    invoice_id = Column(JSONB, nullable=True)
    artist_name = Column((String(255)), nullable=True)
    total_amount = Column((String(255)), nullable=True)
    balance_amount = Column((String(255)), nullable=True)
    withdraw_amount = Column((String(255)), nullable=True)
    invoice_number = Column(JSONB, nullable=True)
    date = Column(Date)

    users = relationship("User_details", cascade="all, delete", passive_deletes=True)


class Project_Types(Base):
    __tablename__ = 'project_types'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    name = Column((String(255)), nullable=True)
    cost = Column(Integer, default=0)


class Withdrawal(Base):
    __tablename__ = 'withdrawal'
    __table_args__ = {'extend_existing': True}
    id = Column(UUIDType, primary_key=True)
    artist_id = Column(UUIDType, ForeignKey("user.id", ondelete="cascade"), nullable=False)
    amount = Column((String(255)), nullable=True)
    date = Column(Date)
    status = Column(Integer, default=0)
    remarks = Column((String(255)), nullable=True)

    users = relationship("User_details", cascade="all, delete", passive_deletes=True)
