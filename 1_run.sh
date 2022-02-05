#!/bin/bash

DOCKER_IMAGE_NAME="dnsovertlsproxy"
DOCKER_INSTANCE_NAME="dotproxy1"

docker build -t ${DOCKER_IMAGE_NAME} .

docker run -d -p 5353:53 --name ${DOCKER_INSTANCE_NAME} ${DOCKER_IMAGE_NAME}

docker logs -f ${DOCKER_INSTANCE_NAME}
