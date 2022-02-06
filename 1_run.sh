#!/bin/bash

DOCKER_IMAGE_NAME="dnsovertlsproxy"
DOCKER_INSTANCE_NAME="dotproxy1"

docker build -t ${DOCKER_IMAGE_NAME} dot/.

docker run -d -p 5353:53 --name ${DOCKER_INSTANCE_NAME} ${DOCKER_IMAGE_NAME}

echo ""
echo "=> Docker instance created."
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Image}}"
echo ""
echo "=> To show stdout logs run next command: "
printf "\t docker logs -f ${DOCKER_INSTANCE_NAME}\n"
echo ""
