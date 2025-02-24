import 'package:flutter/material.dart';
import '../../../../models/place_model.dart';
import '../../../widgets/place_card.dart';

class PopularPlacesListView extends StatelessWidget {
  final List<PlacesModel> popularPlacesList;

  const PopularPlacesListView({super.key, required this.popularPlacesList});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
      ),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => PlaceCard(
        place: popularPlacesList[index],
        isWide: true,
      ),
      separatorBuilder: (context, counter) => const SizedBox(
        width: 20,
      ),
      itemCount: popularPlacesList.length,
    );
  }
}
