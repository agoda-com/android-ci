FROM amazoncorretto:8u292-alpine

RUN apk update && apk add bash git && rm -Rf /var/cache/apk/*
