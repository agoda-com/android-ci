FROM ruby:2.7.3-alpine3.13

RUN apk update && apk add bash curl git && rm -Rf /var/cache/apk/*
