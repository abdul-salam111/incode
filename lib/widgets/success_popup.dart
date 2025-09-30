import 'package:flutter/material.dart';
import 'package:in_code/res/colors.dart';


class CustomScanDialog extends StatelessWidget {
  final String title;
  final String description;
  final Color titleColor;
  final Color descriptionColor;
  final String cancelButtonText;
  final Color cancelButtonColor;
  final Color cancelTextColor;
  final VoidCallback onCancel;
  final String continueButtonText;
  final Color continueButtonColor;
  final Color continueTextColor;
  final VoidCallback onContinue;
  final VoidCallback oneButtonOnPressed;
  final IconData icon;
  final Color iconBackgroundColor;
  final bool? isOneButton;
  final String oneButtontext;
  final Color? oneButtonColor;

  const CustomScanDialog({
    super.key,
    required this.title,
    required this.description,
    this.oneButtontext = "Riprova",
    this.oneButtonColor = AppColors.secondaryColor,
    this.titleColor = const Color(0xFF3A873B),
    this.descriptionColor = const Color(0xFF999999),
    this.cancelButtonText = "Annulla",
    this.cancelButtonColor = const Color(0xFFE8EDF2),
    this.cancelTextColor = const Color(0xFF9FA9B3),
    required this.onCancel,
    this.continueButtonText = "Continua",
    required this.oneButtonOnPressed,
    this.isOneButton = false,
    this.continueButtonColor = const Color(0xFF3A873B),
    this.continueTextColor = Colors.white,
    required this.onContinue,
    this.icon = Icons.check,
    this.iconBackgroundColor = const Color(0xFF3A873B),
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
            margin: const EdgeInsets.only(top: 60),
            padding:
                const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 16),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    color: descriptionColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                isOneButton != true
                    ? Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onCancel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cancelButtonColor,
                                foregroundColor: cancelTextColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              child: Text(cancelButtonText),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: continueButtonColor,
                                foregroundColor: continueTextColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              child: Text(continueButtonText),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: oneButtonOnPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: oneButtonColor,
                              foregroundColor: continueTextColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            child: Text(oneButtontext),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: iconBackgroundColor,
              child: Icon(icon, size: 48, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
