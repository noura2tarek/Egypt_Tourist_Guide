import 'package:egypt_toutist_guide/views/screens/home/widgets/app_bottom_navigation_bar.dart';
import 'package:egypt_toutist_guide/views/screens/home/widgets/home_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../controllers/places_bloc/places_bloc.dart';
import '../../../controllers/theme_bloc/theme_bloc.dart';
import '../../../core/app_colors.dart';
import '../../../models/screen_model.dart';
import '../favorites/favorites_screen.dart';
import '../governorates/governorates_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of different screens using Screen Model
    List<ScreenModel> screens = [
      ScreenModel(title: 'app_title'.tr(), body: const HomeScreenBody()),
      ScreenModel(title: 'governorates'.tr(), body: const GovernoratesScreen()),
      ScreenModel(title: 'favorites_title'.tr(), body: const FavoritesScreen()),
      ScreenModel(title: 'settings_title'.tr(), body: ProfileScreen()),
    ];

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigationBar(),
      appBar: AppBar(
          title: BlocBuilder<PlacesBloc, PlacesState>(
            builder: (context, state) {
              final placesBloc = PlacesBloc.get(context);
              return Text(
                screens[placesBloc.currentPageIndex].title,
              );
            },
          ),
          actions: [
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                ThemeBloc themeBloc = ThemeBloc.get(context);
                final placesBloc = PlacesBloc.get(context);

                return IconButton(
                  icon: Icon(
                    Icons.language,
                    color: themeBloc.theme == 'light'
                        ? AppColors.black87Color
                        : AppColors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    // Toggle between English and Arabic
                    final newLocale = context.locale.languageCode == 'en'
                        ? const Locale('ar')
                        : const Locale('en');
                    context.setLocale(newLocale);
                    await Future.delayed(const Duration(milliseconds: 300));
                    placesBloc.add(
                        LoadPlacesEvent(context.locale.languageCode == 'en'));
                  },
                );
              },
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: BlocBuilder<PlacesBloc, PlacesState>(
          builder: (context, state) {
            final placesBloc = PlacesBloc.get(context);
            return screens[placesBloc.currentPageIndex].body;
          },
        ),
      ),
    );
  }
}
