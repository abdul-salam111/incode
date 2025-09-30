import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'language_controller.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LanguageController>();
    
    return Obx(() {
      return PopupMenuButton<String>(
        color: Colors.white,
        offset: const Offset(0, 40),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onSelected: (String code) {
          controller.changeLanguage(code);
        },
        itemBuilder: (BuildContext context) {
          return ['en', 'it'].map((String code) {
            return PopupMenuItem<String>(
              value: code,
              child: Row(
                children: [
                  Text(
                    controller.getLanguageFlag(code),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    controller.getLanguageName(code),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.getLanguageFlag(controller.currentLanguage.value),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      );
    });
  }
} 