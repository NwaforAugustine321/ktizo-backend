from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

from config.config import settings
from typing import Generator

from db.prestart import wait_for_db



SQLALCHEMY_DATABASE_URL = settings.DATABASE_URL

engine = wait_for_db(SQLALCHEMY_DATABASE_URL)

engine = create_engine(SQLALCHEMY_DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db() -> Generator:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def test_db_connection():
    wait_for_db(SQLALCHEMY_DATABASE_URL)
