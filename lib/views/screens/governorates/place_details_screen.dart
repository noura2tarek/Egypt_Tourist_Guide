import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/app_colors.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import '../../../models/place_model.dart';
import '../../widgets/custom_google_map_widget.dart';
import '../home/widgets/home_section_title.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key, required this.placeModel});

  final PlacesModel placeModel;

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // initialize map render (to solve did not frame error)
  void _initializeMapRenderer() {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  //------- Cairo position -------//
  CameraPosition initialPosition(
      {required double latitude, required double longitude}) {
    return CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(latitude, longitude),
      tilt: 59.440717697143555,
      zoom: 13.151926040649414,
    );
  }

  @override
  void initState() {
    _initializeMapRenderer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeModel.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Place image
          Container(
            width: width,
            height: height * 0.3,
            decoration: BoxDecoration(
              color: AppColors.containerColor,
              image: DecorationImage(
                image: AssetImage(widget.placeModel.image),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          HomeSectionTitle(text: 'Location'.tr()),
          // Goggle map widget shows the place position
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400, // Adjust the height
              child: CustomGoogleMapWidget(
                  placeName: widget.placeModel.name,
                  initialPosition: initialPosition(
                    latitude: widget.placeModel.location.latitude,
                    longitude: widget.placeModel.location.longitude,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  // dispose map controller
  _disposeController() async {
    final GoogleMapController? controller = await _controller.future;
    controller?.dispose();
  }

  // dispose
  @override
  void dispose() {
    super.dispose();
    _disposeController();
  }
}
