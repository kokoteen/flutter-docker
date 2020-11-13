FROM ubuntu:20.04
ENV DEBIAN_FRONTEND="noninteractive" \
	ANDROID_SDK_ROOT=/home/developer/android

# Prerequisites
RUN apt-get update \
	&& apt-get install -y --no-install-recommends sudo bash curl git unzip xz-utils libpulse0 libxcursor1 libglu1-mesa openjdk-8-jdk wget \
	&& apt-get autoremove -y

# Set up new user
RUN useradd -ms /bin/bash developer \
	&& echo "developer:developer" | chpasswd \
	&& adduser developer sudo

USER developer
WORKDIR /home/developer
   
# Prepare Android directories and system variables
RUN bash -c 'mkdir -p android/{cmdline-tools,emulator,licenses,patcher,platform-tools,platforms,system-images}' \
	&& mkdir -p .android \
	&& touch .android/repositories.cfg 

# Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip \
	&& unzip sdk-tools.zip \
	&& rm sdk-tools.zip \
	&& mv tools android/cmdline-tools/tools \
	&& yes | /home/developer/android/cmdline-tools/tools/bin/sdkmanager --licenses \
	&& /home/developer/android/cmdline-tools/tools/bin/sdkmanager --install \
	"system-images;android-29;google_apis_playstore;x86_64" \
	"platforms;android-29" \
	"platform-tools" \
	"build-tools;29.0.3" 

# Flutter SDK 
RUN git clone https://github.com/flutter/flutter.git \ 
	&& /home/developer/flutter/bin/flutter precache \
	&& yes | /home/developer/flutter/bin/flutter doctor --android-licenses \
	&& /home/developer/flutter/bin/flutter doctor \
	&& /home/developer/flutter/bin/flutter emulators --create \
	&& /home/developer/flutter/bin/flutter update-packages