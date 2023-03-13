import time
import jwt
from config.config import settings

secret = settings.SECRET_KEY
algorithm = settings.ALGORITHM


def token_response(token: str):
    return {
        "access token": token
    }


def signJWT(userID: str):
    payload = {
        "userID": userID,
        "expiry": time.time() + 604800

    }
    token = jwt.encode(payload, secret, algorithm)
    return token_response(token)


def decodeJWT(token: str):
    try:
        decode_token = jwt.decode(token, secret, algorithm)
        return decode_token if decode_token['expiry'] >= time.time() else None
    except:
        return {}
