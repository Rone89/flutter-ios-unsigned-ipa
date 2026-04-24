# PiliPlus Native iOS 26 UI

This package adds native SwiftUI surfaces for a Flutter iOS app through `UiKitView`/`FlutterPlatformView`.

It is included in this repository as a local package and consumed from the root app with:

```yaml
dependencies:
  piliplus_native_ios26:
    path: packages/piliplus_native_ios26
```

## What it provides

- A native iOS home surface using SwiftUI.
- iOS 26 Liquid Glass styling when available.
- Safe fallback materials for iOS 15-25.
- A platform channel for native actions such as opening a URL.

## Minimal Flutter usage

```dart
import 'package:piliplus_native_ios26/piliplus_native_ios26.dart';

const PiliPlusNativeHomeView(
  title: 'PiliPlus',
  subtitle: 'iOS 26 native experience',
);
```

## Notes

- Build and test with an Xcode/iOS SDK that contains the iOS 26 Liquid Glass APIs.
- On older SDKs, Swift may fail to parse iOS 26 APIs even though runtime availability checks are present.
