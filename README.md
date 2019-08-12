# docker compose mastodon

1. Build docker image.
1. up -d

```sh
docker build . -t mastodon
```

```sh
cp .env.postgres.sample .env.production.postgres
docker-compose up -d
docker-compose up -d --scale sidekiq=5
docker-compose run --rm web bundle exec bin/tootctl search deploy
```

```sh
make update
```
