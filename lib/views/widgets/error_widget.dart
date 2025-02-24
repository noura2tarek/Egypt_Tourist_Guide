import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/app_colors.dart';

class AppErrorWidget extends StatelessWidget {
  final String? errorMessage;
  const AppErrorWidget({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: Text(
          'error_message'.tr(args: [errorMessage ?? 'unknown_error'.tr()]),
          textAlign: TextAlign.center,
          style: const TextStyle(color:AppColors.red, fontSize: 20),
        ),
      ),
    );
  }
}
