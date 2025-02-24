import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
//---- Custom Google Map Widget -----//

class CustomGoogleMapWidget extends StatelessWidget {
  const CustomGoogleMapWidget({
    super.key,
    this.onMapCreated,
    required this.initialPosition,
    required this.placeName,
  });

  final CameraPosition initialPosition;
  final void Function(GoogleMapController)? onMapCreated;
  final String placeName;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      // redirect the user to Google Maps with the landmark's longitude and latitude to start navigation.
      // using url launcher
      onTap: (argument) => _goToGoogleMaps(
        initialPosition.target.latitude,
        initialPosition.target.longitude,
      ),
      // map position
      initialCameraPosition: initialPosition,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      compassEnabled: false,
      markers: {
        // Add red marker on governorate
        Marker(
          markerId: MarkerId(placeName),
          infoWindow: InfoWindow(
            title: placeName,
          ),
          // When tap on marker:
          // it will redirect the user to Google Maps with the landmark's longitude and latitude.
          // (this is default feature in google map widget).
          position: initialPosition.target,
        ),
      },
      onMapCreated: onMapCreated,
    );
  }

  ///////////////////////////
  // Go to google maps using url launcher
  void _goToGoogleMaps(double latitude, double longitude) async {
    final Uri url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Error launching Google Maps";
    }
  }
}
