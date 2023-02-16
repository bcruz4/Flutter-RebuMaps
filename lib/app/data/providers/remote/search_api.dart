import 'package:dio/dio.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchAPI {
  final Dio _dio;

  SearchAPI(this._dio);

  //datos recopilados de Postman
  Future<List<Place>?> search(String query, LatLng at) async {
    try {
      final response = await _dio.get(
        'https://autosuggest.search.hereapi.com/v1/autosuggest',
        queryParameters: {
          "apiKey": 'mb7ZTT1c2VJkq1ZimRBUhC-IlEPcukrd13WnAvKhG6M',
          "q": query,
          "at": "${at.latitude},${at.longitude}",
          "in": "countryCode:BOL",
          "types": "place,street,city,locality,intersection",
        },
      );
      return (response.data['items'] as List)
          .map(
            (e) => Place.fromJson(e),
          )
          .toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
