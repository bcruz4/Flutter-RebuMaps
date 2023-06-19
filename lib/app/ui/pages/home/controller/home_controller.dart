import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/app/data/providers/local/geolocator_wrapper.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/domain/models/repositories/routes_repository.dart';
import 'package:google_maps/app/helpers/current_position.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_state.dart';
import 'package:google_maps/app/ui/pages/home/controller/utils/set_route.dart';
import 'package:google_maps/app/ui/pages/home/controller/utils/set_zoom.dart';
import 'package:google_maps/app/ui/pages/home/widgets/circle_marker.dart';
import 'package:google_maps/app/ui/utils/fit_map.dart';
import 'package:google_maps/app/ui/utils/map_style.dart';
//import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import '../../utils/map_style.dart';

class HomeController extends ChangeNotifier {
  HomeState _state = HomeState.initialState;
  HomeState get state => _state;

  late BitmapDescriptor _carPin;

  //Position? _initialPosition;
  //Position? get initialPosition => _initialPosition;
  //Position? get initialPosition => _initialPosition;

  StreamSubscription? _gpsSubscription, _positionSubscription;
  GoogleMapController? _mapController;
  final GeolocatorWrapper _geolocator;
  final RoutesRepository _routesRepository;

  BitmapDescriptor? _dotMarker;

  HomeController(this._geolocator, this._routesRepository) {
    _init();
  }

  // ignore: non_constant_identifier_names
  Future<void> _init() async {
    final gpsEnabled = await _geolocator.isLocationServiceEnabled;
    _state = state.copyWith(gpsEnable: gpsEnabled);

    _gpsSubscription = _geolocator.onServiceEnabled.listen(
      (enabled) {
        _state = state.copyWith(gpsEnable: enabled);
        notifyListeners();
      },
    );

    _initlocationUpdates();
    _dotMarker = await getDotMarker();
  }

  Future<void> _initlocationUpdates() async {
    bool initialized = false;
    _positionSubscription = _geolocator.onLocationUpdates.listen(
      (position) {
        if (!initialized) {
          _setInitialPotition(position);
          initialized = true;
          notifyListeners();
          //print('😋');
        }
        CurrentPosition.i.setValue(
          LatLng(position.latitude, position.longitude),
        );
      },
    );
  }

  //Definimos las posicion inicial del dispositivo.
  void _setInitialPotition(Position position) {
    if (state.gpsEnable && state.initialPosition == null) {
      _state = state.copyWith(
        initialPosition: LatLng(
          position.latitude,
          position.longitude,
        ),
        loading: false,
      );
      //_initialPosition = position;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    //Modificar el estilo del mapa
    controller.setMapStyle(mapStyle);
    _mapController = controller;
  }

  void setOriginDestination(Place origin, Place destination) async {
    final routes = await _routesRepository.get(
      origin: origin.position,
      destination: destination.position,
    );

    if (routes != null && routes.isNotEmpty) {
      _state = await setRouteAndMarkers(
        state: state,
        routes: routes,
        origin: origin,
        destination: destination,
        dot: _dotMarker!,
      );

      await _mapController?.animateCamera(
        fitMap(
          origin.position,
          destination.position,
          // da un borde o espacio entre el marcador y el borde de la pantalla
          padding: 80,
        ),
      );
      notifyListeners();
    }
  }

  Future<void> turnOnGPS() => _geolocator.openAppSettings();

  Future<void> zoomIn() async {
    if (_mapController != null) {
      await setZoom(_mapController!, true);
    }
  }

  //SACAR EL PUNTO MEDIO DE LA PANTALLA
  Future<void> zoomOut() async {
    if (_mapController != null) {
      await setZoom(_mapController!, false);
    }
  }

  void clearData() {
    _state = _state.clearOriginAndDestination();
    notifyListeners();
  }

  @override
  void dispose() {
    // cuando se destruya la pagina se deja de escucahr los cambios en el dispositivo
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }
}
