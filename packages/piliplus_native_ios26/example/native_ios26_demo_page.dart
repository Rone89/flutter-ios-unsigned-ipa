import 'package:flutter/material.dart';
import 'package:piliplus_native_ios26/piliplus_native_ios26.dart';

class NativeIos26DemoPage extends StatelessWidget {
  const NativeIos26DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        top: false,
        child: PiliPlusNativeHomeView(
          title: 'PiliPlus',
          subtitle: 'iOS 26 Liquid Glass Native Surface',
        ),
      ),
    );
  }
}
