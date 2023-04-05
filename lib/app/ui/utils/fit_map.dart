import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

CameraUpdate fitMap(LatLng origin, LatLng destination, {double padding = 20}) {
  //calcular las cordenadas de un marcador que estan mas a la izquierda o a la derecha.
  final left = math.min(origin.latitude, destination.latitude);
  final rigth = math.max(origin.latitude, destination.latitude);
  final top = math.min(origin.longitude, destination.longitude);
  final bottom = math.max(origin.longitude, destination.longitude);

  //ESTA FUNCIONALIDAD FUNCIONA EN IOS Y ANDROID
  final bounds = LatLngBounds(
    southwest: LatLng(left, top),
    northeast: LatLng(rigth, bottom),
  );

  return CameraUpdate.newLatLngBounds(bounds, padding);
}
