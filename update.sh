#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y

docker-compose pull
docker-compose down
docker-compose up -d
