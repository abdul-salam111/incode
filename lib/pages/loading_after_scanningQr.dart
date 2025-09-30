import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_code/controllers/utiliti_screen_controller.dart';

class ReplaceLabelResultScreen extends StatefulWidget {
  const ReplaceLabelResultScreen({super.key});

  @override
  State<ReplaceLabelResultScreen> createState() =>
      _ReplaceLabelResultScreenState();
}

class _ReplaceLabelResultScreenState extends State<ReplaceLabelResultScreen> {
  final controller = Get.find<UtilitiScreenController>();

  @override
  void initState() {
    super.initState();
    callApi();
  }

  Future<void> callApi() async {
    await controller.relabelObject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(() => controller.isLoading.value
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Label replaced successfully',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
      ),
    );
  }
}
