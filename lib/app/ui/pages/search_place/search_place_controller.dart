import 'dart:async';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:google_maps/app/domain/models/repositories/search_repository.dart';
import 'package:google_maps/app/helpers/current_position.dart';

class SearchPlaceController extends ChangeNotifier {
  final SearchReposotory _searchReposotory;
  String _query = '';
  SearchPlaceController(this._searchReposotory);
  String get query => _query;

  Timer? _debouncer;

  void onQueryChanged(String text) {
    _query = text;
    _debouncer?.cancel();
    _debouncer = Timer(
      const Duration(milliseconds: 500),
      () async {
        if (_query.length >= 3) {
          print("📊 Call to API: $query");
          final currentPosition = CurrentPosition.i.value;
          if (currentPosition != null) {
            final results =
                await _searchReposotory.search(_query, currentPosition);
            print("📊 results ${results?.length}");
          }
        } else {
          print("📊cancel API call");
          //clearQuery();
        }
      },
    );
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }
}
