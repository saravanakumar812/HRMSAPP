// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'constants_colors.dart';

// ignore: camel_case_types
class Custom_AppBar extends StatefulWidget implements PreferredSizeWidget {
  String? title;
  Custom_AppBar({required Key key, this.title})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<Custom_AppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Text(widget.title!,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500)),
      backgroundColor: primaryColorLight,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
