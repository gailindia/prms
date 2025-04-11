// Created by AMIT JANGID on 17/07/20.

import 'package:flutter/material.dart';


/// This method will show a dialog box with custom UI and animation
showConfirmationDialog(
    BuildContext context, {
      required String title,
      required String description,
      required VoidCallback onNegativePressed,
      required VoidCallback onPositivePressed,
    }) {
  return showGeneralDialog(
    context: context,
    barrierLabel: '',
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (BuildContext context, animation, secondaryAnimation) {
      return _CustomConfirmDialog(
        title: title,
        description: description,
        onNegativePressed: onNegativePressed,
        onPositivePressed: onPositivePressed,
      );
    },
  );
}

class _CustomConfirmDialog extends StatelessWidget {
  final String title, description;
  final VoidCallback onNegativePressed, onPositivePressed;

  const _CustomConfirmDialog({
    required this.title,
    required this.description,
    required this.onNegativePressed,
    required this.onPositivePressed,
  });

  @override
  Widget build(BuildContext context) {
    const double _borderRadius = 20;
    final double _width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
        child: Stack(
          children: <Widget>[
            Container(
              width: _width,
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 80),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(_borderRadius)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(title, style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
                  Container(
                    height: 1.5,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        12,
                            (index) => Container(
                          width: 6,
                          height: 1.5,
                          color: Colors.amber,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(description, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      clipBehavior: Clip.antiAlias,
                      onPressed: onNegativePressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                        ),
                        elevation: 0.1,
                        backgroundColor: Colors.amber,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      child: Text("fghvjbk"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      clipBehavior: Clip.antiAlias,
                      onPressed: onPositivePressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                        ),
                        elevation: 0.1,
                        backgroundColor: Colors.amber,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      child: Text("fghvjbk"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
