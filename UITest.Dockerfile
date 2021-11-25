# Specify built Build.Dockerfile image
ARG BUILD_IMAGE=${BUILD_IMAGE:-""}

ARG RUBY_VERSION=2.7.4
ARG RUBY_PATH=/usr/local/

FROM ruby:$RUBY_VERSION AS rubybuild

FROM $BUILD_IMAGE

COPY --from=rubybuild $RUBY_PATH $RUBY_PATH

COPY stf-client-0.3.1.pre.rc.1.gem /tmp/stf.gem

RUN gem install /tmp/stf.gem \
    && rm -f /tmp/stf.gem \
    && gem update --system

# Install misc packages
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
            python-pip \
            python-setuptools \
    \
    pip install --upgrade pip && \
    pip install PyYAML==3.12 && \
    pip install pillow mock \
    \
    && rm -r /var/lib/apt/lists/*

ENV PATH="/allure/bin:$PATH"
ENV ALLURE_CONFIG="/allure-config/allure.properties"
ENV ALLURE_NO_ANALYTICS=1

# Install Allure
RUN mkdir /allure \
    && mkdir /allure-config \
    && curl -sSL https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.8.1/allure-commandline-2.8.1.tgz -o allure-commandline.tgz \
    && tar --strip-components 1 -xvf allure-commandline.tgz -C /allure \
    && rm allure-commandline.tgz
