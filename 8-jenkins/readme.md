# install jenkins from jenkins.io

## Create a bridge network in Docker

```bash
docker network create jenkins
```

## Run a docker:dind Docker image

```bash
docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2
```

## Create Dockerfile with the following content:

[Dockerfile](Dockerfile)

## Build a new docker image from this Dockerfile and assign the image a meaningful name, e.g. "myjenkins-blueocean:2.319.3-1":

```bash
docker build -t myjenkins-blueocean:2.319.3-1 .
```