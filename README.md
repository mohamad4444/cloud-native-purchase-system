# Cloud native Demo Project

# Technologies Used


# commands
dev:
	docker compose --env-file .env up -d --build

prod:
	docker compose --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d --build

stop:
	docker compose down
