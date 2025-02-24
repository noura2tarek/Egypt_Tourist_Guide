part of 'theme_bloc.dart';

abstract class ThemeState {
  const ThemeState(this.themeMode);

  final ThemeMode themeMode;
}

class ThemeInitial extends ThemeState {
  const ThemeInitial(super.themeMode);
}

class ThemeChanged extends ThemeState {
  const ThemeChanged(super.themeMode);
}
