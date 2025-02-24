import 'package:easy_localization/easy_localization.dart';
import 'package:egypt_toutist_guide/views/screens/governorates/widgets/governorate_card.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../controllers/places_bloc/places_bloc.dart';
import '../../../core/app_routes.dart';
import '../../../core/services/firebase_service.dart';
import '../../../data.dart';
import '../../../models/governorate_model.dart';
import '../../../models/place_model.dart';

class GovernoratesScreen extends StatefulWidget {
  const GovernoratesScreen({super.key});

  @override
  State<GovernoratesScreen> createState() => _GovernoratesScreenState();
}

class _GovernoratesScreenState extends State<GovernoratesScreen> {
  List<GovernorateModel> governorateList = [];
  List<GovernorateModel> arabicGovernorateList = [];

  @override
  void initState() {
    super.initState();
    getGovernoratesFromFirebase();
  }

  //--- Get governorates from firebase ---//
  Future<void> getGovernoratesFromFirebase() async {
    var arabicGovernorateListFirebase =
        await FirebaseService.getArabicGovernorates();
    var governorateListFirebase = await FirebaseService.getGovernorates();
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      governorateList = governorateListFirebase;
      arabicGovernorateList = arabicGovernorateListFirebase;
    });
  }

  //--- Get governorates static data ---//
  List<GovernorateModel> _getGovernoratesStaticData() {
    final List<GovernorateModel> staticGovernoratesData = [];

    if (context.locale.toString() == 'ar') {
      staticGovernoratesData.addAll(ARABICGOVERNORATES);
    } else {
      staticGovernoratesData.addAll(GOVERNERATES);
    }
    return staticGovernoratesData;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    //--- Get governorate's places data ---//
    List<PlacesModel> getGovernorateData(String governorateId) {
      final placesBloc = PlacesBloc.get(context);

      return placesBloc.placesV
          .where((place) => place.governorateId == governorateId)
          .toList();
    }

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Skeletonizer(
        enabled: governorateList.isEmpty || arabicGovernorateList.isEmpty,
        child: ListView.separated(
          itemBuilder: (context, index) {
            var governorate =
                arabicGovernorateList.isEmpty || governorateList.isEmpty
                    ? _getGovernoratesStaticData()[index]
                    : context.locale.toString() == 'ar'
                        ? arabicGovernorateList[index]
                        : governorateList[index];
            return GovernorateCard(
              governorate: governorate,
              width: width,
              height: height,
              onTap: () {
                // Go to governorate places
                List<PlacesModel> listOfPlaces =
                    getGovernorateData(governorate.id);

                // Navigate to GovernoratesPlaces with arguments
                Navigator.pushNamed(
                  context,
                  AppRoutes.placesRoute,
                  arguments: {
                    // Pass the governorate object
                    'governorate': governorate,
                    // Pass the list of places
                    'places': listOfPlaces,
                  },
                );
              },
            );
          },
          separatorBuilder: (context, counter) {
            return const SizedBox(
              height: 20,
            );
          },
          itemCount: arabicGovernorateList.isEmpty || governorateList.isEmpty
              ? _getGovernoratesStaticData().length
              : context.locale.toString() == 'ar'
                  ? arabicGovernorateList.length
                  : governorateList.length,
        ),
      ),
    );
  }
}
