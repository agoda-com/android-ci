FROM ubuntu:18.04

ARG RECV_KEYS=''

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en'

# Install Curl
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
            curl \
            ca-certificates \
            unzip \
            gnupg \
            dirmngr \
    \
    && rm -r /var/lib/apt/lists/*

# Install Ruby and RVM
RUN gpg --keyserver hkp://keys.gnupg.net:80 --keyserver-options http-proxy=${http_proxy} --recv-keys=${RECV_KEYS} && \
    curl -sSL https://get.rvm.io | grep -v __rvm_print_headline | bash -s stable --ruby=ruby-2.7.2 && \
    echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc && \
    # Install gems \
    /bin/bash -l -c "gem install bundler liquid-cli:0.0.1 stf-client:0.3.0-rc.12 --no-document" && \
    /bin/bash -l -c "gem update --system"

