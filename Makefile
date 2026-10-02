PSQL = docker compose exec -T db sh -c 'psql -U "$$POSTGRES_USER" -d "$$POSTGRES_DB" -v ON_ERROR_STOP=1 -q'

.PHONY: up down init bronze silver gold test all

up:
	docker compose up -d --wait

down:
	docker compose down

init:
	$(PSQL) < sql/00_init.sql



all: up init bronze silver gold test
