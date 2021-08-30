# Specify built Build.Dockerfile image
ARG BUILD_IMAGE=${BUILD_IMAGE:-""}

ARG RUBY_VERSION=2.7.4
ARG RUBY_PATH=/usr/local/

FROM ruby:$RUBY_VERSION AS rubybuild

FROM $BUILD_IMAGE

COPY --from=rubybuild $RUBY_PATH $RUBY_PATH

COPY stf-client-0.3.1.pre.rc.1.gem /tmp/stf.gem

# Install STF-Client
RUN gem install /tmp/stf.gem \
    && rm -f /tmp/stf.gem \
    && gem update --system

# Install Python2
RUN apt-get update \
    && apt-get install -y --no-install-recommends python-minimal

# Install Allure
ENV PATH="/allure/bin:$PATH"
ENV ALLURE_CONFIG="/allure-config/allure.properties"
ENV ALLURE_NO_ANALYTICS=1
RUN mkdir /allure \
    && mkdir /allure-config \
    && curl -sSL https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.8.1/allure-commandline-2.8.1.tgz -o allure-commandline.tgz \
    && tar --strip-components 1 -xvf allure-commandline.tgz -C /allure \
    && rm allure-commandline.tgz
