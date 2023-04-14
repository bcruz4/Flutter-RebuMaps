import 'package:geolocator/geolocator.dart' show Position;
import 'package:google_maps/app/domain/models/route.dart';

abstract class RoutesRepository {
  Future<List<Route>?> get({
    required Position origin,
    required Position destination,
  });
}
