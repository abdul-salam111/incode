import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:in_code/controllers/navbar_controller.dart';
import 'package:in_code/controllers/scan_controller.dart';

import 'package:in_code/res/res.dart';

class Navbar extends GetView<NavbarController> {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NavbarController());
    Get.put(QRCodeController());

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: SizedBox(
            width: 70,
            height: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FloatingActionButton(
                backgroundColor: AppColors.redDarkColor,
                onPressed: () {
                  controller.selectedIndex.value = 2;
                },
                child: Image.asset(
                  "assets/images/scan.png",
                  height: 35,
                  width: 35,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          // resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            height: 80,
            width: double.infinity,
            color: Color(0xffE9ECEF),
            child: Row(
              mainAxisAlignment: mainAxisSpaceBetween,
              children: [
                Obx(
                  () => Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedIndex.value = 0;
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/projects.png",
                                    width: 30,
                                    height: 30,
                                    color: controller.selectedIndex.value == 0
                                        ? AppColors.redDarkColor
                                        : AppColors.textColorPrimary,
                                  ),
                                  Text(
                                    "Progetti",
                                    style: GoogleFonts.gabarito(
                                      fontWeight:
                                          controller.selectedIndex.value == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: controller.selectedIndex.value == 0
                                          ? AppColors.redDarkColor
                                          : AppColors.textColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      controller.selectedIndex.value == 0
                          ? Align(
                              alignment: topCenter,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: context.screenWidth * 0.02,
                                ),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.redDarkColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                Obx(
                  () => Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                controller.goToTab(1);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/interventi.png",
                                    width: 30,
                                    height: 30,
                                    color: controller.selectedIndex.value == 1
                                        ? AppColors.redDarkColor
                                        : AppColors.textColorPrimary,
                                  ),
                                  Text(
                                    "Interventi",
                                    style: GoogleFonts.gabarito(
                                      fontWeight:
                                          controller.selectedIndex.value == 1
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: controller.selectedIndex.value == 1
                                          ? AppColors.redDarkColor
                                          : AppColors.textColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      controller.selectedIndex.value == 1
                          ? Align(
                              alignment: topCenter,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: context.screenWidth * 0.03,
                                ),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.redDarkColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.selectedIndex.value = 2;
                    },
                    child: Column(
                      children: [
                        Spacer(),
                        Text(
                          "Scan     ",
                          style: GoogleFonts.gabarito(
                            fontWeight: controller.selectedIndex.value == 2
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: controller.selectedIndex.value == 2
                                ? AppColors.redDarkColor
                                : AppColors.textColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedIndex.value = 3;
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/utiliti.png",
                                    width: 30,
                                    height: 30,
                                    color: controller.selectedIndex.value == 3
                                        ? AppColors.redDarkColor
                                        : AppColors.textColorPrimary,
                                  ),
                                  Text(
                                    " Utilità ",
                                    style: GoogleFonts.gabarito(
                                      fontWeight:
                                          controller.selectedIndex.value == 3
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: controller.selectedIndex.value == 3
                                          ? AppColors.redDarkColor
                                          : AppColors.textColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      controller.selectedIndex.value == 3
                          ? Align(
                              alignment: topCenter,
                              child: Container(
                                margin: EdgeInsets.only(left: 5),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.redDarkColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                Obx(
                  () => Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedIndex.value = 4;
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/profile.png",
                                    width: 30,
                                    height: 30,
                                    color: controller.selectedIndex.value == 4
                                        ? AppColors.redDarkColor
                                        : AppColors.textColorPrimary,
                                  ),
                                  Text(
                                    " Profilo ",
                                    style: GoogleFonts.gabarito(
                                      fontWeight:
                                          controller.selectedIndex.value == 4
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: controller.selectedIndex.value == 4
                                          ? AppColors.redDarkColor
                                          : AppColors.textColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      controller.selectedIndex.value == 4
                          ? Align(
                              alignment: topCenter,
                              child: Container(
                                margin: EdgeInsets.only(left: 4),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.redDarkColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Obx(
            () => controller.pages.elementAt(controller.selectedIndex.value),
          ),
        ),
      ),
    );

    // Scaffold(
    //   resizeToAvoidBottomInset: false,

    //   bottomNavigationBar: BottomAppBar(
    //     color: const Color(0xffE9ECEF),
    //     child: Obx(
    //       () => Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [

    //         ],
    //       ),
    //     ),
    //   ),
    //   body: Obx(
    //     () => Stack(
    //       alignment: Alignment.center,
    //       children: [
    //         controller.pages[controller.selectedIndex.value],
    //         controller.selectedIndex.value == 0
    //             ? Align(
    //                 alignment: bottomLeft,
    //                 child: Container(
    //                   margin: EdgeInsets.only(left: context.screenWidth * 0.08),
    //                   width: 40,
    //                   height: 3,
    //                   decoration: BoxDecoration(
    //                       color: AppColors.primaryColor,
    //                       borderRadius: BorderRadius.circular(10)),
    //                 ),
    //               )
    //             : SizedBox.shrink(),
    //         controller.selectedIndex.value == 1
    //             ? Align(
    //                 alignment: bottomLeft,
    //                 child: Container(
    //                   margin: EdgeInsets.only(left: context.screenWidth * 0.26),
    //                   width: 40,
    //                   height: 3,
    //                   decoration: BoxDecoration(
    //                       color: AppColors.primaryColor,
    //                       borderRadius: BorderRadius.circular(10)),
    //                 ),
    //               )
    //             : SizedBox.shrink(),
    //         controller.selectedIndex.value == 3
    //             ? Align(
    //                 alignment: bottomRight,
    //                 child: Container(
    //                   margin:
    //                       EdgeInsets.only(right: context.screenWidth * 0.26),
    //                   width: 40,
    //                   height: 3,
    //                   decoration: BoxDecoration(
    //                       color: AppColors.primaryColor,
    //                       borderRadius: BorderRadius.circular(10)),
    //                 ),
    //               )
    //             : SizedBox.shrink(),
    //         controller.selectedIndex.value == 4
    //             ? Align(
    //                 alignment: bottomRight,
    //                 child: Container(
    //                   margin:
    //                       EdgeInsets.only(right: context.screenWidth * 0.08),
    //                   width: 40,
    //                   height: 3,
    //                   decoration: BoxDecoration(
    //                       color: AppColors.primaryColor,
    //                       borderRadius: BorderRadius.circular(10)),
    //                 ),
    //               )
    //             : SizedBox.shrink()
    //       ],
    //     ),
    //   ),
    // );
  }
}
