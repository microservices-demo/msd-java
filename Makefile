BUILD_VERSION := 0.0.2-SNAPSHOT
BUILD_DATE := $(shell date +%Y-%m-%dT%T%z)
TRAVIS_COMMIT ?= $(shell git rev-parse @)
IMAGE_ORG ?= weaveworksdemos

export BUILD_VERSION BUILD_DATE IMAGE_ORG
export TRAVIS_COMMIT TRAVIS_BRANCH TRAVIS_TAG TRAVIS_PULL_REQUEST

build: Boxfile
	@docker run --rm \
	  --env BUILD_DATE \
	  --env BUILD_VERSION \
	  --env IMAGE_ORG \
	  --env TRAVIS_COMMIT \
	  --env TRAVIS_BRANCH \
	  --env TRAVIS_TAG \
	  --env TRAVIS_PULL_REQUEST \
	  --volume $(PWD):$(PWD) \
	  --volume /var/run/docker.sock:/var/run/docker.sock \
	  --workdir $(PWD) \
	    boxbuilder/box:0.5.7 Boxfile

push:
	@./scripts/push.sh
