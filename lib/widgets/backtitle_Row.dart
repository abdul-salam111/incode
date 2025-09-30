
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_code/res/res.dart';


class BackTitleRow extends StatelessWidget {
  final String title;

  const BackTitleRow({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        SizedBox(width: 5),
        Text(
          title,
          style: context.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
