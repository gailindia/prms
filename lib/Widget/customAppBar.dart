import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  CustomAppBar({Key? key,required this.title,});

  @override
  Widget build(BuildContext context) {

    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.amber,
      title: Text(title,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
