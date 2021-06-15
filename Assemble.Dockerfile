FROM ubuntu:18.04

ARG ANDROID_COMPILE_SDK='29'
ARG ANDROID_BUILD_TOOLS='28.0.3'
ARG ANDROID_SDK_TOOLS='6200805'
ARG OPEN_JDK_DOWNLOAD_URL='https://corretto.aws/downloads/resources/8.292.10.1/amazon-corretto-8.292.10.1-linux-x64.tar.gz'
ARG OPEN_JDK_MD5='9d711fdeb9176a96bae0ba276f3f3695'

ENV KEYSTORE=/opt/keychain/release-key.keystore \
    KEYSTORE_PASSWORD=DX9ajGZ+!zM&HPEs2qxpze$%6G#d4wVD \
    KEY_ALIAS=agoda \
    KEY_PASSWORD=DX9ajGZ+!zM&HPEs2qxpze$%6G#d4wVD \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    JAVA_HOME=/opt/java/openjdk \
    JRE_HOME=/opt/java/openjdk/jre \
    ANDROID_HOME=/opt/android-sdk-linux

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
            curl \
            ca-certificates \
            unzip \
    \
    && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
    && apt-get install -yq --no-install-recommends git-lfs \
    && git lfs install \
    \
    && rm -r /var/lib/apt/lists/*

# Install Ruby and RVM
RUN gpg --keyserver hkp://keys.gnupg.net:80 --keyserver-options http-proxy="http://hk-agcprx-2000.corpdmz.agoda.local:8080" --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | grep -v __rvm_print_headline | bash -s stable --ruby=ruby-2.7.2 && \
    echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc && \
    # Install gems \
    /bin/bash -l -c "gem install bundler liquid-cli:0.0.1 stf-client:0.3.0-rc.12 --no-document" && \
    /bin/bash -l -c "gem update --system"
    
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

# Add license to SDK
COPY licenses/android-sdk-license /opt/android-sdk-linux/licenses/android-sdk-license

# Install Android SDK
RUN curl -sSL https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip > /tmp/android-sdk-linux.zip \
    && unzip /tmp/android-sdk-linux.zip -d /opt/android-sdk-linux/ \
    && rm /tmp/android-sdk-linux.zip \
    \
    && yes | sdkmanager --no_https --licenses --sdk_root=${ANDROID_HOME} \
    \
    && sdkmanager --sdk_root=${ANDROID_HOME} --verbose tools platform-tools \
      "platforms;android-${ANDROID_COMPILE_SDK}" \
      "build-tools;${ANDROID_BUILD_TOOLS}" \
    \
    && rm -r ${ANDROID_HOME}/emulator \
    && unset ANDROID_NDK_HOME
