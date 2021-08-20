FROM ruby:2.7.3-alpine3.13

# Install necessary packages
RUN apk update \
    && apk add bash \
            build-base \
            curl \
            git \
            git-lfs \
            jq \
            python2 \
            py-pip \
    \
    && apk add --no-cache --upgrade grep \
    && rm -Rf /var/cache/apk/*

# Preinstall python packages
RUN pip install pyyaml

# Preinstall gems
RUN gem install --no-document \
            bundler \
            claide \
            executable-hooks \
            liquid-cli:0.0.1  \
            octokit \
    && gem update --system
