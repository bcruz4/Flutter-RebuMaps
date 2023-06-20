import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/data/providers/remote/search_api.dart';
import 'package:google_maps/app/data/providers/repositories_impl/search_repository_impl.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/ui/pages/home/widgets/search_app_bar.dart';
import 'package:google_maps/app/ui/pages/home/widgets/search_inputs.dart';
import 'package:google_maps/app/ui/pages/home/widgets/search_results.dart';
import 'package:provider/provider.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_controller.dart';

class SearchResponse {
  final Place origin, destinmation;
  SearchResponse(this.origin, this.destinmation);
}

class SearchPlacePage extends StatelessWidget {
  final Place? initialOrigin, initialDestination;
  const SearchPlacePage({
    super.key,
    this.initialOrigin,
    this.initialDestination,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchPlaceController(
        SearchRepositoryImpl(
          SearchAPI(Dio()),
        ),
        origin: initialOrigin,
        destination: initialDestination,
      ),
      child: Scaffold(
        appBar: const SearchAppBar(),
        backgroundColor: Colors.white,
        body: GestureDetector(
          //FocusScop: hace que al precionar fura del formulario se minimice el teclado
          onTap: () => FocusScope.of(context).unfocus(),
          child: const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SearchInputs(),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SearchResults(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
