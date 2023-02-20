#!/bin/bash
yum update
yum upgrade -y

docker-compose stop
docker-compose down

docker-compose pull
docker-compose build
docker-compose up -d
