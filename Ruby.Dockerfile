FROM ruby:2.7.3-alpine3.13

# Install necessary packages
RUN apk update \
    && apk add bash \
            build-base \
            curl \
            git \
            git-lfs \
            jq \
            openssh \
            python2 \
    && apk add --no-cache --upgrade grep

# Preinstall gems
RUN gem install --no-document \
            bundler \
            claide \
            executable-hooks \
            liquid-cli:0.0.1  \
            octokit \
            gitlab \
    && gem update --system

# Install codecoach
RUN apk add --no-cache --update npm \
    && npm i -g codecoach \
    && rm -Rf /var/cache/apk/*
