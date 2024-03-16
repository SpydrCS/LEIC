#!/bin/bash

# Stop execution if a step fails
set -e

IMAGE_NAME=git.fe.up.pt:5050/lbaw/lbaw2223/lbaw22116 # Replace with your group's image name

# Ensure that dependencies are available
composer install
php artisan config:clear
php artisan clear-compiled
php artisan optimize

# docker buildx build --push --platform linux/amd64 -t $IMAGE_NAME .
docker build -t $IMAGE_NAME .
docker push $IMAGE_NAME

#docker run -it -p 8000:80 --name=lbaw22116_2 -e DB_DATABASE="lbaw22116" -e DB_SCHEMA="lbaw" -e DB_USERNAME="lbaw22116" -e DB_PASSWORD="KADfCGgs" git.fe.up.pt:5050/lbaw/lbaw2223/lbaw22116