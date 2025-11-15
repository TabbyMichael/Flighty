.PHONY: install run test coverage dev docker-up docker-down docker-logs migrate upgrade downgrade init-db

install:
	pip install -r requirements.txt
	pip install -r requirements-dev.txt

run:
	uvicorn app.main:app --reload

test:
	pytest

coverage:
	pytest --cov=app --cov-report=html

dev:
	uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-logs:
	docker-compose logs -f

migrate:
	alembic revision --autogenerate -m "Auto migration"

upgrade:
	alembic upgrade head

downgrade:
	alembic downgrade -1

init-db:
	python init_db.py

lint:
	flake8 app
	black --check app
	mypy app