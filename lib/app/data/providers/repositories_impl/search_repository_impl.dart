import 'package:google_maps/app/data/providers/remote/search_api.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/domain/models/repositories/search_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchRepositoryImpl implements SearchReposotory {
  final SearchAPI _searchAPI;

  SearchRepositoryImpl(this._searchAPI);

  @override
  Future<List<Place>?> search(String query, LatLng at) {
    return _searchAPI.search(query, at);
  }
}
