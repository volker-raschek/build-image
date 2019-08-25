# VERSION
# If no version is specified as a parameter of make, the value latest
# is taken.
VERSION:=$(or ${TRAVIS_TAG}, latest)

# DOCKER_USER
DOCKER_USER:=volkerraschek

image-build:
	docker build \
		--tag ${DOCKER_USER}/build-image:${VERSION} \
		.

image-push: image-build
	docker login --username ${DOCKER_USER} --password ${DOCKER_PASSWORD}
	docker push ${DOCKER_USER}/build-image:${VERSION}