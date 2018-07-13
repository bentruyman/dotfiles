REPO_USER = bentruyman
REPO_NAME = dotfiles

default: build

build:
	docker build -t ${REPO_USER}/${REPO_NAME} .

debug: build
	docker run -it --rm ${REPO_USER}/${REPO_NAME} bash

push:
	echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
	docker push ${REPO_USER}/${REPO_NAME}

test: build
