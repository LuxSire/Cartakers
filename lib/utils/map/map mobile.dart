import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xm_frontend/data/models/object_model.dart';

class MapScreen extends StatefulWidget {
  final ObjectModel object;

  const MapScreen({super.key, required this.object});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;

  // Async function to get initial camera position
  static Future<CameraPosition> _initialPositionAsync(ObjectModel object) async {
    if (object.latitude == null || object.longitude == null) {
      debugPrint('Coordinates are null, attempting to fetch from address...');
      await object.getCoordinatesFromAddress();
    }
    return CameraPosition(
      target: LatLng(object.latitude ?? 0.0, object.longitude ?? 0.0),
      zoom: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location of ${widget.object.name ?? "Object"}'),
      ),
      body: FutureBuilder<CameraPosition>(
        future: _initialPositionAsync(widget.object),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Unable to get location'));
          }
          final initialPosition = snapshot.data!;
          return GoogleMap(
            initialCameraPosition: initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: {
              Marker(
                markerId: const MarkerId('object_marker'),
                position: initialPosition.target,
                infoWindow: InfoWindow(title: widget.object.name ?? "Object"),
                icon: BitmapDescriptor.defaultMarker,
              ),
            },
          );
        },
      ),
    );
  }
}