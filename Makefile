# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to start and run a container image.
CONTAINER_RUNTIME?=$(shell which podman)

# CONTAINER_IMAGE
# Defines the name of the new container to be built using several variables.
BUILD_IMAGE_REGISTRY_HOST:=docker.io
BUILD_IMAGE_REGISTRY_USER:=volkerraschek
BUILD_IMAGE_NAMESPACE?=${BUILD_IMAGE_REGISTRY_USER}
BUILD_IMAGE_REPOSITORY:=build-image
BUILD_IMAGE_VERSION?=latest
BUILD_IMAGE_FULLY_QUALIFIED=${BUILD_IMAGE_REGISTRY_HOST}/${BUILD_IMAGE_NAMESPACE}/${BUILD_IMAGE_REPOSITORY}:${BUILD_IMAGE_VERSION}
BUILD_IMAGE_UNQUALIFIED=${BUILD_IMAGE_NAMESPACE}/${BUILD_IMAGE_REPOSITORY}:${BUILD_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${BUILD_IMAGE_FULLY_QUALIFIED} \
		--tag ${BUILD_IMAGE_UNQUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${CONTAINER_RUNTIME} image rm ${BUILD_IMAGE_FULLY_QUALIFIED} ${BUILD_IMAGE_UNQUALIFIED}
	- ${CONTAINER_RUNTIME} image rm ${BASE_IMAGE_FULLY_QUALIFIED}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${BUILD_IMAGE_REGISTRY_PASSWORD} | ${CONTAINER_RUNTIME} login ${BUILD_IMAGE_REGISTRY_HOST} --username ${BUILD_IMAGE_REGISTRY_USER} --password-stdin
	${CONTAINER_RUNTIME} push ${BUILD_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}
