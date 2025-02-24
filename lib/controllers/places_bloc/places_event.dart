part of 'places_bloc.dart';

@immutable
sealed class PlacesEvent {}

class LoadPlacesEvent extends PlacesEvent {
  final bool isEnglish;
  LoadPlacesEvent(this.isEnglish);
}

class LoadMorePlacesEvent extends PlacesEvent {}

class ToggleFavouriteEvent extends PlacesEvent {
  final PlacesModel place;
  final bool isEnglish;

  ToggleFavouriteEvent(this.place, this.isEnglish);
}

class GetFavouritePlaces extends PlacesEvent{
  final bool isEnglish;
  GetFavouritePlaces(this.isEnglish);
}

class ChangeBottomNavigationIndexEvent extends PlacesEvent {
  final int index;
  ChangeBottomNavigationIndexEvent(this.index);
}
