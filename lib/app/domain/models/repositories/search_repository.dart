import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

abstract class SearchReposotory {
  Future<List<Place>?> search(String query, LatLng at);
}
