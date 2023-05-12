import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/app/data/providers/local/geolocator_wrapper.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/domain/models/repositories/routes_repository.dart';
import 'package:google_maps/app/helpers/current_position.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_state.dart';
import 'package:google_maps/app/ui/pages/home/widgets/custom_marker.dart';
import 'package:google_maps/app/ui/utils/fit_map.dart';
import 'package:google_maps/app/ui/utils/map_style.dart';
import 'package:google_maps/helpers/image_to_byte.dart';
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
      final markersCopy = {
        ..._state.markers
      }; // final copy = Map<MarkerId, Marker>.from(_state.markers); ES EQUIVALENTE A ESTO!!
      const originId = MarkerId('origin');
      const destinationId = MarkerId('destination');

      final route = routes.first;

      final originIcon = await _placeToMarker(origin, null);
      final destinationIcon = await _placeToMarker(
        destination,
        route.duration,
      );
      //inicializando las variales para los marcadores origen
      final originMarker = Marker(
        markerId: originId,
        position: origin.position,
        icon: originIcon,
        //etiqueta flotante
        // infoWindow: InfoWindow(
        //   title: origin.title,
        // ),
      );
      //inicializando las variales para los marcadores destino
      final destinationMarker = Marker(
        markerId: destinationId,
        position: destination.position,
        icon: destinationIcon,
        //etiqueta flotante
        // infoWindow: InfoWindow(
        //   title: destination.title,
        // ),
      );

      markersCopy[originId] = originMarker;
      markersCopy[destinationId] = destinationMarker;
      final polylinesCopy = {..._state.polylines};
      const polylineId = PolylineId('route');
      final polyline = Polyline(
        polylineId: polylineId,
        points: route.points,
        width: 2,
      );
      polylinesCopy[polylineId] = polyline;
      _state = _state.copyWith(
        origin: origin,
        destination: destination,
        markers: markersCopy,
        polylines: polylinesCopy,
      );
      await _mapController?.animateCamera(
        fitMap(
          origin.position,
          destination.position,
          // da un borde o espacio entre el marcador y el borde de la pantalla
          padding: 100,
        ),
      );
      notifyListeners();
    }
  }

  Future<void> turnOnGPS() => _geolocator.openAppSettings();

  Future<void> zoomIn() => _zoom(true);

  //SACAR EL PUNTO MEDIO DE LA PANTALLA
  Future<void> zoomOut() => _zoom(false);

  Future<void> _zoom(bool zoomIn) async {
    if (_mapController != null) {
      double zoom = await _mapController!.getZoomLevel();
      if (!zoomIn) {
        if (zoom - 1 <= 0) {
          return;
        }
      }

      zoom = zoomIn ? zoom + 1 : zoom - 1;

      final bounds = await _mapController!.getVisibleRegion();
      final northeast = bounds.northeast;
      final southwest = bounds.southwest;
      final center = LatLng(
        (northeast.latitude + southwest.latitude) / 2,
        (northeast.longitude + southwest.longitude) / 2,
      );
      final cameraUpdate = CameraUpdate.newLatLngZoom(center, zoom);
      await _mapController!.animateCamera(cameraUpdate);
    }
  }

  //MARCADOR PERSONALIZADO UTILIZANDO CUSTOM_MARKER.DART
  Future<BitmapDescriptor> _placeToMarker(Place place, int? duration) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    //cambia el tama;o del marcador personalizado
    const size = ui.Size(350, 80);

    final customMarker = MyCustomMarker(
      label: place.title,
      duration: duration,
    );
    customMarker.paint(canvas, size);
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final bytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
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
