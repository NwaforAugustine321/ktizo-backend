from config.config import settings
from fastapi import FastAPI
from router import (register_login, song_clearence, spotify, user_ratings, song_ratings, register, contact,
                    upload_files, user_account, songs, search_artist, licence, notification,
                    similar_tracks, sync_songs, invoice, payment, earnings, projects, ai_syncable)

from fastapi.middleware.cors import CORSMiddleware

desc = """
This project is MVP of a Music application

The backend was created to show the capabilities of the connected AI that allows you to find matches in tracks 
and also license tracks for further use

However, the architecture and code quality in the project leaves much to be desired. 
For further improvements and new releases, I recommend:
- develop a new database architecture
- create from scratch or deeply refactor the normal architecture of this app, using this 
    best practices - https://fastapi.tiangolo.com/tutorial/, according to all changes in design
- the main issue is the security of data and the licensing process itself, which is completely absent
- replacement or refinement of all endpoints with the addition of pagination, caching, restricted access and security
"""

tags_metadata = [
    {"name": "auth", "description": "User SignIn/SignUp Methods"},
    {"name": "users", "description": "User Account CRUD Methods"},
    {"name": "projects", "description": "Project CRUD Methods"},
    {"name": "songs", "description": "Songs CRUD Methods"},
    {"name": "licence", "description": "Licence CRUD Methods"},
    {"name": "earnings", "description": "Earnings statistics and chart Methods"},
    {"name": "ratings", "description": "User Rate Methods"},
    {"name": "payments", "description": "Payment Methods"},
    {"name": "uploads", "description": "Upload Files Methods"},
    {"name": "notification", "description": "Notification Methods"},
]

app = FastAPI(
    title=settings.PROJECT_TITLE,
    version=settings.PROJECT_VERSION,
    description=desc,
    openapi_tags=tags_metadata,
    redoc_url=None,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(register_login.app)
app.include_router(spotify.app)
app.include_router(user_ratings.app)
app.include_router(song_ratings.app)
app.include_router(register.app)
app.include_router(contact.app)
app.include_router(upload_files.app)
app.include_router(user_account.app)
app.include_router(songs.app)
app.include_router(search_artist.app)
app.include_router(licence.app)
app.include_router(song_clearence.app)
app.include_router(notification.app)
app.include_router(similar_tracks.app)
app.include_router(sync_songs.app)
app.include_router(invoice.app)
app.include_router(payment.app)
app.include_router(earnings.app)
app.include_router(projects.app)
app.include_router(ai_syncable.app)
