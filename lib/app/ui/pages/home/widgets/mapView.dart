import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/home/widgets/buttons/cancel_pick_from_map.dart';
import 'package:google_maps/app/ui/pages/home/widgets/fixed_marker.dart';
import 'package:google_maps/app/ui/pages/home/widgets/origin_and_destination.dart';
import 'package:google_maps/app/ui/pages/home/widgets/buttons/where_are_you_going_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controller/home_controller.dart';
import 'buttons/confirm_from_map_buttom.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    // aca asignamos la variable que nos ayuda a corregir la vista del mapa por debajo de timeline_tile
    // recuperamos al sdimensiones de nuetra pantalla
    final size = MediaQuery.of(context).size;
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
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              compassEnabled: false,
              zoomControlsEnabled: false,
              //agrega espacion sobre la visualizacion de la ruta
              padding: EdgeInsets.only(top: size.height * 0.25),
            ),
            const WhereAreYouGoingButton(),
            const OriginAndDestination(),
            const FixedMarker(
              text: "Plaza del Estudiante",
            ),
            const CancelPickFromMapButton(),
            const ConfirmFromMapButton(),
          ],
        );
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
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
