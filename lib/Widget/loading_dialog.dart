import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    builder: (_) => LoadingDialog(key: key),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));
  static void hide(BuildContext context) => Navigator.pop(context);
  const LoadingDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Platform.isAndroid
            ?  CircularProgressIndicator(
          color: Colors.amber.shade900,
        )
            :  CupertinoActivityIndicator(
          color: Colors.amber.shade900,
          radius: 20,
          animating: true,
        ),
      ),
    );
  }
}
