FROM ghcr.io/ublue-os/ubuntu-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="david@davidleal.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --assume-yes && \
    apt-get upgrade --assume-yes && \
    apt-get install --assume-yes --no-install-recommends \
      adwaita-icon-theme-full \
      build-essential \
      curl \
      file \
      git \
      locales \
      procps \
      wl-clipboard && \
    apt-get clean

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV USER_ID=1000

RUN useradd -u "${USER_ID}" --create-home --shell /bin/bash --user-group linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER linuxbrew
WORKDIR /home/linuxbrew
ENV NONINTERACTIVE=1

RUN curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
RUN .linuxbrew/bin/brew install gcc@11 ruby

USER root

RUN userdel linuxbrew
