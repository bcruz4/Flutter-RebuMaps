import 'dart:async';
import 'package:flutter/material.dart' show ChangeNotifier;

class SearchPlaceController extends ChangeNotifier {
  String _query = '';
  String get query => _query;

  Timer? _debouncer;

  void onQueryChange(String text) {
    _query = text;
    _debouncer?.cancel();
    _debouncer = Timer(
      const Duration(milliseconds: 400),
      () {
        //Tomamos la cantidad minima de 'x' caracteres para llamar a ala API
        if (_query.length >= 3) {
          print('Call To API ☎️');
        }
        //Se cancel la API
        print('Cancel API call 🗙');
      },
    );
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }
}
