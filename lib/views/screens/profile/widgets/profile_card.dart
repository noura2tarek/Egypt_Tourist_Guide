/*------- Profile Card -------*/
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../models/user_model.dart';
import 'editable_field.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.user,
    required this.isEditing,
    this.onTogglePasswordVisibility,
    required this.isPasswordVisible,
  });

  final UserModel user;
  final bool isEditing;
  final bool isPasswordVisible;
  final void Function()? onTogglePasswordVisibility;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightPurple2.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditableField(
              label: 'full_name'.tr(),
              value: user.fullName,
              onChanged: (value) => user.fullName = value,
              isEditing: isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'validation_full_name'.tr();
                }
                return null;
              },
            ),
            const Divider(height: 20),
            EditableField(
              label: 'email'.tr(),
              value: user.email,
              onChanged: (value) => user.email = value,
              isEditing: isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'validation_email'.tr();
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'validation_email_invalid'.tr();
                }
                return null;
              },
            ),
            const Divider(height: 20),
            EditableField(
              label: 'password'.tr(),
              value: user.password,
              onChanged: (value) => user.password = value,
              isEditing: isEditing,
              isPassword: true,
              isPasswordVisible: isPasswordVisible,
              onTogglePasswordVisibility: onTogglePasswordVisibility,
            ),
            const Divider(height: 20),
            EditableField(
              label: 'phone_number'.tr(),
              value: user.phoneNumber ?? '',
              onChanged: (value) => user.phoneNumber = value,
              isEditing: isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'validation_phone_number_empty'.tr();
                }
                if (value.length < 10) {
                  return 'validation_phone_number_invalid'.tr();
                }
                return null;
              },
            ),
            const Divider(height: 20),
            EditableField(
              label: 'address'.tr(),
              value: user.address ?? '',
              onChanged: (value) => user.address = value,
              isEditing: isEditing,
            ),
          ],
        ),
      ),
    );
  }
}
