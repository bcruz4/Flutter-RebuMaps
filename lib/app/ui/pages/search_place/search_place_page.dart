import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/data/providers/remote/search_api.dart';
import 'package:google_maps/app/data/providers/repositories_impl/search_repository_impl.dart';
import 'package:google_maps/app/ui/pages/search_place/widgets/search_input.dart';
import 'package:google_maps/app/ui/utils/distance_format.dart';
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
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black87,
          ),
          elevation: 0,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Builder(
                builder: (context) => Column(
                  children: [
                    SearchInput(
                      placeholder: 'origin',
                      onChanged:
                          context.read<SearchPlaceController>().onQueryChanged,
                    ),
                    SearchInput(
                      placeholder: 'destination',
                      onChanged:
                          context.read<SearchPlaceController>().onQueryChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Consumer<SearchPlaceController>(
                  builder: (_, controller, __) {
                    final places = controller.places;
                    if (places == null) {
                      return const Center(
                        child: Text('Error'),
                      );
                    } else if (places.isEmpty && controller.query.length >= 3) {
                      return const Center(
                        child: Text('Empty'),
                      );
                    }
                    return ListView.builder(
                      itemBuilder: (_, index) {
                        final place = places[index];
                        return ListTile(
                          leading: Text(distanceFormat(place.distance)),
                          title: Text(place.title),
                          subtitle: Text(place.address),
                        );
                      },
                      itemCount: places.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
