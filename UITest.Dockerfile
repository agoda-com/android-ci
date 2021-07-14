# Specify built Build.Dockerfile image
ARG BUILD_IMAGE=

ARG RUBY_VERSION=2.7.4
ARG RUBY_PATH=/usr/local/

FROM ruby:$RUBY_VERSION AS rubybuild

FROM $BUILD_IMAGE

COPY --from=rubybuild $RUBY_PATH $RUBY_PATH

RUN gem install stf-client:0.3.0-rc.12 --no-document \
    && gem update --system

# Install Allure
RUN mkdir /allure \
    && mkdir /allure-config \
    && curl -sSL https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.8.1/allure-commandline-2.8.1.tgz -o allure-commandline.tgz \
    && tar --strip-components 1 -xvf allure-commandline.tgz -C /allure \
    && rm allure-commandline.tgz

# Set up insecure default key
COPY adb/adbkey adb/adbkey.pub /root/.android/
