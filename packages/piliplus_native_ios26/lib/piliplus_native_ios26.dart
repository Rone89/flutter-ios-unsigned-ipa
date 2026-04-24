import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PiliPlusNativeIos26 {
  static const MethodChannel _channel = MethodChannel('piliplus_native_ios26/actions');

  static Future<void> openUrl(String url) {
    return _channel.invokeMethod<void>('openUrl', <String, Object?>{'url': url});
  }
}

class PiliPlusNativeHomeView extends StatelessWidget {
  const PiliPlusNativeHomeView({
    super.key,
    this.title = 'PiliPlus',
    this.subtitle = 'Native iOS 26 UI',
    this.accentColor = const Color(0xFFFF6699),
    this.height,
    this.onCreated,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final double? height;
  final PlatformViewCreatedCallback? onCreated;

  @override
  Widget build(BuildContext context) {
    final creationParams = <String, Object?>{
      'title': title,
      'subtitle': subtitle,
      'accentColor': accentColor.value,
    };

    final view = switch (defaultTargetPlatform) {
      TargetPlatform.iOS => UiKitView(
          viewType: 'piliplus_native_ios26/home',
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: onCreated,
        ),
      _ => _FallbackView(title: title, subtitle: subtitle, accentColor: accentColor),
    };

    if (height == null) {
      return view;
    }

    return SizedBox(height: height, child: view);
  }
}

class _FallbackView extends StatelessWidget {
  const _FallbackView({
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accentColor.withOpacity(0.16), Theme.of(context).colorScheme.surface],
        ),
      ),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(subtitle, textAlign: TextAlign.center),
                if (!Platform.isIOS) ...[
                  const SizedBox(height: 12),
                  const Text('Native iOS surface is only available on iOS.'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
