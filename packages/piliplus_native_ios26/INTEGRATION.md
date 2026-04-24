# Integration

This package is already wired into the root Flutter app with:

```yaml
dependencies:
  piliplus_native_ios26:
    path: packages/piliplus_native_ios26
```

Run from the repository root:

```bash
flutter pub get
cd ios
pod install
```

Use the native surface from Flutter:

```dart
import 'package:piliplus_native_ios26/piliplus_native_ios26.dart';

const Scaffold(
  body: SafeArea(
    top: false,
    child: PiliPlusNativeHomeView(
      title: 'PiliPlus',
      subtitle: 'iOS 26 Liquid Glass Native Surface',
    ),
  ),
)
```

## Suggested target locations in the Flutter app

- Prototype as a new route first, then wire it into the existing GetX router.
- For a home-page experiment, wrap `PiliPlusNativeHomeView` in an existing Flutter page rather than replacing `main.dart`.
- Keep the original Flutter UI available behind a feature flag until the native surface is validated.
