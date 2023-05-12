all:
	docker compose -f ./srcs/docker-compose.yml build
up:
	docker compose -f ./srcs/docker-compose.yml up
down:
	docker compose -f ./srcs/docker-compose.yml down
fclean:
	docker rm -f $(docker ps -qa) && \
	docker volume rm $(docker volume ls -q) && \
	rm -rf /home/akhouya/data/mysql/* && \
	rm -rf /home/akhouya/data/wordpress/*
