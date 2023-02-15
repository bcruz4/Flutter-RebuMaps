import 'package:dio/dio.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchApi {
  final Dio _dio;

  SearchApi(this._dio);

  //datos recopilados de Postman
  Future<List<Place>?> search(String query, LatLng at) async {
    try {
      final response = await _dio.get(
        'https://autosuggest.search.hereapi.com',
        queryParameters: {
          'apiKey': 'mb7ZTT1c2VJkq1ZimRBUhC-IlEPcukrd13WnAvKhG6M',
          'q': query,
          'at': '${at.latitude}, ${at.longitude}',
          'in': 'countryCode:BOL',
          'types': 'place,city,locality,intersection',
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
