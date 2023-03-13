import schemas
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from db import models
from db.database import get_db
import uuid
from auth.jwt_bearer import JWTBearer

app = APIRouter()


# To rate a song
@app.post('/song_review/', tags=["songs"], dependencies=[Depends(JWTBearer())])
def create_song_review(review: schemas.song_rate, db: Session = Depends(get_db)):
    StarRating = db.query(models.Song_Review).filter(models.Song_Review.reviewer_id == review.reviewer_id).first()
    if StarRating is None:
        new_rating = models.Song_Review(
            id=uuid.uuid4(),
            song_id=review.song_id,
            reviewer_id=review.reviewer_id,
            rate=review.rate,
        )
        db.add(new_rating)

        db.commit()
        StarRating = db.query(models.Song_Review).filter(models.Song_Review.reviewer_id == review.reviewer_id).first()

        return {"response": StarRating}
    else:
        return {"response": "you aleady rated"}


# To get average rate of a user
@app.post('/average_song_rate/', tags=["songs"], dependencies=[Depends(JWTBearer())])
def average_song_ratings(user_review: schemas.song_rate, db: Session = Depends(get_db)):
    ratings = db.query(models.Song_Review.rate).filter(models.Song_Review.song_id == user_review.song_id).all()
    if ratings:
        total_song_rate = [sum(rate) for rate in ratings]
        count_song_rate = [len(rate) for rate in ratings]
        average = 0 if len(total_song_rate) == 0 else (float(sum(total_song_rate)) / len(count_song_rate))
        return {"average": average, "response": ratings}
    else:
        return {"response": "invalid song id"}
