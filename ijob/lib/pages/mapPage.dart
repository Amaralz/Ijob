import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mappage extends StatefulWidget {
  final LatLng initial;
  final LatLng userp;

  Mappage({required this.initial, required this.userp});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close_rounded, color: Colors.black),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: widget.initial, zoom: 13),
        markers: {
          Marker(
            markerId: MarkerId("o"),
            position: widget.initial,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
          Marker(
            markerId: MarkerId("y"),
            position: widget.userp,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        },
      ),
    );
  }
}
