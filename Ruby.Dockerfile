FROM ruby:2.7.3-alpine3.13

RUN apk update \
    && apk add bash \
            build-base \
            curl \
            git \
            git-lfs \
            python2 \
    && apk add --no-cache --upgrade grep \
    && rm -Rf /var/cache/apk/* \
    && gem install --no-document \
            bundler \
            liquid-cli:0.0.1  \
            octokit \
    && gem update --system
