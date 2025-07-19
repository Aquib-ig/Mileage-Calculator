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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(child: child),
      ),
    );
  }
}
