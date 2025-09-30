import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loading.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double radius;
  final double padding;
  final double elevation;
  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final bool isLoading;
  final int fontsize;

  const RoundButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.radius = 50.0,
    this.padding = 0.0,
    this.fontsize = 16,
    this.elevation = 4.0,
    this.icon,
    this.iconSize = 24.0,
    this.iconColor = Colors.white,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.all(padding),
        elevation: elevation,
      ),
      child: isLoading
          ? LoadingIndicator(
              size: 30,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    size: iconSize,
                    color: iconColor,
                  ),
                if (icon != null) SizedBox(width: 8),
                Text(
                  text,
                  style: GoogleFonts.inter(
                    color: textColor,
                    fontSize: fontsize.toDouble(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }
}
