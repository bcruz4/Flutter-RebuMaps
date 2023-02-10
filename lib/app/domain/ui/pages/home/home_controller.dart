import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/app/domain/ui/utils/map_style.dart';
import 'package:google_maps/helpers/image_to_byte.dart'; // llama al metodo para reescalar el marcador
//import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

//import '../../utils/map_style.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylines = {};
  final Map<PolygonId, Polygon> _polyligons = {};

  Set<Marker> get markers => _markers.values.toSet();
  Set<Polyline> get polylines => _polylines.values.toSet();
  Set<Polygon> get polygons => _polyligons.values.toSet();

  late BitmapDescriptor _carPin;

  final _markerController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markerController.stream;
  String _polylineId = '0';
  String _polygoneId = '0';

  Position? _initialPosition, _lastPosition;
  Position? get initialPosition => _initialPosition;
  //Position? get initialPosition => _initialPosition;

  //Optimizar la llamada al metodo para reescalar el marcador

  bool _loading = true;
  bool get loading => _loading;

  late bool _gpsEnabled; // late para inicializar su valor despues
  bool get gpsEnabled => _gpsEnabled;

  StreamSubscription? _gpsSubscription, _positionSuscription;
  GoogleMapController? _mapController;

  HomeController() {
    //print('🌈');
    // -- esta es la llamada da la imagen de manera local
    //imageToBytes('assets/hollow.png', width: 130).then
    _init();
  }

  // ignore: non_constant_identifier_names
  Future<void> _init() async {
    _carPin = BitmapDescriptor.fromBytes(
        await imageToBytes('assets/car-pin.png', width: 40));
    _gpsEnabled = await Geolocator.isLocationServiceEnabled();
    _loading = false;
    //getServiceStatusStream().listen , mustra un popUp para activar el gps para mejor experiencia
    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) async {
        _gpsEnabled = status == ServiceStatus.enabled;
        if (_gpsEnabled) {
          _initlocationUpdates();
        }
      },
    );
    //final initialPosition = await Geolocator.ge CurrentPosition();
    //print('initialPototion $initialPosition');
    //await _getInitialPotition();
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
        _setMyPositionMarker(position);
        if (initialized) {
          notifyListeners();
        }
        if (!initialized) {
          _setInitialPotition(position);
          initialized = true;
          notifyListeners();
        }

        if (_mapController != null) {
          final zoom = await _mapController!.getZoomLevel();
          //mover el mapa a la ubicacion actual
          final cameraUpdate = CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            zoom,
          );
          _mapController!.animateCamera(cameraUpdate);
        }
      },
      onError: (e) {
        print("❌ onError ${e.runtimeType}");
        if (e is LocationServiceDisabledException) {
          _gpsEnabled = false;
          notifyListeners();
        }
        notifyListeners();
      },
    );
  }

  //Definimos las posicion inicial.
  _setInitialPotition(Position position) {
    if (_gpsEnabled && _initialPosition == null) {
      //_initialPosition = await Geolocator.getLastKnownPosition();
      //_initialPosition = Geolocator.getCurrentPosition();
      //print('initialPototion $initialPosition');
      _initialPosition = position;
    }
  }

  void _setMyPositionMarker(Position position) {
    double rotation = 0;
    if (_lastPosition != null) {
      rotation = Geolocator.bearingBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
    }
    const markerId = MarkerId('my-position');
    final marker = Marker(
      markerId: markerId,
      position: LatLng(position.latitude, position.longitude),
      icon: _carPin,
      anchor: const Offset(0.5, 0.5),
      rotation: rotation,
    );
    _markers[markerId] = marker;
    _lastPosition = position;
  }

  void onMapCreated(GoogleMapController controller) {
    //Modificar el estilo del mapa
    controller.setMapStyle(mapStyle);
    _mapController = controller;
  }

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  void newPolyline() {
    _polylineId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void newPolygone() {
    _polygoneId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void onTap(LatLng position) async {
    // final PolylineId polylineId = PolylineId(_polylineId);
    // late Polyline polyline;
    // if (_polylines.containsKey(polylineId)) {
    //   final tmp = _polylines[polylineId]!;
    //   polyline = tmp.copyWith(
    //     pointsParam: [...tmp.points, position],
    //   );
    // } else {
    //   //'cada vez que se genere un polyline se le asignara un color nuevo'
    //   final color = Colors.primaries[_polylines.length];
    //   polyline = Polyline(
    //     polylineId: polylineId,
    //     points: [position],
    //     width: 5,
    //     color: color,
    //     startCap: Cap.roundCap,
    //     endCap: Cap.roundCap,
    //   );
    // }
    // _polylines[polylineId] = polyline;
    // notifyListeners();
    final polygonId = PolygonId(_polygoneId);
    late Polygon polygon;
    if (_polyligons.containsKey(polygonId)) {
      final tmp = _polyligons[polygonId]!;
      polygon = tmp.copyWith(
        pointsParam: [...tmp.points, position],
      );
    } else {
      final color = Colors.primaries[_polyligons.length];
      polygon = Polygon(
        polygonId: polygonId,
        points: [position],
        strokeWidth: 4,
        fillColor: color.withOpacity(0.4),
      );
    }
    _polyligons[polygonId] = polygon;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionSuscription
        ?.cancel(); // cuando se destruya la pagina se deja de escucahr los cambis en el dispositivo
    _gpsSubscription?.cancel();
    _markerController.close();
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }
}
