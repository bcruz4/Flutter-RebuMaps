import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_controller.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.black87,
      ),
      elevation: 0,
      actions: [
        Builder(builder: (context) {
          final controller = context.watch<SearchPlaceController>();
          final origin = controller.origin;
          final destination = controller.destination;

          // Solo visualizar el texto 'OK' al asignar origen y destino
          final bool enabled = origin != null && destination != null;
          return CupertinoButton(
            onPressed: enabled
                ? () {
                    Navigator.pop(
                      context,
                      SearchResponse(origin, destination),
                    );
                  }
                : null,
            child: const Text('SAVE'),
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}
