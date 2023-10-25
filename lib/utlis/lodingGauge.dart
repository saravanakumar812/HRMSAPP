import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:post/utlis/constant_colors.dart';

//import 'constants_colors.dart';

class LoadingGauge {
  void showLoader(BuildContext context) {
    Loader.show(
      context,
      overlayFromTop: 0.0,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: primaryColor,
      ),
      themeData: Theme.of(context).copyWith(primaryColor: primaryColorLight),
    );
  }

  void hideLoader() {
    Loader.hide();
  }
}
