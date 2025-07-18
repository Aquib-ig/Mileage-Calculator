import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onTap;
  const AppButton({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color(0xffee3a57),
        ),
        child: Center(child: child),
      ),
    );
  }
}