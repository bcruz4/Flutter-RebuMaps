import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show BuildContext, MaterialPageRoute;
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

void goToSearch(BuildContext context, [bool hasOriginFocus = true]) async {
  final controller = Provider.of<HomeController>(
    context,
    listen: false,
  );
  final state = controller.state;
  final route = MaterialPageRoute<SearchResponse>(
    builder: (_) => SearchPlacePage(
      initialOrigin: state.origin,
      initialDestination: state.destination,
      hasOriginFocus: hasOriginFocus,
    ),
  );
  final response = await Navigator.push<SearchResponse>(
    context,
    route,
  );
  if (response != null) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        //print('🔖 home origin ${response.origin.title}');
        // ignore: use_build_context_synchronously
        final controller = context.read<HomeController>();
        controller.setOriginDestination(
          response.origin,
          response.destinmation,
        );
      },
    );
  }
}
