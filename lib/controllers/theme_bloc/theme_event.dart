part of 'theme_bloc.dart';

abstract class ThemeEvent {
  const ThemeEvent();
}

class InitEvent extends ThemeEvent {} // when app starts

class ToggleThemeEvent extends ThemeEvent {}
