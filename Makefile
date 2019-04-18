# VERSION
# If no version is specified as a parameter of make, the value latest
# is taken.
VERSION?=latest

# DOCKER_USER
DOCKER_USER:=volkerraschek

build:
	docker build \
		--no-cache \
		--tag ${DOCKER_USER}/build-image:${VERSION} \
		.

push: build
	docker login --username ${DOCKER_USER} --password ${DOCKER_PASSWORD}
	docker push ${DOCKER_USER}/build-image:${VERSION}