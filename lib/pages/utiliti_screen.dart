import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:in_code/pages/projects/projects_screen.dart';
import 'package:in_code/pages/utilia_scanner.dart';
import 'package:in_code/res/res.dart';

class UtilitiScreen extends GetView<ProjectScreen> {
  const UtilitiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: Text(
          "Utilità",
            style: context.displayLarge!.copyWith(
            color: AppColors.textColorWhite,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.06,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: screenPadding,
        child: Column(
          children: [
            10.heightBox,
            Center(
                    child: Row(
                children: [
                Image.asset(
                  "assets/images/utilita.png",
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.width * 0.08,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Text(
                  "Sostituzione etichetta",
                  style: context.headlineSmall?.copyWith(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ))
                .box
                .padding(padding20)
                .width(double.infinity)
                .rounded
                .border(color: Color(0xffCFCFCF))
                .color(Color(0xffE4E4E4))
                .make()
                .onTap(() {
              Get.to(() => UtilitaScannerScreen());
            })
          ],
        ),
      ),
    );
  }
}
