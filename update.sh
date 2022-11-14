#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y

docker pull n8nio/n8n
sudo docker-compose stop
sudo docker-compose rm -y
sudo docker-compose up -d
