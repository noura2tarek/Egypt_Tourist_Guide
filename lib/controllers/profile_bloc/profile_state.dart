part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileInitialState extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadedState extends ProfileState {}

final class ProfileUpdatedState extends ProfileState {}

final class ProfileImageUpdatedState extends ProfileState {}

final class ProfileErrorState extends ProfileState {
  final String message;
  ProfileErrorState({required this.message});
}

final class ProfileEditingToggledState extends ProfileState {}

final class PasswordVisibilityToggledState extends ProfileState {}
