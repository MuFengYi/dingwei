import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:dingwei/dingwei.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _location = 'Unknown';
//原生消息回调
  EventChannel eventChannel = const EventChannel("qy/eventChannel");
  @override
  void initState() {
    super.initState();
    initPlatformState();
    requestLocation();
  }

  void requestLocation() {
    eventChannel.receiveBroadcastStream().listen((event) {
      print("location========" + event.toString());

      setState(() {
        _location = event.toString();
      });
      String eventCode = event['eventid'].toString();
      List list = event['data'];
      if (eventCode == "0") {
      } else if (eventCode == "1") {
      } else if (eventCode == "2") {}
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await Dingwei.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('Running on: $_location\n')
            ],
          ),
        ),
      ),
    );
  }
}
