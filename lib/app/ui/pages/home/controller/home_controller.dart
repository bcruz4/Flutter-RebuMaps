import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/app/domain/ui/pages/home/controller/home_state.dart';
import 'package:google_maps/app/domain/ui/utils/map_style.dart';
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

  StreamSubscription? _gpsSubscription, _positionSuscription;
  GoogleMapController? _mapController;

  HomeController() {
    _init();
  }

  // ignore: non_constant_identifier_names
  Future<void> _init() async {
    final gpsEnabled = await Geolocator.isLocationServiceEnabled();
    _state = state.copyWith(gpsEnable: gpsEnabled);
    //getServiceStatusStream().listen , mustra un popUp para activar el gps para mejor experiencia
    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) async {
        final _gpsEnabled = status == ServiceStatus.enabled;
        if (gpsEnabled) {
          _state = state.copyWith(gpsEnable: gpsEnabled);
          _initlocationUpdates();
        }
      },
    );
    _initlocationUpdates();
  }

  Future<void> _initlocationUpdates() async {
    bool initialized = false;
    await _positionSuscription?.cancel();
    _positionSuscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ).listen(
      (position) async {
        //print('📍 $position');

        if (!initialized) {
          _setInitialPotition(position);
          initialized = true;
          notifyListeners();
          //print('😋');
        }
      },
      onError: (e) {
        print("❌ onError ${e.runtimeType}");
        if (e is LocationServiceDisabledException) {
          _state = state.copyWith(gpsEnable: false);
          notifyListeners();
        }
        //notifyListeners();
      },
    );
  }

  //Definimos las posicion inicial.
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

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  @override
  void dispose() {
    _positionSuscription
        ?.cancel(); // cuando se destruya la pagina se deja de escucahr los cambis en el dispositivo
    _gpsSubscription?.cancel();
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }
}
