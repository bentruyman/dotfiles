default: build

build:
	docker build -t bentruyman/dotfiles .

debug: build
	docker run -it --rm bentruyman/dotfiles bash

test: build
