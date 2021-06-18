FROM ruby:2.7.3-alpine3.13

RUN apk update \
    && apk add bash \
            build-base \
            curl \
            git \
            python3 \
            py3-pip \
    && rm -Rf /var/cache/apk/*
