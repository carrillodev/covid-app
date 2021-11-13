import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({Key? key}) : super(key: key);

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(25.5446328, -103.5174302),
    zoom: 12.4746,
  );

  Marker markerUjed = const Marker(
    markerId: MarkerId('ujed'),
    infoWindow: InfoWindow(title: 'UJED'),
    position: LatLng(25.5584436, -103.5108516),
  );

  Marker markerHospitalLerdo = const Marker(
    markerId: MarkerId('hospitalLerdo'),
    infoWindow: InfoWindow(title: 'Hospital Gral. Lerdo'),
    position: LatLng(25.5328062, -103.5305184),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        markers: {markerUjed, markerHospitalLerdo},
      ),
    );
  }
}
