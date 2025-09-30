import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_code/res/colors.dart';


class LoadingIndicator extends StatelessWidget {
  final double size;

  const LoadingIndicator({
    super.key,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                strokeWidth: 4,
                color: AppColors.secondaryColor,
              )
            : CupertinoActivityIndicator(
                radius: size / 2,
              ),
      ),
    );
  }
}
