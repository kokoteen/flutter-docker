# Develop flutter apps in container image

Build container image and create VSCode devcontainer in order to create a flutter apps.

* enable emulators localy: `xhost local:$USER` 
* list emulators: `emulator -list-avds`
* create emulator: `flutter emulators --create`
* launch emulator: `flutter emulators --launch flutter_emulator`

<!-- ## Tip

Download [flutter][1] (stable branch) and [sdkmanager][2] localy in this project directory.
This will improve performance if there is an error building the image.

```bash
# flutter
git clone https://github.com/flutter/flutter.git -b stable

# sdkmanager
wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
```

[1]: https://github.com/flutter/flutter.git
[2]: https://developer.android.com/studio/#downloads -->
