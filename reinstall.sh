#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y

docker-compose stop
docker system prune -a -f
docker-compose up -d
