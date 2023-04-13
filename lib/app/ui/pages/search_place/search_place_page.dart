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
        appBar: const SearchAppBar(),
        backgroundColor: Colors.white,
        body: GestureDetector(
          //FocusScop: hace que al precionar fura del formulario se minimice el teclado
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: const [
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
