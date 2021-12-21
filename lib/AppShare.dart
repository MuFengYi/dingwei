import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:dingwei/Screen_util.dart';
import 'package:dingwei/dingwei.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

import 'AppBarCustom.dart';

///版本更新加提示框
class UpdateDialog {
  bool _isShowing = false;
  late BuildContext _context;
  late UpdateWidget _widget;

  UpdateDialog(BuildContext context, {double progress = 0.0}) {
    _context = context;
    _widget = UpdateWidget(progress: progress);
  }

  /// 显示弹窗
  Future<bool> show() {
    try {
      if (isShowing()) {
        return Future.value(false);
      }

      showCupertinoDialog(
          context: _context,
          builder: (BuildContext context) {
            return _widget;
          });
      _isShowing = true;
      return Future.value(true);
    } catch (err) {
      _isShowing = false;
      return Future.value(false);
    }
  }

  /// 隐藏弹窗
  Future<bool> dismiss() {
    try {
      if (_isShowing) {
        _isShowing = false;
        Navigator.pop(_context);
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (err) {
      return Future.value(false);
    }
  }

  /// 是否显示
  bool isShowing() {
    return _isShowing;
  }

  /// 更新进度
  void update(double progress) {
    if (isShowing()) {
      _widget.update(progress);
    }
  }

  /// 显示版本更新提示框
  static UpdateDialog showUpdate(
    BuildContext context, {
    double progress = 0.0,
  }) {
    UpdateDialog dialog = UpdateDialog(context);
    dialog.show();
    return dialog;
  }
}

// ignore: must_be_immutable
class UpdateWidget extends StatefulWidget {
  double progress;
  UpdateWidget({Key? key, this.progress = 0.0}) : super(key: key);

  _UpdateWidgetState _state = _UpdateWidgetState();

  update(double progress) {
    _state.update(progress);
  }

  @override
  _UpdateWidgetState createState() => _state;
}

class _UpdateWidgetState extends State<UpdateWidget> {
  update(double progress) {
    if (!mounted) {
      return;
    }
    setState(() {
      widget.progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: AlertDialog(
      title: Text('正在更新请稍候'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LinearProgressIndicator(
            value: widget.progress,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('取消更新'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ));
  }

  double getFitWidth(BuildContext context) {
    return min(getScreenHeight(context), getScreenWidth(context));
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

class AppShare extends StatefulWidget {
  @override
  _AppShareState createState() => _AppShareState();
}

class _AppShareState extends State<AppShare> {
  double _progress = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // BotToast.showLoading();
  }

  Future<void> dowloandApk(String url, String version) async {
    UpdateDialog dialog = UpdateDialog.showUpdate(context, progress: 0.0);

    var dio = Dio();
    Directory? storageDir = await getExternalStorageDirectory();
    String storagePath = storageDir!.path + "/$version.apk";
    var response = await dio.download(url, storagePath,
        onReceiveProgress: (int count, int total) {
      print("$count $total");
      _progress = count / total;
      dialog.update(_progress);
      print("_progress=========" + _progress.toString());

      if (_progress == 1) {
        _progress = 0;
        Navigator.pop(context);
        Dingwei().installApk(storagePath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List arguments = (ModalRoute.of(context)!.settings.arguments as List?)!;
    String titleName = arguments[0];
    String appIcon = arguments[1];
    String appName = arguments[2];
    String appbadge = arguments[3];
    String appUrl = arguments[4];
    String arrowIcon = arguments[5];
    String shareIcon = arguments[6];
    return Scaffold(
      appBar: AppBarCustom(
        titleName: titleName,
        actions: [],
        key: null,
        isBack: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    Image.asset(
                      appIcon,
                      fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      appName,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      appbadge,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                height: set_H(100),
                child: InkWell(
                  onTap: () {
                    Dio()
                        .get(
                      appUrl,
                      options: Options(
                        responseType: ResponseType.json,
                      ),
                    )
                        .then((value) async {
                      Map map = Map.from(value.data);
                      print("value1===========" + map.toString());
                      String aa = map['data']['appVersion'];
                      PackageInfo packageInfo =
                          await PackageInfo.fromPlatform();
                      String version = "QY_" + packageInfo.version;
                      if (aa != version) {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text("提示"),
                                content: Text("有新版本，是否更新？"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text("取消"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text("确定"),
                                    onPressed: () {
                                      Navigator.pop(context);

                                      dowloandApk(
                                          map['data']['downloadLink'], version);
                                    },
                                  ),
                                ],
                              );
                            });
                      } else {
                        BotToast.showText(text: "已是最新版本");
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("     检查更新"),
                      Image.asset(
                        arrowIcon,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: Image.asset(
                shareIcon,
                fit: BoxFit.cover,
                width: set_W(470),
                height: set_W(470),
              ),
            )
          ],
        ),
      ),
    );
  }
}
