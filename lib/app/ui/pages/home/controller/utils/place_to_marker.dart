import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/ui/pages/home/widgets/custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

//MARCADOR PERSONALIZADO UTILIZANDO CUSTOM_MARKER.DART
Future<BitmapDescriptor> placeToMarker(Place place, int? duration) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  //cambia el tama;o del marcador personalizado
  const size = ui.Size(350, 80);

  final customMarker = MyCustomMarker(
    label: place.title,
    duration: duration,
  );
  customMarker.paint(canvas, size);
  final picture = recorder.endRecording();
  final image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  final byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  final bytes = byteData!.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(bytes);
}
