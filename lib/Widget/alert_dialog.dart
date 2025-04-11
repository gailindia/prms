import 'package:flutter/material.dart'; 

class DialogUtils {
  static final DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(
      BuildContext context, {
        required String title,
        required String description,
        required VoidCallback onpositivePressed,
        String okBtnText = "Ok",
        String cancelBtnText = "Cancel",
      }) {
    showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text(title),
              content: Text(description),
              actions: <Widget>[
                //  ElevatedButton(
                //   child: Text(okBtnText),
                //   onPressed: okBtnFunction,
                // ),
                ElevatedButton(
                    child: Text(okBtnText),
                    onPressed: onpositivePressed,)
                    // onPressed: () {
                    //   // Navigator.pop(context);
                    //   // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    //   //     HomeScreen()), (Route<dynamic> route) => false);
                    // })
              ],
            );
          });
        });
  }
}
