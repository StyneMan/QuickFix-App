import 'package:flutter/material.dart';

typedef InitCallback();

class CustomButton extends StatelessWidget {
  final String variant;
  final Widget child;
  final Color bgColor;
  final Color foreColor;
  final Color borderColor;
  final Function()? onPressed;
  final double paddingX, paddingY, borderRadius;

  const CustomButton({
    Key? key,
    required this.bgColor,
    required this.child,
    required this.borderColor,
    required this.foreColor,
    required this.onPressed,
    required this.variant,
    this.borderRadius = 4.0,
    this.paddingX = 10.0,
    this.paddingY = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 14.0,
          ),
          backgroundColor: bgColor,
          foregroundColor: foreColor,
        ),
      ),
    );
  }
}
