import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class EditableField extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final bool isEditing;
  final bool isPassword;
  final String? Function(String?)? validator;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePasswordVisibility;

  const EditableField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.isEditing,
    this.isPassword = false,
    this.validator,
    this.isPasswordVisible = false,
    this.onTogglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        isEditing
            ? TextFormField(
                initialValue: value,
                obscureText: isPassword && !isPasswordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: isPassword
                      ? IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.grey,
                          ),
                          onPressed: onTogglePasswordVisibility,
                        )
                      : null,
                ),
                onChanged: onChanged,
                validator: validator,
              )
            : Text(
                isPassword ? '••••••••' : value,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
      ],
    );
  }
}
