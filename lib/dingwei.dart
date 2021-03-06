import 'dart:async';

import 'package:flutter/services.dart';

class Dingwei {
  static const MethodChannel _channel = MethodChannel('dingwei');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  void installApk(String path) async {
    print("path========" + path);
    await _channel.invokeMethod('installApk', {'path': path});
  }
}
