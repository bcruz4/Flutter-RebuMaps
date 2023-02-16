import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_maps/app/data/providers/remote/search_api.dart';
import 'package:google_maps/app/data/providers/repositories_impl/search_repository_impl.dart';

import 'package:provider/provider.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_controller.dart';

class SearchPlacePage extends StatelessWidget {
  const SearchPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchPlaceController(
        SearchRepositoryImpl(
          SearchAPI(Dio()),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Builder(
            builder: (context) {
              return CupertinoTextField(
                onChanged: context.read<SearchPlaceController>().onQueryChanged,
              );
            },
          ),
        ),
      ),
    );
  }
}
