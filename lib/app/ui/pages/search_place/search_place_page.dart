import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/data/providers/remote/search_api.dart';
import 'package:google_maps/app/data/providers/repositories_impl/search_repository_impl.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/ui/pages/home/widgets/search_app_bar.dart';
import 'package:google_maps/app/ui/pages/home/widgets/search_inputs.dart';
import 'package:google_maps/app/ui/pages/home/widgets/search_results.dart';
import 'package:google_maps/app/ui/pages/search_place/widgets/pick_from_map_buttom.dart';
import 'package:provider/provider.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_controller.dart';

abstract class SearchResponse {}

class PickFromMapResponse extends SearchResponse {
  final bool isOrigin;
  PickFromMapResponse(this.isOrigin);
}

class OriginAndDestinationResponse extends SearchResponse {
  final Place origin, destination;
  OriginAndDestinationResponse(this.origin, this.destination);
}

class SearchPlacePage extends StatelessWidget {
  final Place? initialOrigin, initialDestination;
  final bool hasOriginFocus;

  const SearchPlacePage({
    super.key,
    this.initialOrigin,
    this.initialDestination,
    required this.hasOriginFocus,
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
        hasOriginFocus: hasOriginFocus,
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
                PickFromMapButtom(),
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
