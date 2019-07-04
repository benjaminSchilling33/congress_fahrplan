# congress_fahrplan
A Congress Fahrplan App written in Flutter

## How to build

Build the app using `flutter build apk --split-per-abi`.

Required `key.properties` in `./android/`.

Content:

```
storePassword=<Keystore Password>
keyPassword=<Key Password>
keyAlias=<Alias>
storeFile=<Location of the Keystore>
```

When building on Windows: Make sure that the location only includes `\\` and no `\`.

## Design

### [Color Palette](https://www.materialpalette.com/indigo/blue)

- ![#303F9F](https://placehold.it/15/303F9F/000000?text=+) `Dark Primary Color`
- ![#C5CAE9](https://placehold.it/15/C5CAE9/000000?text=+) `Light Primary Color`
- ![#3F51B5](https://placehold.it/15/3F51B5/000000?text=+) `Primary Color`
- ![#FFFFFF](https://placehold.it/15/FFFFFF/000000?text=+) `Text / Icons`
- ![#448AFF](https://placehold.it/15/448AFF/000000?text=+) `Accent Color`
- ![#212121](https://placehold.it/15/212121/000000?text=+) `Primary Text`
- ![#757575](https://placehold.it/15/757575/000000?text=+) `Secondary Text`
- ![#BDBDBD](https://placehold.it/15/BDBDBD/000000?text=+) `Divider Color`

## License
SPDX-License-Identifier: GPL-2.0-only

The full version of the license can be found in LICENSE.

## Copyright
Copyright (C) 2019 Benjamin Schilling



