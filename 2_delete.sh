#!/bin/bash

DOCKER_IMAGE_NAME="dnsovertlsproxy"
DOCKER_INSTANCE_NAME="dotproxy1"

docker stop ${DOCKER_INSTANCE_NAME} 

docker rm -f ${DOCKER_INSTANCE_NAME} 

docker rmi ${DOCKER_IMAGE_NAME}

docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Image}}"
