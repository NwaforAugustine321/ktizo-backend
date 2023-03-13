import os


class Settings:
    PROJECT_TITLE: str = os.getenv('PROJECT_TITLE')
    PROJECT_VERSION: str = os.getenv('PROJECT_VERSION')
    POSTGRES_USER: str = os.getenv('POSTGRES_USER')
    POSTGRES_PASSWORD: str = os.getenv('POSTGRES_PASSWORD')
    POSTGRES_SERVER: str = os.getenv('POSTGRES_SERVER')
    POSTGRES_PORT: str = os.getenv('POSTGRES_PORT')
    POSTGRES_DB: str = os.getenv('POSTGRES_DB')
    DATABASE_URL = f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_SERVER}:{POSTGRES_PORT}/{POSTGRES_DB}"
    ALGORITHM = os.getenv('ALGORITHM')
    SECRET_KEY: str = os.getenv('SECRET_KEY')
    AWS_ACCESS_KEY = os.getenv('AWS_ACCESS_KEY')
    AWS_SECRET_KEY = os.getenv('AWS_SECRET_KEY')
    S3_BUCKET_NAME = os.getenv('S3_BUCKET_NAME')
    S3_URL = os.getenv('S3_URL')
    STRIPE_SECRET_KEY = os.getenv('STRIPE_SECRET_KEY')
    WEBHOOK_SECRET_KEY = os.getenv('WEBHOOK_SECRET_KEY')
    AI_URL = os.getenv('AI_URL')
    AI_CLIENT_TOKEN = os.getenv('AI_CLIENT_TOKEN')
    SPOTIFY_CLIENT_ID = os.getenv('SPOTIFY_CLIENT_ID')
    SPOTIFY_CLIENT_SECRET = os.getenv('SPOTIFY_CLIENT_SECRET')
    SPOTIFY_URI = os.getenv('SPOTIFY_URI')
    DEFAULT_USER_PASSWORD = os.getenv('DEFAULT_USER_PASSWORD')


settings = Settings()
