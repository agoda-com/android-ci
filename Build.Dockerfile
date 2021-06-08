FROM ubuntu:18.04

ARG ANDROID_COMPILE_SDK='29'
ARG ANDROID_BUILD_TOOLS='28.0.3'
ARG ANDROID_SDK_TOOLS='6200805'
ARG GRADLE_VERSION='5.6.4'
ARG OPEN_JDK_DOWNLOAD_URL='https://corretto.aws/downloads/resources/8.252.09.1/amazon-corretto-8.252.09.1-linux-x64.tar.gz'
ARG OPEN_JDK_MD5='7e9925dbe18506ce35e226c3b4d05613'

ENV JAVA_HOME=/opt/java/openjdk \
    JRE_HOME=/opt/java/openjdk/jre \
    \
    ANDROID_HOME=/opt/android-sdk-linux \
    \
    GRADLE_HOME="/opt/gradle-${GRADLE_VERSION}/bin" \
    PATH="/opt/gradle-${GRADLE_VERSION}/bin:/allure/bin:/usr/local/rvm/bin:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools:/opt/android-sdk-linux/tools/bin:/opt/android-sdk-linux/emulator:/opt/java/openjdk/bin:$PATH"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            curl \
            ca-certificates \
            unzip && \
    \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install -yq --no-install-recommends git-lfs && \
    git lfs install && \
    \
    rm -r /var/lib/apt/lists/*

# Install OpenJDK
RUN set -eux; \
    curl -LfsSo /tmp/openjdk.tar.gz ${OPEN_JDK_DOWNLOAD_URL}; \
    echo "${OPEN_JDK_MD5} */tmp/openjdk.tar.gz" | md5sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz; \
    \
    update-alternatives --install /usr/bin/java java ${JRE_HOME}/bin/java 1 && \
    update-alternatives --set java ${JRE_HOME}/bin/java && \
    update-alternatives --install /usr/bin/javac javac ${JRE_HOME}/../bin/javac 1 && \
    update-alternatives --set javac ${JRE_HOME}/../bin/javac

# Add license to SDK
COPY licenses/android-sdk-license /opt/android-sdk-linux/licenses/android-sdk-license

# Install Android SDK
RUN curl -sSL https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip > /tmp/android-sdk-linux.zip && \
    unzip /tmp/android-sdk-linux.zip -d /opt/android-sdk-linux/ && \
    rm /tmp/android-sdk-linux.zip && \
    \
    yes | sdkmanager --no_https --licenses --sdk_root=${ANDROID_HOME} && \
    \
    sdkmanager --sdk_root=${ANDROID_HOME} --verbose tools platform-tools \
      "platforms;android-${ANDROID_COMPILE_SDK}" \
      "build-tools;${ANDROID_BUILD_TOOLS}" && \
    \
    rm -r ${ANDROID_HOME}/emulator && \
    unset ANDROID_NDK_HOME

# Install Gradle
RUN cd /opt && \
    curl -fl -sSL https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip -o gradle-all.zip && \
    unzip -q "gradle-all.zip" && \
    rm "gradle-all.zip" && \
    mkdir -p ~/.gradle
