FROM ubuntu:18.04

ARG GRADLE_VERSION='5.6.4'
ARG OPEN_JDK_DOWNLOAD_URL='https://corretto.aws/downloads/resources/8.292.10.1/amazon-corretto-8.292.10.1-linux-x64.tar.gz'
ARG OPEN_JDK_MD5='9d711fdeb9176a96bae0ba276f3f3695'

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    JAVA_HOME=/opt/java/openjdk \
    JRE_HOME=/opt/java/openjdk/jre \
    GRADLE_HOME="/opt/gradle-${GRADLE_VERSION}/bin" \
    PATH="/opt/gradle-${GRADLE_VERSION}/bin:/opt/java/openjdk/bin:$PATH"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
            curl \
            ca-certificates \
            git \
            git-extras \
            unzip \
    \
    && rm -r /var/lib/apt/lists/*

# Install OpenJDK
RUN set -eux; \
    curl -LfsSo /tmp/openjdk.tar.gz ${OPEN_JDK_DOWNLOAD_URL}; \
    echo "${OPEN_JDK_MD5} */tmp/openjdk.tar.gz" | md5sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    chown -R root:root /opt/java; \
    rm -rf /tmp/openjdk.tar.gz; \
    \
    update-alternatives --install /usr/bin/java java ${JRE_HOME}/bin/java 1 \
    && update-alternatives --set java ${JRE_HOME}/bin/java \
    && update-alternatives --install /usr/bin/javac javac ${JRE_HOME}/../bin/javac 1 \
    && update-alternatives --set javac ${JRE_HOME}/../bin/javac

# Install Gradle
RUN cd /opt \
    && curl -fl -sSL https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip -o gradle-all.zip \
    && unzip -q "gradle-all.zip" \
    && rm "gradle-all.zip" \
    && mkdir -p ~/.gradle
