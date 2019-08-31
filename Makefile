REPO_USER = bentruyman
REPO_NAME = dotfiles

default: build

build:
	docker build -t ${REPO_USER}/${REPO_NAME} .

debug:
	docker build --build-arg BOOTSTRAP_FLAGS="" -t ${REPO_USER}/${REPO_NAME}-debug .
	docker run -it --rm -v $(PWD):/home/test-user/dotfiles ${REPO_USER}/${REPO_NAME}-debug bash

push:
	echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
	docker push ${REPO_USER}/${REPO_NAME}

test: build
