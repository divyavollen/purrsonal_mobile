# Base image
FROM mcr.microsoft.com/devcontainers/base:ubuntu AS base

# Arguments
ARG NONROOT_USER=vscode
ARG FLUTTER_VERSION=3.38.5-stable
ARG CMD_LINETOOLS_VER=13114758
ARG BUILD_TOOLS_VER=35.0.0
ARG PLATFORM_VER=android-36
ARG NDK_VERSION=28.2.13676358
ARG CMAKE_VERSION=3.22.1

# Environment variables
ENV DOCKER_BUILDKIT=1
ENV COMPOSE_FILE=/workspace/.devcontainer/docker-compose.yaml

# Install necessary packages
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    pkg-config \
    openjdk-17-jdk \
    wget

# Install Docker (necessary for DevContainer)
RUN curl -fsSL https://get.docker.com | bash

# Adding nonroot user's access to docker daemon
RUN echo "#!/bin/sh\n\
sudoIf() { if [ \"\$(id -u)\" -ne 0 ]; then sudo \"\$@\"; else \"\$@\"; fi }\n\
SOCKET_GID=\$(stat -c '%g' /var/run/docker.sock) \n\
if [ \"${SOCKET_GID}\" != '0' ]; then\n\
if [ \"\$(cat /etc/group | grep :\${SOCKET_GID}:)\" = '' ]; then sudoIf groupadd --gid \${SOCKET_GID} docker-host; fi \n\
if [ \"\$(id ${NONROOT_USER} | grep -E \"groups=.*(=|,)\${SOCKET_GID}\(\")\" = '' ]; then sudoIf usermod -aG \${SOCKET_GID} ${NONROOT_USER}; fi\n\
fi\n\
exec \"\$@\"" > /usr/local/share/docker-init.sh \
&& chmod +x /usr/local/share/docker-init.sh

# Flutter SDK
RUN curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz | tar -xJ -C /usr/local \
    && rm -rf /usr/local/flutter/.pub-cache  # Remove unnecessary Flutter cache to save space

# Set up environment
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/${BUILD_TOOLS_VER}
    
# # Download Android command-line tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && chown -R ${NONROOT_USER}:${NONROOT_USER} ${ANDROID_HOME}
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-${CMD_LINETOOLS_VER}_latest.zip
RUN unzip commandlinetools-linux-${CMD_LINETOOLS_VER}_latest.zip 
RUN mv /cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest
RUN rm commandlinetools-linux-${CMD_LINETOOLS_VER}_latest.zip

# # Accept licenses
RUN yes | sdkmanager --licenses

# # Install packages
RUN sdkmanager "build-tools;${BUILD_TOOLS_VER}" \
"platforms;${PLATFORM_VER}" \
"platform-tools" \
"ndk;${NDK_VERSION}" \
"cmake;${CMAKE_VERSION}"

# Add Flutter to the PATH
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Set entrypoint
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
