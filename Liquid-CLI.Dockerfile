FROM ruby:2.7.3-alpine3.13

# Install liquid
RUN apk update && apk add bash curl git && rm -Rf /var/cache/apk/* \
    && gem install bundler liquid-cli:0.0.1 --no-document \
    && gem update --system
    