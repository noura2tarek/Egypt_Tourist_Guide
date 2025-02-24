import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/firebase_service.dart';
import '../../data.dart';
import '../../models/place_model.dart';

part 'places_event.dart';

part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  int currentPageIndex = 0;

  PlacesBloc() : super(PlacesInitial()) {
    //-- Handle load places event --//
    on<LoadPlacesEvent>(_loadPlaces);
    //-- Handle load more places event --//
    on<LoadMorePlacesEvent>(_loadMorePlaces);
    //-- Handle Toggle Favourite event --//
    on<ToggleFavouriteEvent>(_toggleFavourite);
    //-- Handle bottom navigation event --//
    on<ChangeBottomNavigationIndexEvent>(_changeBottomNavigationIndex);
    on<GetFavouritePlaces>(_getFavouritePlaces);
  }

  // Static method to return places bloc object (to apply singleton pattern)
  static PlacesBloc get(context) => BlocProvider.of(context);

  List<PlacesModel> placesV = [];

  // handle load places event
  Future<void> _loadPlaces(
      LoadPlacesEvent event, Emitter<PlacesState> emit) async {
    emit(PlacesLoading());
    await Future.delayed(const Duration(milliseconds: 600));
    // Get places from firebase
    placesV = [];
    if (event.isEnglish) {
      List<PlacesModel> placesE = await FirebaseService.getPlaces();
      placesV = placesE;
    } else {
      List<PlacesModel> placesA = await FirebaseService.getArabicPlaces();

      placesV = placesA;
    }
    log('places success with length: ${placesV.length}');
    emit(PlacesLoaded(places: placesV));
  }

  // Handle load more places event
  Future<void> _loadMorePlaces(
      LoadMorePlacesEvent event, Emitter<PlacesState> emit) async {
    emit(PlacesLoading());
    await Future.delayed(const Duration(milliseconds: 600));
    emit(PlacesLoaded(places: PLACES));
  }

  // handle Toggle Favourite event
  Future<void> _toggleFavourite(
      ToggleFavouriteEvent event, Emitter<PlacesState> emit) async {
    try {
      PlacesModel placeE = event.place;
      User? user = FirebaseService.authInstance.currentUser;
      // Call the toggleFavouritePlace method from firebase service
      await FirebaseService.toggleFavouritePlace(user: user, placeE: placeE);
      // -- Getting the favourite places again
      favPlacesP = [];
      // Get the user favourite places using the getUserFavouritePlacesId method
      // from firebase service
      List<int> placesId = await FirebaseService.getUserFavouritePlacesId(
          uid: FirebaseService.authInstance.currentUser!.uid,
          isEnglish: event.isEnglish);
      for (int id in placesId) {
        PlacesModel place = await FirebaseService.getPlaceById(
            id: id, isEnglish: event.isEnglish);
        favPlacesP.add(place);
      }
      // Making the places isFav true for all places
      for (PlacesModel place in favPlacesP) {
        place.isFav = true;
      }
      // apply it in places list in home
      for (PlacesModel place in placesV) {
        if (place.id == placeE.id) {
          place.isFav = !place.isFav;
        }
      }

      emit(FavoriteToggledState(place: placeE));
      emit(FavouritePlacesSuccess(places: favPlacesP));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'no_user_found') {
        emit(PlacesError(message: "no_user_found".tr()));
      }
    } catch (e) {
      emit(PlacesError(message: e.toString()));
    }
  }

  //-- handle bottom navigation event -- //
  Future<void> _changeBottomNavigationIndex(
      ChangeBottomNavigationIndexEvent event, Emitter<PlacesState> emit) async {
    currentPageIndex = event.index;
    emit(BottomNavigationChangedState(currentPageIndex));
  }

  List<PlacesModel> favPlacesP = [];

  //-- handle get favourite places event --//
  Future<void> _getFavouritePlaces(
      GetFavouritePlaces event, Emitter<PlacesState> emit) async {
    emit(FavouritePlacesLoading());
    await Future.delayed(const Duration(milliseconds: 600));
    favPlacesP = [];
    try {
      List<int> placesId = await FirebaseService.getUserFavouritePlacesId(
        uid: FirebaseService.authInstance.currentUser!.uid,
        isEnglish: event.isEnglish,
      );
      for (int id in placesId) {
        PlacesModel place = await FirebaseService.getPlaceById(
          id: id,
          isEnglish: event.isEnglish,
        );
        favPlacesP.add(place);
        for (PlacesModel place in placesV) {
          if (place.id == id) {
            place.isFav = true;
          }
        }
      }
      // Making the places isFav true for places in fav places list
      for (var place in favPlacesP) {
        place.isFav = true;
      }
      emit(FavouritePlacesSuccess(places: favPlacesP));
      log('favourite places success with length: ${favPlacesP.length}');
    } catch (e) {
      emit(PlacesError(message: e.toString()));
    }
  }
}
