import 'package:flutter/material.dart';

import 'Screen_util.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  AppBarCustom(
      {required Key? key,
      required this.titleName,
      this.onPressed,
      this.isBack = true,
      required List<Widget> actions})
      : super(key: key);

  String? titleName;
  late bool isBack;
  late final onPressed;
  List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        titleName!,
        style: TextStyle(color: Colors.white, fontSize: set_Sp(34)),
      ),
      centerTitle: true,
      leading: isBack
          ? IconButton(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: set_W(30)),
              icon: Container(
                child: Image.asset("assets/img/icon_back_n.png",
                    height: set_H(45)),
              ),
              onPressed: () {
                if (onPressed == null) {
                  Navigator.of(context).pop();
                } else {
                  onPressed();
                }
              })
          : null,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
