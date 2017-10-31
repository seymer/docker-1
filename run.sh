#!/bin/bash
source variables.env;rm -rf docker-compose.yml; envsubst < "template.yml" > "docker-compose.yml";
docker-compose stop \
	&& docker-compose build \
	&& docker-compose up &
