#!/bin/bash
source /etc/profile.d/env_docker
docker-compose stop \
	&& docker-compose build \
	&& docker-compose up &
