from sqlalchemy import Integer
import uuid
import logging
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from db.database import get_db
from db import models
from sqlalchemy.sql import func, extract
from sqlalchemy import cast
from auth.jwt_bearer import JWTBearer

app = APIRouter()


# get total amount earned by a user in artist role
@app.get("/get_earnings/{artist_id}", tags=["earnings"], dependencies=[Depends(JWTBearer())])
def get_earnings(artist_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        earnings = db.query(models.My_Earnings.artist_id,
                            func.sum(cast(models.My_Earnings.total_amount, Integer)).label("total_amount")
                            ).filter(models.My_Earnings.artist_id == artist_id).group_by(
            models.My_Earnings.artist_id).all()

        withdraw = db.query(models.Withdrawal.artist_id,
                            func.sum(cast(models.Withdrawal.amount, Integer)).label("withdraw_amount")
                            ).filter(models.Withdrawal.artist_id == artist_id).group_by(
            models.Withdrawal.artist_id).all()

        if earnings:
            total_earnings = earnings[0].total_amount
        else:
            total_earnings = 0
        if withdraw:
            total_withdraw = withdraw[0].withdraw_amount
        else:
            total_withdraw = 0
        balance = total_earnings - total_withdraw
        response = {"artist_id": artist_id,
                    "total_amount": earnings[0].total_amount if earnings else 0,
                    "withdraw_amount": withdraw[0].withdraw_amount if withdraw else 0,
                    "balance": balance}
        return response
    except:
        logging.error("Exception occurred. Unable to get earnings", exc_info=True)


# to get the ernings of an artist month wise
@app.get("/get_earnings_graph", tags=["earnings"], dependencies=[Depends(JWTBearer())])
def get_earnings(artist_id: uuid.UUID, db: Session = Depends(get_db)):
    try:
        earnings = db.query(func.sum(cast(models.My_Earnings.total_amount, Integer)).label("total_amount"),
                            extract('month', models.My_Earnings.date).label("month")
                            ).filter(models.My_Earnings.artist_id == artist_id).group_by(
            extract('month', models.My_Earnings.date)).all()
        month_data = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        for earning in earnings:
            value = int(earning.month) - 1
            month_data[value] = earning.total_amount
        withdraw = db.query(func.sum(cast(models.Withdrawal.amount, Integer)).label("withdraw_amount"),
                            extract('month', models.Withdrawal.date).label("month")
                            ).filter(models.Withdrawal.artist_id == artist_id).group_by(
            extract('month', models.Withdrawal.date)).all()
        withdraw_data = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        for withdrawal in withdraw:
            value = int(withdrawal.month) - 1
            withdraw_data[value] = withdrawal.withdraw_amount
        return {"status": "success", "response": {"total_amount": month_data, "withdraw_amount": withdraw_data}}
    except:
        logging.error("Exception occurred. Unable to get earnings", exc_info=True)
