import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

// Custom snack bar with dynamic states/color
SnackBar customSnackBar({required String text, required Color color}) {
  return SnackBar(
    backgroundColor: color,
    content: Text(text),
    duration: const Duration(seconds: 2),
  );
}

// Choose toast color
Color chooseSnackBarColor(ToastStates state) {
  Color color = Colors.red;
  switch (state) {
    case ToastStates.SUCCESS:
      color = AppColors.green;
      break;
    case ToastStates.WARNING:
      color = AppColors.yellow;
      break;
    case ToastStates.ERROR:
      color = AppColors.red;
      break;
    case ToastStates.NOTIFY:
      color = AppColors.grey800;
      break;
  }
  return color;
}

enum ToastStates { SUCCESS, WARNING, NOTIFY, ERROR }
