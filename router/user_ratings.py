import schemas
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
import uuid

app = APIRouter()


# To rate a user
@app.post('/user_review/', tags=["ratings"])
def create_user_review(user_review: schemas.user_rate, db: Session = Depends(get_db)):
    StarRating = db.query(models.User_Review).filter(models.User_Review.reviewer_id == user_review.reviewer_id).first()
    if StarRating is None:
        new_rating = models.User_Review(
            id=uuid.uuid4(),
            reviewee_id=user_review.reviewee_id,
            reviewer_id=user_review.reviewer_id,
            rate=user_review.rate
        )
        db.add(new_rating)

        db.commit()

        StarRating = db.query(models.User_Review).filter(
            models.User_Review.reviewer_id == user_review.reviewer_id).first()

        return {"response": StarRating}
    else:
        return {"response": "you are aleady rated"}


# To get average rate of a user
@app.post('/average_user_rating', tags=["ratings"])
def average_user_review(review: schemas.user_rate, db: Session = Depends(get_db)):
    ratings = db.query(models.User_Review.rate).filter(models.User_Review.reviewee_id == review.reviewee_id).all()
    if ratings:
        total_user_rate = [sum(rate) for rate in ratings]
        total_count_rate = [len(rate) for rate in ratings]
        average = 0 if len(total_user_rate) == 0 else (float(sum(total_user_rate)) / len(total_count_rate))
        return {"average": average, "response": ratings}
    else:
        return {"response": "Invalid id"}
