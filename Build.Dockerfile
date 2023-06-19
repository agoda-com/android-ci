FROM ubuntu:18.04

ARG ANDROID_COMPILE_SDK='30'
ARG ANDROID_BUILD_TOOLS='30.0.2'
ARG ANDROID_SDK_TOOLS='7302050'
ARG OPEN_JDK_DOWNLOAD_URL='https://corretto.aws/downloads/resources/17.0.7.7.1/amazon-corretto-17.0.7.7.1-linux-x64.tar.gz'
ARG OPEN_JDK_MD5='443750a02c28ff2807c80032ee2e8ebc'

ENV LANG='en_US.UTF-8'
ENV LANGUAGE='en_US:en'
ENV JAVA_HOME=/opt/java/openjdk
ENV ANDROID_SDK_ROOT=/opt
ENV PATH="/opt/cmdline-tools/tools/bin:/opt/platform-tools:/opt/java/openjdk/bin:$PATH"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
            curl \
            ca-certificates \
            git \
            git-extras \
            unzip \
            fontconfig \
    \
    && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
    && apt-get install -yq --no-install-recommends git-lfs \
    && git lfs install \
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
    update-alternatives --install /usr/bin/java java "${JAVA_HOME}/bin/java" 1 \
    && update-alternatives --set java "${JAVA_HOME}/bin/java" \
    && update-alternatives --install /usr/bin/javac javac "${JAVA_HOME}/bin/javac" 1 \
    && update-alternatives --set javac "${JAVA_HOME}/bin/javac"

# Install Android SDK
RUN curl -L https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip > /tmp/android-sdk-linux.zip \
    && unzip -q /tmp/android-sdk-linux.zip -d "${ANDROID_SDK_ROOT}/cmdline-tools/" \
    && rm /tmp/android-sdk-linux.zip \
    && mv "${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools" "${ANDROID_SDK_ROOT}/cmdline-tools/tools" \
    \
    && yes | sdkmanager --no_https --licenses \
    && sdkmanager platform-tools --verbose \
        "platforms;android-${ANDROID_COMPILE_SDK}" \
        "build-tools;${ANDROID_BUILD_TOOLS}" \
    \
    && rm -r "${ANDROID_SDK_ROOT}/emulator"
