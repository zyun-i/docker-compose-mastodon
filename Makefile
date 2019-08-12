all: build

pull:
	docker-compose pull

build: pull
	docker-compose build

update:
	export DOCKER_CLIENT_TIMEOUT=120
	export COMPOSE_HTTP_TIMEOUT=120
	docker-compose stop web streaming sidekiq
	docker-compose rm -f -v web streaming sidekiq
	docker-compose run --rm web rails db:migrate
	docker-compose up -d web streaming sidekiq
	docker-compose run --rm web bin/tootctl cache clear
	docker-compose up -d --scale sidekiq=5

.PHONY: all pull build update
