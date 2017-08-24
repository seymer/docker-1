#!/bin/bash
source variables.env;rm -rf docker-compose-bio.yml; envsubst < "template-bio.yml" > "docker-compose-bio.yml";
docker-compose stop \
	&& docker-compose -f docker-compose-bio.yml build \
	&& docker-compose -f docker-compose-bio.yml up &
