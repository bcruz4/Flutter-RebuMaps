import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeState {
  final bool loading, gpsEnable;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines;

  HomeState({
    required this.loading,
    required this.gpsEnable,
    required this.markers,
    required this.polylines,
  });

  static HomeState get initialState => HomeState(
        loading: true,
        gpsEnable: false,
        markers: {},
        polylines: {},
      );

  //Copia del estado pero con ciertas propiedades modificadas
  HomeState copyWith({
    bool? loading,
    bool? gpsEnable,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polylines,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      gpsEnable: gpsEnable ?? this.gpsEnable,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
    );
  }
}
