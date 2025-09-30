import 'package:flutter/material.dart';
import 'package:in_code/constants/app_colors.dart';

class CameraPermissionDialog extends StatelessWidget {
  final VoidCallback onSettings;
  final VoidCallback onClose;

  const CameraPermissionDialog({
    super.key,
    required this.onSettings,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'Permesso fotocamera negato',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.kPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'L\'app non può accedere alla fotocamera. Vai nelle impostazioni per riattivarlo.',
                style: TextStyle(fontSize: 15, color: Color(0xFF555555), height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('Apri impostazioni'),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.kPrimary,
              child: const Icon(Icons.camera_alt, size: 40, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
} 