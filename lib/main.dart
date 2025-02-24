import 'dart:developer';
import 'package:egypt_toutist_guide/views/screens/auth/login_screen.dart';
import 'package:egypt_toutist_guide/views/screens/auth/signup_screen.dart';
import 'package:egypt_toutist_guide/views/screens/governorates/governoarates_places.dart';
import 'package:egypt_toutist_guide/views/screens/governorates/place_details_screen.dart';
import 'package:egypt_toutist_guide/views/screens/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'controllers/auth_bloc/auth_bloc.dart';
import 'controllers/places_bloc/places_bloc.dart';
import 'controllers/profile_bloc/profile_bloc.dart';
import 'controllers/theme_bloc/theme_bloc.dart';
import 'core/app_colors.dart';
import 'core/app_routes.dart';
import 'core/app_strings_en.dart';
import 'core/custom_page_routes.dart';
import 'core/services/shared_prefs_service.dart';
import 'firebase_options.dart';
import 'models/place_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  await SharedPrefsService.init();
  String? token = SharedPrefsService.getStringData(key: AppStringEn.tokenKey);

  Widget startWidget = const LoginScreen();
  if (token != null) {
    startWidget = const HomeScreen();
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      child: MyApp(
        startPage: startWidget,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.startPage,
  });

  final Widget startPage;

  @override
  Widget build(BuildContext context) {
    bool isEnglish = context.locale.languageCode == 'en';
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(
          create: (context) => PlacesBloc()
            ..add(LoadPlacesEvent(isEnglish))
            ..add(GetFavouritePlaces(isEnglish)),
        ),
        BlocProvider(
          create: (context) => ProfileBloc()..add(LoadProfileEvent()),
        ),
        BlocProvider(
          create: (context) {
            final themeBloc = ThemeBloc();
            themeBloc.add(InitEvent());
            return themeBloc;
          },
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                primaryContainer: AppColors.white,
                primary: AppColors.primaryColor,
                seedColor: AppColors.white,
              ),
              fontFamily: 'merriweather',
              appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: AppColors.blackColor),
                elevation: 0.8,
              ),
              iconButtonTheme: IconButtonThemeData(
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.lightPurple,
                ),
              ),
              dividerTheme: const DividerThemeData(
                color: AppColors.lightPurple,
              ),
            ),
            darkTheme: ThemeData(
              fontFamily: 'merriweather',
              brightness: Brightness.dark,
              appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: AppColors.white),
                elevation: 0.8,
              ),
              iconButtonTheme: IconButtonThemeData(
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.deepPurpleAccent,
                ),
              ),
              dividerTheme: const DividerThemeData(
                color: AppColors.deepPurpleAccent,
              ),
            ),
            themeMode: state.themeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            onGenerateRoute: onGenerateRoute,
            home: startPage,
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////
/*----- On Generate page routes ----*/
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  log('Navigating to: ${settings.name}');
  switch (settings.name) {
    case AppRoutes.signupRoute:
      return SlideRightRoute(child: const SignupScreen());
    case AppRoutes.loginRoute:
      return FadeTransitionRoute(child: const LoginScreen());
    case AppRoutes.homeRoute:
      return FadeTransitionRoute(child: const HomeScreen());
    case AppRoutes.placeDetailsRoute:
      // Extract arguments and pass them to Place Details
      final args = settings.arguments as PlacesModel;
      return SlideRightRoute(child: PlaceDetailsScreen(placeModel: args));
    case AppRoutes.placesRoute:
      // Extract arguments and pass them to GovernoratesPlaces
      final args = settings.arguments as Map<String, dynamic>;
      return SlideRightRoute(
        child: GovernoratesPlaces(
          governorate: args['governorate'],
          places: args['places'],
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Route not found'),
          ),
        ),
      );
  }
}
