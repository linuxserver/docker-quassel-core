NAME=k8r.eu/justjanne/quassel-docker
QUASSEL_VERSION=v0.13.1
ALPINE_VERSION=3.9

.PHONY: all
all: push

.PHONY: build
build: build_x86 build_aarch64 build_armhf

.PHONY: build_x86
build_x86: Dockerfile
	docker build -t $(NAME):$(QUASSEL_VERSION) --build-arg BASE=alpine:$(ALPINE_VERSION) .
	docker tag $(NAME):$(QUASSEL_VERSION) $(NAME):latest

.PHONY: build_aarch64
build_aarch64: Dockerfile
	docker build -t $(NAME):$(QUASSEL_VERSION)-aarch64 --build-arg BASE=multiarch/alpine:aarch64-v$(ALPINE_VERSION) .
	docker tag $(NAME):$(QUASSEL_VERSION)-aarch64 $(NAME):aarch64

.PHONY: build_armhf
build_armhf: Dockerfile
	docker build -t $(NAME):$(QUASSEL_VERSION)-armhf --build-arg BASE=multiarch/alpine:armhf-v$(ALPINE_VERSION) .
	docker tag $(NAME):$(QUASSEL_VERSION)-armhf $(NAME):armhf

.PHONY: push
push: push_x86 push_aarch64 push_armhf

.PHONY: push_x86
push_x86: build_x86
	docker push $(NAME):$(QUASSEL_VERSION)
	docker push $(NAME):latest

.PHONY: push_aarch64
push_aarch64: build_aarch64
	docker push $(NAME):$(QUASSEL_VERSION)-aarch64
	docker push $(NAME):aarch64

.PHONY: push_armhf
push_armhf: build_armhf
	docker push $(NAME):$(QUASSEL_VERSION)-armhf
	docker push $(NAME):armhf
