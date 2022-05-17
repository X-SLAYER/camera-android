# Camera Plugin

A modified Flutter plugin (for Android only) allowing access to the device cameras on foreground.

# DICLAMER

This version of the camera plugin can be crashed in some functionalities because I just edited some files to make it fit my purpose of making the Livestream method works in the foreground

## Installation

add `camera_bg`

```yaml
camera_bg:
  git:
    url: https://github.com/X-SLAYER/camera-android.git
```

use `permission_handler` plugin to request camera permission before starting it on background [permission_handler](https://pub.dev/packages/permission_handler)

### Android

Change the minimum Android sdk version to 21 (or higher) in your `android/app/build.gradle` file.

```gradle
minSdkVersion 21
```

### Foreground Exemple

Check the working exemple [here](https://github.com/X-SLAYER/camera-android/tree/main/example/lib)
