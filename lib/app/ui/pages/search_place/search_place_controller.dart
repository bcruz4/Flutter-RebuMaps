import 'dart:async';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter/widgets.dart';

import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/domain/models/repositories/search_repository.dart';
import 'package:google_maps/app/helpers/current_position.dart';

class SearchPlaceController extends ChangeNotifier {
  final SearchReposotory _searchReposotory;
  String _query = '';
  String get query => _query;

  late StreamSubscription _subscription;

  List<Place>? _places = [];
  List<Place>? get places => _places;

  Place? _origin, _destination;

  //variables para ser asignadas al destino y origen de la app
  Place? get origin => _origin;
  Place? get destination => _destination;

  final originFocusNode = FocusNode();
  final destinationFocusNode = FocusNode();

  final originController = TextEditingController();
  final destinationController = TextEditingController();

  bool _originHasFocus = true;

  //muestra el numero de resultados en consola
  SearchPlaceController(
    this._searchReposotory, {
    required Place? origin,
    required Place? destination,
  }) {
    print("🥶 origin!=null ${origin != null}");
    _origin = origin;
    _destination = destination;

    if (_origin != null) {
      originController.text = _origin!.title;
    }
    if (_destination != null) {
      destinationController.text = _destination!.title;
    }

    _subscription = _searchReposotory.onResults.listen(
      (results) {
        //print('📊 results ${results?.length}, $query');
        _places = results;
        notifyListeners();
      },
    );
    //para saber que campo tiene el punto de atencion
    originFocusNode.addListener(() {
      if (originFocusNode.hasFocus && !_originHasFocus) {
        _onOriginFocusNodeChanged(true);
        //limpiar el campo de texto si no se completa la busqueda de origen o 'origen'
      } else if (!originFocusNode.hasFocus && _origin == null) {
        originController.text = '';
      }
    });

    destinationFocusNode.addListener(() {
      if (destinationFocusNode.hasFocus && _originHasFocus) {
        _onOriginFocusNodeChanged(false);
      }
      //limpiar el campo de texto si no se completa la busqueda de origen o 'destino'
      else if (!destinationFocusNode.hasFocus && _destination == null) {
        destinationController.text = '';
      }
    });
  }

  Timer? _debouncer;

  void _onOriginFocusNodeChanged(bool hasFocus) {
    _originHasFocus = hasFocus;
    _places = [];
    _query = '';
    notifyListeners();
  }

  void onQueryChanged(String text) {
    _query = text;
    _debouncer?.cancel();
    _debouncer = Timer(
      const Duration(milliseconds: 500),
      () {
        if (_query.length >= 3) {
          print("📊 Call to API: $query");
          final currentPosition = CurrentPosition.i.value;
          if (currentPosition != null) {
            _searchReposotory.cancel();
            _searchReposotory.search(_query, currentPosition);
            //print("📊 results ${results?.length}");
          }
        } else {
          print("📊cancel API call");
          clearQuery();
        }
      },
    );
  }

  void clearQuery() {
    _searchReposotory.cancel();
    _places = [];
    if (_originHasFocus) {
      _origin = null;
    } else {
      _destination = null;
    }
    notifyListeners();
  }

  void pickPlace(Place place) {
    if (_originHasFocus) {
      _origin = place;
      originController.text = place.title;
    } else {
      _destination = place;
      destinationController.text = place.title;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    originFocusNode.dispose();
    destinationFocusNode.dispose();
    _debouncer?.cancel();
    _subscription.cancel();
    _searchReposotory.dispose();
    super.dispose();
  }
}
