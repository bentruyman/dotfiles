FROM ubuntu:bionic
LABEL maintainer="Ben Truyman <ben@truyman.com>"

ARG BOOTSTRAP_FLAGS=--with-system
ENV BOOTSTRAP_FLAGS $BOOTSTRAP_FLAGS

RUN apt-get update \
 && apt-get install -y --no-install-recommends locales sudo \
 && rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
 && useradd -m -s /bin/bash test-user \
 && echo 'test-user ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER test-user
ENV USER=test-user

ADD --chown=test-user . /home/test-user/dotfiles

RUN bash -c "/home/test-user/dotfiles/bootstrap.sh ${BOOTSTRAP_FLAGS}"

WORKDIR /home/test-user/dotfiles

CMD ["/usr/bin/zsh"]
