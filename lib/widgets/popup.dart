import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../res/res.dart';
import 'round_button.dart';

class CustomSuccessDialog extends StatelessWidget {
  final String icon;
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const CustomSuccessDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: padding20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              height: context.height * 0.2,
              width: context.width * 0.3,
            ),
            10.heightBox,
            Text(
              title,
              style: context.titleSmall!.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
              textAlign: TextAlign.center,
            ),
            10.heightBox,
            Text(
              message,
              style: context.bodySmall!.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            (context.height * 0.03).heightBox,
            RoundButton(
              text: "Ok",
              onPressed: onConfirm,
              radius: 5,
              backgroundColor: AppColors.secondaryColor,
            ).w48(context)
          ],
        ),
      ),
    );
  }
}
