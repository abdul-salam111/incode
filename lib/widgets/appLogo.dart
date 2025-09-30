import 'package:flutter/material.dart';
import 'package:in_code/res/res.dart';


Widget appLogo({required double width, required double height}) {
  return Center(
      child: Image.asset(applogo).box.height(height).width(width).make());
}
