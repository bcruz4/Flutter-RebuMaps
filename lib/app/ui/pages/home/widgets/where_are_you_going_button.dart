import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_page.dart';

class WhereAreYouGoingButton extends StatelessWidget {
  const WhereAreYouGoingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      //posiciona el texto de un widget
      bottom: 35,
      left: 20,
      right: 20,
      child: SafeArea(
        child: CupertinoButton(
          onPressed: () async {
            final route = MaterialPageRoute<SearchResponse>(
              builder: (_) => const SearchPlacePage(),
            );
            final response = await Navigator.push<SearchResponse>(
              context,
              route,
            );
            if (response != null) {
              print('🔖 home origin ${response.origin.title}');
            }
          },
          padding: EdgeInsets.zero,
          //color: Colors.white,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]),
            child: const Text(
              'Where are you going?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}
