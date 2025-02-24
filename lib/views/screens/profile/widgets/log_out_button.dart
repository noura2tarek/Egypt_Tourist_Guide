import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
    this.logOutFunction,
  });

  final void Function()? logOutFunction;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: logOutFunction,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.red,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'logout'.tr(),
        style: const TextStyle(color: AppColors.white, fontSize: 18),
      ),
    );
  }
}
