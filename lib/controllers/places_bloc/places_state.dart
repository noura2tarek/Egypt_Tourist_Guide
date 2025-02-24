part of 'places_bloc.dart';

@immutable
sealed class PlacesState {}

final class PlacesInitial extends PlacesState {}

final class PlacesLoading extends PlacesState {}

final class PlacesLoaded extends PlacesState {
  final List<PlacesModel> places;

  PlacesLoaded({required this.places});
}

final class PlacesError extends PlacesState {
  final String message;

  PlacesError({required this.message});
}

final class FavoriteToggledState extends PlacesState {
  final PlacesModel? place;

  FavoriteToggledState({this.place});
}

class FavouritePlacesLoading extends PlacesState {}

class FavouritePlacesSuccess extends PlacesState {
  final List<PlacesModel> places;

  FavouritePlacesSuccess({required this.places});
}

final class BottomNavigationChangedState extends PlacesState {
  final int pageIndex;

  BottomNavigationChangedState(this.pageIndex);
}
