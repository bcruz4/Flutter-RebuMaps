import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_controller.dart';
import 'package:google_maps/app/ui/utils/distance_format.dart';
import 'package:provider/provider.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SearchPlaceController>();
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
          onTap: () {
            controller.pickPlace(place);
            FocusScope.of(context).unfocus();
          },
        );
      },
      itemCount: places.length,
    );
  }
}
