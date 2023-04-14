import 'package:geolocator/geolocator.dart' show Position;
import 'package:google_maps/app/data/providers/remote/routes_api.dart';
import 'package:google_maps/app/domain/models/repositories/routes_repository.dart';
import 'package:google_maps/app/domain/models/route.dart';

class RoutesRepositoryImpl implements RoutesRepository {
  final RoutesAPI _routesAPI;

  RoutesRepositoryImpl(this._routesAPI);

  @override
  Future<List<Route>?> get({
    required Position origin,
    required Position destination,
  }) {
    return _routesAPI.get(origin: origin, destination: destination);
  }
}
