import 'package:egypt_toutist_guide/views/screens/home/widgets/popular_places_section.dart';
import 'package:egypt_toutist_guide/views/screens/home/widgets/suggested_places_section.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../controllers/places_bloc/places_bloc.dart';
import 'home_section_title.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<PlacesBloc, PlacesState>(
            builder: (context, state) {
              return HomeSectionTitle(text: 'popular-places'.tr());
            },
          ),
          const PopularPlacesSection(),
          BlocBuilder<PlacesBloc, PlacesState>(
            builder: (context, state) {
              return HomeSectionTitle(text: 'suggested_places'.tr());
            },
          ),
          const SuggestedPlacesSection(),
        ],
      ),
    );
  }
}
