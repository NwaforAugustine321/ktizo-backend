from typing import List
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig, MessageType

conf = ConnectionConfig(
    MAIL_USERNAME="launch@ktizo.io",
    MAIL_PASSWORD="iamavuvsydnsqtty",
    MAIL_FROM="launch@ktizo.io",
    MAIL_PORT=587,
    MAIL_SERVER="smtp.gmail.com",
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True,
    VALIDATE_CERTS=True
)


async def send_email(recipient: List, subject: str, message: str):
    message = MessageSchema(
        subject=subject,
        recipients=recipient,  # List of recipients, as many as you can pass
        body=message,
        subtype=MessageType.html
    )
    fm = FastMail(conf)
    await fm.send_message(message)
    return {"message": "email has been sent"}
