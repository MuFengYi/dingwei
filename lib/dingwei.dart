import 'dart:async';

import 'package:flutter/services.dart';

class Dingwei {
  static const MethodChannel _channel = MethodChannel('dingwei');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
