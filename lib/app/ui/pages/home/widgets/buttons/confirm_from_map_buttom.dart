import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_state.dart';
import 'package:provider/provider.dart';

import '../../controller/home_controller.dart';

class ConfirmFromMapButton extends StatelessWidget {
  const ConfirmFromMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    //define condicion booleana para redibujar el mapa
    final PickFromMap? data = context.select<HomeController, PickFromMap?>(
      (controller) {
        final state = controller.state;
        return state.pickFromMap;
      },
    );
    //si se asigna el ortigen y destino se muestra un container
    if (data == null) {
      return Container();
    }

    return Positioned(
      //posiciona el texto de un widget
      bottom: 35,
      left: 20,
      right: 20,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CupertinoButton(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: const Icon(
                Icons.gps_fixed_rounded,
                color: Colors.black87,
              ),
              onPressed: context.read<HomeController>().goToMyPosition,
            ),
            const SizedBox(height: 5),
            const SizedBox(height: 20),
            CupertinoButton(
              onPressed: () {},
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
                  'Confirmar',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
