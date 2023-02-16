import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:provider/provider.dart';

class SearchAPI {
  final Dio _dio;

  SearchAPI(this._dio);
  CancelToken? _cancelToken;
  final _controller = StreamController<List<Place>?>.broadcast();
  Stream<List<Place>?> get onResults => _controller.stream;

  void search(String query, LatLng at) async {
    try {
      _cancelToken = CancelToken();
      final response = await _dio.get(
        //datos recopilados de Postman
        'https://autosuggest.search.hereapi.com/v1/autosuggest',
        queryParameters: {
          "apiKey": 'mb7ZTT1c2VJkq1ZimRBUhC-IlEPcukrd13WnAvKhG6M',
          "q": query,
          "at": "${at.latitude},${at.longitude}",
          "in": "countryCode:BOL",
          "types": "place,street,city,locality,intersection",
        },
        cancelToken: _cancelToken,
      );
      final results = (response.data['items'] as List)
          .map(
            (e) => Place.fromJson(e),
          )
          .toList();
      _controller.sink.add(results);
      _cancelToken = null;
      //print('📊 finish ok :: $query');
    } on DioError catch (e) {
      //print("⚠️ ${e.runtimeType}");
      // print("❌ error: ${e.error}");
      // print("❌ message: ${e.message}");
      // print("❌ type: ${e.type}");
      if (e.type == DioErrorType.cancel) {
        _controller.sink.add(null);
      }
    }
  }

//funcion que cancela el ingreso erroneo de datos, peticion que aun no temino de ejecutarse
  void cancel() {
    if (_cancelToken != null) {
      _cancelToken!.cancel();
      _cancelToken = null;
    }
  }

  void dispose() {
    cancel();
    _controller.close();
  }
}
