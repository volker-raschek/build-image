# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to start and run a container image.
CONTAINER_RUNTIME?=$(shell which podman)

# BASE_IMAGE
# Defines the name of the container base image on which should be built the new
# CONTAINER_IMAGE.
BASE_IMAGE_REGISTRY_HOST:=docker.io
BASE_IMAGE_NAMESPACE:=archlinux
BASE_IMAGE_REPOSITORY:=base
BASE_IMAGE_VERSION:=latest
BASE_IMAGE_FULLY_QUALIFIED=${BASE_IMAGE_REGISTRY_HOST}/${BASE_IMAGE_NAMESPACE}/${BASE_IMAGE_REPOSITORY}:${BASE_IMAGE_VERSION}

# CONTAINER_IMAGE
# Defines the name of the new container to be built using several variables.
CONTAINER_IMAGE_REGISTRY_HOST:=docker.io
CONTAINER_IMAGE_REGISTRY_USER:=volkerraschek
CONTAINER_IMAGE_NAMESPACE?=${CONTAINER_IMAGE_REGISTRY_USER}
CONTAINER_IMAGE_REPOSITORY:=build-image
CONTAINER_IMAGE_VERSION?=latest
CONTAINER_IMAGE_FULLY_QUALIFIED=${CONTAINER_IMAGE_REGISTRY_HOST}/${CONTAINER_IMAGE_NAMESPACE}/${CONTAINER_IMAGE_REPOSITORY}:${CONTAINER_IMAGE_VERSION}
CONTAINER_IMAGE_UNQUALIFIED=${CONTAINER_IMAGE_NAMESPACE}/${CONTAINER_IMAGE_REPOSITORY}:${CONTAINER_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--build-arg BASE_IMAGE=${BASE_IMAGE_FULLY_QUALIFIED} \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${CONTAINER_IMAGE_FULLY_QUALIFIED} \
		--tag ${CONTAINER_IMAGE_UNQUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${CONTAINER_RUNTIME} image rm ${CONTAINER_IMAGE_FULLY_QUALIFIED} ${CONTAINER_IMAGE_UNQUALIFIED}
	- ${CONTAINER_RUNTIME} image rm ${BASE_IMAGE_FULLY_QUALIFIED}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	${CONTAINER_RUNTIME} login ${CONTAINER_IMAGE_REGISTRY_HOST} --username ${CONTAINER_IMAGE_REGISTRY_USER} --password ${CONTAINER_IMAGE_REGISTRY_PASSWORD}
	${CONTAINER_RUNTIME} push ${CONTAINER_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}
