# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to start and run a container image.
CONTAINER_RUNTIME?=$(shell which docker)

# BASE_IMAGE
# Defines the name of the container base image on which should be built the new
# CONTAINER_IMAGE.
BASE_IMAGE_REGISTRY_NAME:=docker.io
BASE_IMAGE_NAMESPACE:=archlinux
BASE_IMAGE_NAME:=base
BASE_IMAGE_VERSION:=latest
BASE_IMAGE_FULL=${BASE_IMAGE_REGISTRY_NAME}/${BASE_IMAGE_NAMESPACE}/${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION}
BASE_IMAGE_SHORT=${BASE_IMAGE_NAMESPACE}/${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION}

# CONTAINER_IMAGE_REGISTRY_NAME
# Defines the name of the new container to be built using several variables.
CONTAINER_IMAGE_REGISTRY_NAME:=docker.io
CONTAINER_IMAGE_REGISTRY_USER:=volkerraschek

CONTAINER_IMAGE_NAMESPACE?=${CONTAINER_IMAGE_REGISTRY_USER}
CONTAINER_IMAGE_NAME:=build-image
CONTAINER_IMAGE_VERSION?=latest
CONTAINER_IMAGE_FULL=${CONTAINER_IMAGE_REGISTRY_NAME}/${CONTAINER_IMAGE_NAMESPACE}/${CONTAINER_IMAGE_NAME}:${CONTAINER_IMAGE_VERSION}
CONTAINER_IMAGE_SHORT=${CONTAINER_IMAGE_NAMESPACE}/${CONTAINER_IMAGE_NAME}:${CONTAINER_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--build-arg BASE_IMAGE=${BASE_IMAGE_FULL} \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${CONTAINER_IMAGE_FULL} \
		--tag ${CONTAINER_IMAGE_SHORT} \
		.

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${CONTAINER_IMAGE_REGISTRY_PASSWORD} | ${CONTAINER_RUNTIME} login ${CONTAINER_IMAGE_REGISTRY_NAME} --username ${CONTAINER_IMAGE_REGISTRY_USER} --password-stdin
	${CONTAINER_RUNTIME} push ${CONTAINER_IMAGE_FULL}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}