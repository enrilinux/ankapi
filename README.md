# Ankapi

**A small Android companion for your self-hosted [Gokapi](https://github.com/Forceu/Gokapi) instance.**

Ankapi lets you connect to a Gokapi server, browse its files, and upload or delete files from your phone.

## Features

- First-run setup for the Gokapi server URL and API key; both remain editable in Settings.
- Browse uploaded files and see their IDs and remaining downloads.
- Upload files with a configurable download limit, expiration date, and optional password using Android's system file picker; delete files from the server.
- Choose **System**, **Light**, or **Dark** appearance.
- Choose **Normal** Material styling or **Material You** with Android dynamic colors when available.
- Interface languages: English (default), Italian, Spanish, French, and German.
- Separate release APKs for 32-bit ARM (`armeabi-v7a`) and 64-bit ARM (`arm64-v8a`).

## Requirements

- Android 7.0 (API 24) or later.
- A reachable Gokapi instance and an API key with the required permissions (at least **VIEW**, **UPLOAD**, **DOWNLOAD**, and **DELETE** for all current features).
- For development: Flutter SDK, Android SDK Platform 36, and Java 17 or newer.

## Get started

1. Install Ankapi and open it.
2. Enter your Gokapi server URL and API key, then choose your language and appearance.
3. Use the refresh button to reload the file list, the upload button to send a file, the download icon to save a file from the server, or the delete icon to remove one.

Use HTTPS for the server URL whenever possible. Ankapi stores its connection settings, including the API key, in the app's local preferences. Keep your device protected and do not share your API key.

## Build from source

```sh
git clone https://github.com/enrilinux/ankapi.git
cd ankapi
flutter pub get
flutter run
```

The Android application ID is `org.enrilinux.ankapi`.

### Debug APK

Build a single debug APK containing both ARM architectures:

```sh
flutter build apk --debug --target-platform android-arm,android-arm64
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`.

### Signed release APKs

The Fish script builds two smaller, individually installable release APKs:

```fish
fish android/build_release.fish
```

The script asks for the keystore password without echoing it. It expects a release keystore at `android/app/gokapi-release.jks`, with alias `gokapi-release`; the key password must match the keystore password. Keep the keystore and its password backed up securely. **Never commit or share them.**

The outputs are:

- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` — 32-bit ARM
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` — 64-bit ARM

Install the APK matching your device's CPU architecture. Do not install both variants over one another as separate app instances; they use the same application ID.

Prebuilt APKs are published on the [GitHub Releases page](https://github.com/enrilinux/ankapi/releases/latest) with architecture-specific filenames.

## Project details

- Flutter and Dart
- Gokapi REST API
- Local settings via `shared_preferences`
- File selection via `file_picker`
- Dynamic Android colors via `dynamic_color`

## License

Ankapi is distributed under the [MIT License](LICENSE). You may use, modify, and redistribute it, including in commercial projects, provided the copyright and license notice are retained.

This license applies to Ankapi's own code. Flutter and third-party dependencies remain under their respective licenses. Ankapi is an independent client for Gokapi and is not affiliated with the Gokapi project.
