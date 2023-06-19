import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:provider/provider.dart';

class OriginAndDestination extends StatelessWidget {
  const OriginAndDestination({super.key});

  @override
  Widget build(BuildContext context) {
    final originAndDestinationReady = context.select<HomeController, bool>(
      (controller) {
        final state = controller.state;
        return state.origin != null && state.destination != null;
      },
    );
    //si el origen y el destino no estan asignaod retorna un caontainer vacio
    if (!originAndDestinationReady) {
      return Container();
    }

    return Positioned(
      top: 10,
      left: 15,
      right: 15,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoButton(
              onPressed: context.read<HomeController>().clearData,
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(30),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  20,
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
