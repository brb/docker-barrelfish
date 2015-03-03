DOCKER ?= docker
IMAGE_NAME ?= barrelfish
MAINTAINER ?= brb0
CONTAINER_NAME ?= barrelfish

.PHONY: build pull create start

build: Dockerfile
	$(DOCKER) build -t $(IMAGE_NAME) .

pull:
	$(DOCKER) pull $(MAINTAINER)/$(IMAGE_NAME)
	$(DOCKER) tag $(MAINTAINER)/$(IMAGE_NAME) $(IMAGE_NAME)

create:
ifneq ($(and $(BUILD_PATH),$(SRC_PATH)),)
	$(DOCKER) create -v $(SRC_PATH):/barrelfish_src \
					 -v $(BUILD_PATH):/barrelfish_build \
					 -it \
					 --name $(CONTAINER_NAME) \
					 $(IMAGE_NAME)
else
	$(error Usage "make create SRC_PATH=... BUILD_PATH=... [CONTAINER_NAME=barrelfish]")
endif

start:
	$(DOCKER) start -ai $(CONTAINER_NAME)
