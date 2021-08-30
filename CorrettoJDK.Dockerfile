FROM amazoncorretto:8u292-alpine

RUN apk update && apk add bash git && rm -Rf /var/cache/apk/*

# Add gitlab-runner user (UID/GID = 996/996 as per host machine)
RUN groupadd -g 996 gitlab-runner \
    && useradd --uid 996 --gid 996 --create-home --shell /bin/bash gitlab-runner