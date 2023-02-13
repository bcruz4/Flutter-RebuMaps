import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/domain/ui/pages/home/widgets/where_are_you_going_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controller/home_controller.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (_, controller, gpsMessageWidgwet) {
        final state = controller.state;
        if (!state.gpsEnable) {
          return gpsMessageWidgwet!;
        }

        final initialCameraPosition = CameraPosition(
          target: LatLng(
            state.initialPosition!.longitude,
            state.initialPosition!.longitude,
          ),
          zoom: 15,
        );

        return Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              markers: state.markers.values.toSet(),
              polylines: state.polylines.values.toSet(),
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: initialCameraPosition,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              compassEnabled: false,
              zoomControlsEnabled: false,
              //padding: EdgeInsets.only(bottom: 100),
            ),
            const WhereAreYouGoingButton(),
          ],
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
