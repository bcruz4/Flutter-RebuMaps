import 'package:flutter/cupertino.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_controller.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

class PickFromMapButtom extends StatelessWidget {
  const PickFromMapButtom({super.key});

  @override
  Widget build(BuildContext context) {
    final originHasFocus = context.select<SearchPlaceController, bool>(
      (controller) => controller.originHasFocus,
    );
    return CupertinoButton(
      child: Text('Pick ${originHasFocus ? 'origin' : 'destination'} from map'),
      onPressed: () {
        Navigator.pop(
          context,
          PickFromMapResponse(),
        );
      },
    );
  }
}
