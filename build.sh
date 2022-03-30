#!/bin/bash

VERSION=2.1.1
DOCKERHUB=docker.io/distrolessdocker/distroless-influxdb

docker buildx build --build-arg VERSION=$VERSION --platform linux/amd64 --build-arg ARCH=amd64 -t $DOCKERHUB:amd64-$VERSION .
docker buildx build --build-arg VERSION=$VERSION --platform linux/arm64/v8 --build-arg ARCH=arm64 -t $DOCKERHUB:arm64-$VERSION .
docker push $DOCKERHUB:amd64-$VERSION
docker push $DOCKERHUB:arm64-$VERSION
docker rmi $DOCKERHUB:amd64-$VERSION
docker rmi $DOCKERHUB:arm64-$VERSION

DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create --amend $DOCKERHUB:$VERSION $DOCKERHUB:amd64-$VERSION $DOCKERHUB:arm64-$VERSION

DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate $DOCKERHUB:$VERSION $DOCKERHUB:amd64-$VERSION --os linux --arch amd64
DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate $DOCKERHUB:$VERSION $DOCKERHUB:arm64-$VERSION --os linux --arch arm64 --variant v8
DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push $DOCKERHUB:$VERSION