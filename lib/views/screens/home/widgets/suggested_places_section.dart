import 'dart:developer';
import 'package:egypt_toutist_guide/views/screens/home/widgets/suggested_places_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../controllers/places_bloc/places_bloc.dart';
import '../../../../data.dart';
import '../../../../models/place_model.dart';
import '../../../widgets/error_widget.dart';

class SuggestedPlacesSection extends StatelessWidget {
  const SuggestedPlacesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesBloc, PlacesState>(builder: (context, state) {
      final placesBloc = PlacesBloc.get(context);
      List<PlacesModel> places = placesBloc.placesV;
      if (state is PlacesLoaded) {
        if (state.places.isEmpty) {
          return Center(
            child: Text('no_data'.tr()),
          );
        } else {
          places = state.places;
        }
      } else if (state is PlacesError) {
        log(state.message);
        return AppErrorWidget(errorMessage: state.message);
      }
      return Skeletonizer(
        enabled: state is PlacesLoading,
        child: SuggestedPlacesGrid(
          suggestedPlaces: places.isEmpty ? PLACES : places,
        ),
      );
    });
  }
}
