import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../controllers/places_bloc/places_bloc.dart';
import '../../../../core/app_colors.dart';
import '../../../widgets/custom_snack_bar.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  late final LocalAuthentication auth;
  bool _isAuthenticated = false;
  bool _isAvailable = false;

  // Check if the device supports biometrics or not
  _checkAuthFeature() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      if (canAuthenticate || canAuthenticateWithBiometrics) {
        setState(() {
          _isAvailable = true;
        });
      } else {
        log('Auth with biometrics feature is not available');
        setState(() {
          _isAvailable = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
          text: 'auth-not-available'.tr(),
          color: chooseSnackBarColor(ToastStates.NOTIFY),
        ));
      }
    } on PlatformException catch (e) {
      setState(() {
        _isAvailable = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
        text: 'auth-not-available'.tr(),
        color: chooseSnackBarColor(ToastStates.NOTIFY),
      ));
      log('Error occurred(can not authenticate): $e');
    }
  }

  // Auth with biometrics fingerprint method
  authWithBiometrics() async {
    try {
      if (!_isAvailable) {
        // Assuming the user is authenticated
        setState(() {
          _isAuthenticated = true;
        });
        return;
      }
      // auth using fingerprint biometrics
      final bool authenticated = await auth.authenticate(
        localizedReason: 'scan-fingerprint'.tr(),
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticated = authenticated;
      });
      if (_isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            text: 'authentication-Done'.tr(),
            color: chooseSnackBarColor(ToastStates.SUCCESS),
          ),
        );
      }
    } catch (e) {
      // That means the user device does not support biometrics
      // Assuming the user is authenticated
      setState(() {
        _isAuthenticated = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          text: 'auth-not-available'.tr(),
          color: chooseSnackBarColor(ToastStates.NOTIFY),
        ),
      );
    }
  }

  @override
  void initState() {
    // initialize local authentication
    auth = LocalAuthentication();
    _checkAuthFeature();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) {
        final placesBloc = PlacesBloc.get(context);
        return BottomNavigationBar(
          backgroundColor: AppColors.purple,
          onTap: (int pageIndex) async {
            if (pageIndex == 3) {
              // Check finger print auth to access profile screen
              await authWithBiometrics();
              if (_isAuthenticated) {
                placesBloc.add(ChangeBottomNavigationIndexEvent(pageIndex));
              } else if (!_isAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                  text: 'access-denied'.tr(),
                  color: chooseSnackBarColor(ToastStates.ERROR),
                ));
              }
            } else {
              placesBloc.add(ChangeBottomNavigationIndexEvent(pageIndex));
            }
          },
          currentIndex: placesBloc.currentPageIndex,
          selectedItemColor: AppColors.purple,
          unselectedItemColor: AppColors.grey,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: 'home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.location_on_outlined),
              label: 'governorates'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_outline_rounded),
              label: 'liked'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle_outlined),
              label: 'settings'.tr(),
            ),
          ],
        );
      },
    );
  }
}
