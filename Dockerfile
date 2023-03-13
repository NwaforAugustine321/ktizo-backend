FROM python:3.10-slim-buster

# This prevents Python from writing out pyc files
ENV PYTHONDONTWRITEBYTECODE 1
# This keeps Python from buffering stdin/stdout
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip
RUN pip install --upgrade pipenv

RUN apt-get update && apt-get install gcc libpq-dev python-dev -y

RUN rm -rf /var/cache/apt/archives

ENV APP_ROOT=/app
RUN mkdir -p ${APP_ROOT}
WORKDIR ${APP_ROOT}



COPY Pipfile Pipfile.lock ./

RUN pipenv  --clear install --system --deploy --ignore-pipfile
# RUN pipenv --three  --clear install
COPY . ${APP_ROOT}

EXPOSE 8000
CMD ["pipenv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
