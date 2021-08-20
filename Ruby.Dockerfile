FROM ruby:2.7.4-alpine3.14

RUN apk update \
    && apk add bash \
            build-base \
            curl \
            git \
            git-lfs \
            jq \
            python2 \
    \
    && apk add --no-cache --upgrade grep \
    && rm -Rf /var/cache/apk/* \
    \
    && gem install --no-document \
            bundler \
            claide \
            executable-hooks \
            liquid-cli:0.0.1  \
            octokit \
    && gem update --system
