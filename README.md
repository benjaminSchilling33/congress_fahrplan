# congress_fahrplan
A Congress Fahrplan App written in Flutter

## How to build

Build the app using `flutter build apk --split-per-abi`.

## How to build for release

Increment the `flutterVersionCode` and `flutterVersionName` in `android/app/build.gradle`

Required `key.properties` in `./android/`.

Content:

```
storePassword=<Keystore Password>
keyPassword=<Key Password>
keyAlias=<Alias>
storeFile=<Location of the Keystore>
```

When building on Windows: Make sure that the location only includes `\\` and no `\`.

## License
SPDX-License-Identifier: GPL-2.0-only

The full version of the license can be found in LICENSE.

## Copyright
Copyright (C) 2019 Benjamin Schilling



