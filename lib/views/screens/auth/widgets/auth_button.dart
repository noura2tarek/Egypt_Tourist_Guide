import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.isLoading = false,
  });

  final void Function()? onPressed;
  final String buttonText;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blackColor.withValues(alpha: 0.8),
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(
              buttonText,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.white,
              ),
            ),
    );
  }
}
