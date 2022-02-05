#!/bin/bash

DOCKER_IMAGE_NAME="dnsovertlsproxy"
DOCKER_INSTANCE_NAME="dotproxy1"

docker build -t ${DOCKER_IMAGE_NAME} .

docker run -d -p 5353:53 --name ${DOCKER_INSTANCE_NAME} ${DOCKER_IMAGE_NAME}

docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Image}}"

CONTAINER_ID=$(docker inspect --format="{{.Id}}" ${DOCKER_INSTANCE_NAME})
sudo tail -f  /var/lib/docker/containers/${CONTAINER_ID}/${CONTAINER_ID}-json.log | jq
