import 'package:egypt_toutist_guide/views/screens/auth/widgets/auth_button.dart';
import 'package:egypt_toutist_guide/views/screens/auth/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../controllers/auth_bloc/auth_bloc.dart';
import '../../../controllers/auth_bloc/auth_events.dart';
import '../../../controllers/auth_bloc/auth_states.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_images.dart';
import '../../../core/app_routes.dart';
import '../../widgets/custom_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hiddenPassword = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    AuthBloc authBloc = AuthBloc.get(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          isLoading = false;
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.homeRoute,
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              text: state.message,
              color: chooseSnackBarColor(ToastStates.ERROR),
            ),
          );
          isLoading = false;
        } else if (state is AuthLoading) {
          isLoading = true;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppImages.pyramids,
                  fit: BoxFit.cover,
                ),
              ),
              //--- Change lang button ---//
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.language,
                      color: AppColors.white, size: 30),
                  onPressed: () {
                    final newLocale = context.locale.languageCode == 'en'
                        ? const Locale('ar')
                        : const Locale('en');
                    context.setLocale(newLocale);
                  },
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.blackColor.withValues(alpha: 0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'login'.tr(),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black87Color,
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            //---- Email Form Field ----//
                            CustomTextFormField(
                              controller: emailController,
                              labelText: 'email',
                              hintText: 'email_hint',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'validation_email'.tr();
                                }
                                if (!value.contains('@')) {
                                  return 'validation_email_at'.tr();
                                }
                                if (!value.contains('.')) {
                                  return 'validation_email_dot'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextFormField(
                              controller: passwordController,
                              labelText: 'password',
                              hintText: 'password_hint',
                              obscureText: hiddenPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'validation_password_empty'.tr();
                                }
                                if (value.length < 6) {
                                  return 'validation_password_length'.tr();
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hiddenPassword = !hiddenPassword;
                                  });
                                },
                                icon: Icon(
                                  hiddenPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            //---- Login button ----//
                            AuthButton(
                              isLoading: isLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  authBloc.add(
                                    LoginRequested(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  );
                                }
                              },
                              buttonText: 'login'.tr(),
                            ),
                            const SizedBox(height: 16.0),
                            // Sign up prompt
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.signupRoute);
                              },
                              child: Text(
                                'signup_prompt'.tr(),
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
