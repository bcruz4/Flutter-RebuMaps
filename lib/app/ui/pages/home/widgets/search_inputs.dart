import 'package:flutter/cupertino.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_controller.dart';
import 'package:google_maps/app/ui/pages/search_place/widgets/search_input.dart';
import 'package:provider/provider.dart';

class SearchInputs extends StatelessWidget {
  const SearchInputs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        Provider.of<SearchPlaceController>(context, listen: false);
    return Column(
      children: [
        SearchInput(
          controller: controller.originController,
          focusNode: controller.originFocusNode,
          placeholder: 'origin',
          onChanged: controller.onQueryChanged,
          onClear: controller.clearQuery,
        ),
        SearchInput(
          controller: controller.destinationController,
          focusNode: controller.destinationFocusNode,
          placeholder: 'destination',
          onChanged: controller.onQueryChanged,
          onClear: controller.clearQuery,
        ),
      ],
    );
  }
}
