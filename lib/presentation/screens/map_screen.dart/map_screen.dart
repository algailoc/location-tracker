import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/general/custom_app_bar.dart';

class MapScreen extends StatelessWidget {
  final double lat, long;

  const MapScreen({required this.lat, required this.long, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Tracker App',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: GoogleMap(
          markers: {
            Marker(
                markerId: const MarkerId('user_marker'),
                position: LatLng(lat, long))
          },
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition:
              CameraPosition(target: LatLng(lat, long), zoom: 12),
        ),
      ),
    );
  }
}
