# Ktizo backend API

---

Python 3.10

## Getting started

1. Create local `Website-Back-End/.env` file from the corresponding files in example folder `Website-Back-End/example.env/` and populate the required fields.
2. Make sure you have [Docker](https://docs.docker.com/) installed locally.
3. Run `make up` to start the Docker containers and the server on http://localhost:8000.
4. Run `make migrate` to aply the database migrations.
5. Visit http://localhost:8000/docs in your browser.


Set up procedure for your local machine:


Steps to install project
1. pip install fastapi
2. pip install uvicorn
3. Install all other packages mentioned in the pip file. It can be done using pipenv install
4. Command for running project:  uvicorn main:app --reload


Database setup locally:
1. Install pgadmin for postgres database
2. Create a new server with server name “localhost” and port 5432
3. In that, create a new database with any name
4. In config.py file, add all the database requirements


Command for database migration:
1.  alembic revision --autogenerate -m “first migration”
2. alembic upgrade head


And also please watch this youtube video,
https://www.youtube.com/watch?v=GN6ICac3OXY







