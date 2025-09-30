import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

import '../res/res.dart';

class Utils {
  static void anotherFlushbar(
      BuildContext context, String message, Color color) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          margin: padding14,
          message: message,
          backgroundColor: color,
          forwardAnimationCurve: Curves.decelerate,
          duration: Duration(seconds: 3),
          borderRadius: BorderRadius.circular(10),
          flushbarPosition: FlushbarPosition.TOP,
        )..show(context));
  }
}
