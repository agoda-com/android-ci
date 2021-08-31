FROM amazoncorretto:8u292-alpine

RUN apk update && apk add bash git && rm -Rf /var/cache/apk/*

# Add gitlab-runner user (UID/GID = 996/996 as per host machine)
RUN addgroup -g 996 -S gitlab-runner \
    && adduser -h /home/gitlab-runner -u 996 -G gitlab-runner -D -s /bin/bash gitlab-runner