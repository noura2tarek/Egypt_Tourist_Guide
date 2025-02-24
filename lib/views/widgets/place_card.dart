import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllers/places_bloc/places_bloc.dart';
import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../data.dart';
import '../../models/governorate_model.dart';
import '../../models/place_model.dart';
import 'favourite_icon.dart';

class PlaceCard extends StatelessWidget {
  final PlacesModel place;
  final bool isWide;

  const PlaceCard({
    super.key,
    required this.place,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double textFactor = width / 415;
    List<GovernorateModel> governorateList =
        context.locale.toString() == 'ar' ? ARABICGOVERNORATES : GOVERNERATES;
    GovernorateModel placeGovernorate = governorateList
        .firstWhere((element) => element.id == place.governorateId);
    final placesBloc = PlacesBloc.get(context);
    double bigContainerHeight = isWide ? width * 0.81 * 0.75 : width * 0.48;
    return InkWell(
      // on Tab go to place details
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.placeDetailsRoute,
        arguments: place,
      ),
      child: Container(
        width: isWide ? width * 0.81 : width * 0.25,
        height: bigContainerHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.containerColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor.withValues(alpha: 0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(2, 6),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(place.image),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.bottomCenter,
        // Second container shows place name and favourite icon
        child: SecondContainer(
          isWide: isWide,
          bigContainerHeight: bigContainerHeight,
          placesBloc: placesBloc,
          placeGovernorate: placeGovernorate,
          place: place,
          textFactor: textFactor,
        ),
      ),
    );
  }
}

////////////////////////////////
//------ Second container -------//
class SecondContainer extends StatelessWidget {
  SecondContainer({
    super.key,
    required this.bigContainerHeight,
    required this.placesBloc,
    required this.place,
    required this.isWide,
    required this.textFactor,
    required this.placeGovernorate,
  });

  final double bigContainerHeight;
  final PlacesBloc placesBloc;
  final PlacesModel place;
  final bool isWide;
  final double textFactor;
  final GovernorateModel placeGovernorate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: bigContainerHeight * 0.29,
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 7.0,
      ),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        color: AppColors.secGrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // place name and fav icon
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // place name
                Expanded(
                  child: Text(
                    place.name,
                    style: TextStyle(
                      fontSize: isWide ? textFactor * 16 : textFactor * 12.5,
                      color: AppColors.white,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                  ),
                ),
                /*------- Favourite icon -------*/
                InkWell(
                  onTap: () {
                    placesBloc.add(
                      ToggleFavouriteEvent(
                        place,
                        context.locale.toString() == 'en',
                      ),
                    );
                  },
                  child: BlocBuilder<PlacesBloc, PlacesState>(
                    builder: (context, state) {
                      bool? isFav = place.isFav;
                      if (state is FavoriteToggledState) {
                        if (state.place?.id == place.id) {
                          isFav = state.place?.isFav;
                        }
                      }
                      return CircleAvatar(
                        backgroundColor: AppColors.white,
                        maxRadius: isWide ? 10 : 8,
                        child: FavouriteIcon(
                          isFav: isFav ?? false,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 2),
          // Governorate name of the place
          Text(
            placeGovernorate.name,
            style: TextStyle(
              fontSize: isWide ? textFactor * 11.2 : textFactor * 9,
              color: AppColors.white,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
            ),
          ),
          // place description
          Text(
            place.description,
            style: TextStyle(
              fontSize: isWide ? textFactor * 11.2 : textFactor * 9,
              color: AppColors.white,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
