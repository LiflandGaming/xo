REGISTRY ?= lifegaming
BINARY := xo
TAG ?= $(shell git describe --abbrev=0 --tags 2> /dev/null)
ifeq ($(TAG),)
    TAG = ""
endif


BASE_DOCKER_TAG := ${REGISTRY}/${BINARY}

DOCKER_TAG_LATEST := ${BASE_DOCKER_TAG}:latest
DOCKER_TAG := ${BASE_DOCKER_TAG}:${TAG}

build:
	if [ $(TAG) = "" ]; then \
		docker build --rm=true -t ${DOCKER_TAG_LATEST} -f Dockerfile . ; \
	else \
		docker build --rm=true -t ${DOCKER_TAG_LATEST} -t ${DOCKER_TAG} -f Dockerfile .; \
	fi \

push: build
	if [ $(TAG) = "" ]; then \
		docker push ${DOCKER_TAG_LATEST}; \
	else \
		docker push ${DOCKER_TAG}; docker push ${DOCKER_TAG_LATEST}; \
	fi \
