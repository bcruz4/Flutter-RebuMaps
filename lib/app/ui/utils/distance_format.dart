//devueleve el dato de distancia en kilometros uperando los 1000 metros
String distanceFormat(int valueInMeters) {
  if (valueInMeters >= 1000) {
    return '${(valueInMeters / 1000).toStringAsFixed(1)}\nkm';
  }
  return '$valueInMeters\nm';
}
