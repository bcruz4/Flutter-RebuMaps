import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/helpers/current_position.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_state.dart';
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
        CurrentPosition.i.setValue(
          LatLng(position.latitude, position.longitude),
        );
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

  void setOriginDestination(Place origin, Place destination) {
    final copy = {
      ..._state.markers
    }; // final copy = Map<MarkerId, Marker>.from(_state.markers); ES EQUIVALENTE A ESTO!!
    const originId = MarkerId('origin');
    const destinationId = MarkerId('destination');

    //inicializando las variales para los marcadores origen
    final originMarker = Marker(
      markerId: originId,
      position: origin.position,
      //etiqueta flotante
      infoWindow: InfoWindow(
        title: origin.title,
      ),
    );
    //inicializando las variales para los marcadores destino
    final destinationMarker = Marker(
      markerId: destinationId,
      position: destination.position,
      //etiqueta flotante
      infoWindow: InfoWindow(
        title: destination.title,
      ),
    );

    copy[originId] = originMarker;
    copy[destinationId] = destinationMarker;

    _state = _state.copyWith(
      origin: origin,
      destination: destination,
      markers: copy,
    );
    notifyListeners();
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
