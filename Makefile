# CONTAINER_IMAGE_VERSION
# Defines the version of the container image which has included the executable
# binary. This is somethimes different to the variable CONTAINER_IMAGE_VERSION, because the
# container image version should be latest instead contains the latest git tag
# and hash sum.
CONTAINER_IMAGE_VERSION:=$(or ${TRAVIS_TAG}, latest)

# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to build the container image.
CONTAINER_RUNTIME:=$(shell which docker)

# DOCKER_USER
# It's the username from hub.docker.io. The name in addition with the password
# is necessary to upload the container image.
DOCKER_USER:=volkerraschek

# IMAGE_NAME
# The name of the container image.
IMAGE_NAME:=build-image


# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=build
build:
	${CONTAINER_RUNTIME} build \
		--file Dockerfile \
		--no-cache \
		--tag ${DOCKER_USER}/${IMAGE_NAME}:${CONTAINER_IMAGE_VERSION} \
		.

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=push
push: build
	${CONTAINER_RUNTIME} login docker.io --username ${DOCKER_USER} --password ${DOCKER_PASSWORD}
	${CONTAINER_RUNTIME} push ${DOCKER_USER}/${IMAGE_NAME}:${CONTAINER_IMAGE_VERSION}

# UPDATE HUB.DOCKER.IO README
# ==============================================================================
PHONY+=update/readme
update/readme:
	${CONTAINER_RUNTIME} run \
		--rm \
		--env DOCKERHUB_USERNAME=${DOCKER_USER} \
		--env DOCKERHUB_PASSWORD=${DOCKER_PASSWORD} \
		--env DOCKERHUB_REPOSITORY=${DOCKER_USER}/${IMAGE_NAME} \
		--env README_FILEPATH=./README.md \
		--volume $(shell pwd):/workspace:ro \
		--workdir=/workspace \
		peterevans/dockerhub-description:latest

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}