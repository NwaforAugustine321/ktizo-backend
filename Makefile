.PHONY : up

validate:
	docker-compose config

up:
	docker-compose up -d

up_clean: up
	docker-compose up --build -d

build:
	docker-compose build

down:
	docker-compose down

down_clean:
	-docker-compose down
	-docker network rm website-back-end_default
	-docker volume rm ktizo_postgres_data

restart :
	docker-compose restart


# Postgres
# makemigrations:
# 	docker-compose exec backend python manage.py makemigrations

migrate:
	docker-compose exec backend alembic upgrade head
