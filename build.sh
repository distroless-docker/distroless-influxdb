VERSION=1.8.5
DOCKERHUB=docker.io/distroless/distroless-influxdb

docker build --build-arg VERSION=$VERSION --build-arg ARCH=amd64 --build-arg STATIC=-static -t $DOCKERHUB:amd64-$VERSION .
docker build --build-arg VERSION=$VERSION --build-arg ARCH=armhf --build-arg STATIC= -t $DOCKERHUB:armhf-$VERSION .
docker build --build-arg VERSION=$VERSION --build-arg ARCH=armhf --build-arg STATIC= -t $DOCKERHUB:arm64-$VERSION .
docker push $DOCKERHUB:amd64-$VERSION
docker push $DOCKERHUB:armhf-$VERSION
docker push $DOCKERHUB:arm64-$VERSION
docker rmi $DOCKERHUB:amd64-$VERSION
docker rmi $DOCKERHUB:armhf-$VERSION
docker rmi $DOCKERHUB:arm64-$VERSION

DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create --amend $DOCKERHUB:$VERSION $DOCKERHUB:amd64-$VERSION $DOCKERHUB:armhf-$VERSION $DOCKERHUB:arm64-$VERSION

DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate $DOCKERHUB:$VERSION $DOCKERHUB:amd64-$VERSION --os linux --arch amd64
DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate $DOCKERHUB:$VERSION $DOCKERHUB:armhf-$VERSION --os linux --arch arm --variant v7
DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate $DOCKERHUB:$VERSION $DOCKERHUB:armhf-$VERSION --os linux --arch arm64 --variant v8
DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push $DOCKERHUB:$VERSION