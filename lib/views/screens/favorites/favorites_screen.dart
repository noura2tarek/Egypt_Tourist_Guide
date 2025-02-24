import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../controllers/places_bloc/places_bloc.dart';
import '../../../data.dart';
import '../../../models/place_model.dart';
import '../../widgets/place_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final placesBloc = PlacesBloc.get(context);
    double width = MediaQuery.sizeOf(context).width;
    List<PlacesModel> places = placesBloc.favPlacesP;
    return BlocConsumer<PlacesBloc, PlacesState>(
      listener: (context, state) {
        if (state is FavouritePlacesSuccess) {
          places = state.places;
        }
      },
      builder: (context, state) {
        if (state is PlacesError) {
          return Center(
            child: Text(state.message),
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: places.isEmpty && state is FavouritePlacesSuccess,
              child: Center(
                child: Text('no_favorites'.tr()),
              ),
            ),
            Visibility(
              visible: state is FavouritePlacesLoading || places.isNotEmpty,
              child: Expanded(
                child: Skeletonizer(
                  enabled: state is FavouritePlacesLoading,
                  child: ListView.builder(
                    itemCount: places.isEmpty
                        ? PLACES.sublist(0, 4).length
                        : places.length,
                    itemBuilder: (context, index) {
                      final place = places.isEmpty
                          ? PLACES.sublist(0, 4)[index]
                          : places[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                          vertical: width * 0.02,
                        ),
                        child: PlaceCard(
                          place: place,
                          isWide: true,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
