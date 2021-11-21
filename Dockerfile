FROM ubuntu:20.04

ENV USER="developer"
ENV DEBIAN_FRONTEND="noninteractive" 
ENV	ANDROID_SDK_ROOT=/home/$USER/android 
ENV FLUTTER_HOME="/home/$USER/flutter"
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_HOME/bin:$PATH"

# Prerequisites
RUN apt-get update \
	&& apt-get install -y --no-install-recommends sudo bash curl git unzip xz-utils libpulse0 libxcursor1 libglu1-mesa openjdk-8-jdk wget \
	&& apt-get autoremove -y

# Set up new user
RUN useradd -ms /bin/bash $USER \
	&& echo "$USER:$USER" | chpasswd \
	&& adduser $USER sudo

USER $USER
WORKDIR /home/$USER
   
# Prepare Android directories and system variables
RUN bash -c 'mkdir -p android/{cmdline-tools,emulator,licenses,patcher,platform-tools,platforms,system-images}' \
	&& mkdir -p .android \
	&& touch .android/repositories.cfg 

# Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip \
	&& unzip sdk-tools.zip \
	&& rm sdk-tools.zip \
	&& mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/tools \
  	&& mv /home/$USER/cmdline-tools/bin $ANDROID_SDK_ROOT/cmdline-tools/tools \
  	&& mv /home/$USER/cmdline-tools/lib $ANDROID_SDK_ROOT/cmdline-tools/tools \
	&& yes | sdkmanager --licenses \
	&& sdkmanager --install \
	"system-images;android-29;google_apis_playstore;x86_64" \
	"platforms;android-29" \
	"platform-tools" \
	"build-tools;29.0.3" \
	"cmdline-tools;latest" 

# Flutter SDK 
RUN git clone https://github.com/flutter/flutter.git -b stable \
	&& flutter config --no-analytics \
	&& flutter precache \
	&& yes | flutter doctor --android-licenses \
	&& flutter doctor -v \
	&& flutter emulators --create \
	&& flutter update-packages