import 'package:egypt_toutist_guide/views/screens/profile/widgets/log_out_button.dart';
import 'package:egypt_toutist_guide/views/screens/profile/widgets/profile_card.dart';
import 'package:egypt_toutist_guide/views/screens/profile/widgets/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controllers/auth_bloc/auth_bloc.dart';
import '../../../controllers/auth_bloc/auth_events.dart';
import '../../../controllers/profile_bloc/profile_bloc.dart';
import '../../../controllers/theme_bloc/theme_bloc.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_routes.dart';
import '../../../models/user_model.dart';
import '../../widgets/custom_snack_bar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              text: 'profile_updated_successfully'.tr(),
              color: chooseSnackBarColor(ToastStates.SUCCESS),
            ),
          );
        }
        if (state is ProfileImageUpdatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              text: 'profile_photo_updated_successfully'.tr(),
              color: chooseSnackBarColor(ToastStates.SUCCESS),
            ),
          );
        }
        if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              text: state.message,
              color: chooseSnackBarColor(ToastStates.ERROR),
            ),
          );
        }
      },
      builder: (context, state) {
        ProfileBloc profileBloc = ProfileBloc.get(context);
        AuthBloc authBloc = AuthBloc.get(context);
        bool isEditing = profileBloc.isEditing;
        UserModel user = profileBloc.user;
        if (state is ProfileLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const ProfilePic(),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'dark_theme'.tr(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BlocBuilder<ThemeBloc, ThemeState>(
                        builder: (context, state) {
                          ThemeBloc themeBloc = ThemeBloc.get(context);
                          return Switch(
                              value: themeBloc.theme == 'dark',
                              splashRadius: 10,
                              onChanged: (value) {
                                themeBloc.add(ToggleThemeEvent());
                              });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'profile_details'.tr(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Save Button
                      IconButton(
                        icon: Icon(
                          isEditing ? Icons.save : Icons.edit_note_rounded,
                          size: 30,
                        ),
                        onPressed: () {
                          if (isEditing) {
                            if (_formKey.currentState!.validate()) {
                              profileBloc.add(UpdateProfileEvent(user));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('fix_form_errors'.tr()),
                                  backgroundColor: AppColors.red,
                                ),
                              );
                            }
                          } else {
                            profileBloc.add(ToggleEditingEvent());
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  ProfileCard(
                    user: user,
                    isEditing: isEditing,
                    isPasswordVisible: profileBloc.isVisibleProfilePassword,
                    onTogglePasswordVisibility: () {
                      profileBloc.add(
                        TogglePasswordVisibilityEvent(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  //---- Logout Button ------//
                  LogOutButton(
                    logOutFunction: () {
                      authBloc.add(LogoutRequested());
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.loginRoute,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
