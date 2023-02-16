import 'dart:async';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:google_maps/app/domain/models/repositories/search_repository.dart';
import 'package:google_maps/app/helpers/current_position.dart';

class SearchPlaceController extends ChangeNotifier {
  final SearchReposotory _searchReposotory;
  String _query = '';
  late StreamSubscription _subscription;
  SearchPlaceController(this._searchReposotory) {
    _subscription = _searchReposotory.onResults.listen((results) {
      print('📊 results ${results?.length}, $query');
    });
  }

  String get query => _query;

  Timer? _debouncer;

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
          _searchReposotory.cancel();
          //clearQuery();
        }
      },
    );
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    _subscription.cancel();
    _searchReposotory.dispose();
    super.dispose();
  }
}
