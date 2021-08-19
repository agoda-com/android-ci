# Specify built Build.Dockerfile image
ARG BUILD_IMAGE=${BUILD_IMAGE:-""}

ARG RUBY_VERSION=2.7.4
ARG RUBY_PATH=/usr/local/

FROM ruby:$RUBY_VERSION AS rubybuild

FROM $BUILD_IMAGE

COPY --from=rubybuild $RUBY_PATH $RUBY_PATH

# Install STF-Client
COPY stf-client-0.3.1.pre.rc.1.gem /tmp/stf.gem

RUN gem install /tmp/stf.gem \
    && rm -f /tmp/stf.gem \
    && gem update --system

# Install Cron for device pinging
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
            cron \
    \
    && rm -r /var/lib/apt/lists/* \
    \
    && (find /etc/cron.* -type f | grep -v .placeholder | xargs rm -f)

COPY ./ping-device.sh /ping-device.sh
COPY ./ping-device-crontab /etc/cron.d/ping-device

# Install Allure
ENV PATH="/allure/bin:$PATH"
ENV ALLURE_CONFIG="/allure-config/allure.properties"
ENV ALLURE_NO_ANALYTICS=1

RUN mkdir /allure \
    && mkdir /allure-config \
    && curl -sSL https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.8.1/allure-commandline-2.8.1.tgz -o allure-commandline.tgz \
    && tar --strip-components 1 -xvf allure-commandline.tgz -C /allure \
    && rm allure-commandline.tgz
