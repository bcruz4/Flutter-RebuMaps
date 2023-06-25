import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeState {
  final bool loading, gpsEnable, fetching;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines;
  final LatLng? initialPosition;
  final Place? origin, destination;

  HomeState({
    required this.loading,
    required this.gpsEnable,
    required this.markers,
    required this.polylines,
    required this.initialPosition,
    required this.origin,
    required this.destination,
    required this.fetching,
  });

  static HomeState get initialState => HomeState(
        loading: true,
        gpsEnable: false,
        markers: {},
        polylines: {},
        initialPosition: null,
        origin: null,
        destination: null,
        fetching: false,
      );

  //Copia del estado pero con ciertas propiedades modificadas
  HomeState copyWith({
    bool? loading,
    bool? gpsEnable,
    bool? fetching,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polylines,
    LatLng? initialPosition,
    Place? origin,
    Place? destination,
  }) {
    return HomeState(
      // ignore: unnecessary_this
      fetching: fetching ?? this.fetching,
      loading: loading ?? this.loading,
      gpsEnable: gpsEnable ?? this.gpsEnable,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      initialPosition: initialPosition ?? this.initialPosition,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
    );
  }

  HomeState clearOriginAndDestination(bool fetching) {
    return HomeState(
      fetching: fetching,
      loading: loading,
      gpsEnable: gpsEnable,
      markers: {},
      polylines: {},
      initialPosition: initialPosition,
      origin: null,
      destination: null,
    );
  }
}
