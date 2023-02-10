import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../home_controller.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (_, controller, gpsMessageWidgwet) {
        if (!controller.gpsEnabled) {
          return gpsMessageWidgwet!;
        }

        final initialCameraPosition = CameraPosition(
          target: LatLng(
            controller.initialPosition!.longitude,
            controller.initialPosition!.longitude,
          ),
          zoom: 15,
        );

        return GoogleMap(
          markers: controller.markers,
          polylines: controller.polylines,
          polygons: controller.polygons,
          onMapCreated: controller.onMapCreated,
          initialCameraPosition: initialCameraPosition,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          scrollGesturesEnabled: true,
          zoomControlsEnabled: true,
          mapType: MapType.normal,
          compassEnabled: false,
          onTap: controller.onTap,
        );
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'To use our app we need the access to your location, \n bo you must enable the gps',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final controller = context.read<HomeController>();
                controller.turnOnGPS();
              },
              child: Text('Turn on GPS'),
            )
          ],
        ),
      ),
    );
  }
}
