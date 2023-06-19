import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:google_maps/app/ui/pages/home/widgets/timeline_tile.dart';
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

    final controller = Provider.of<HomeController>(
      context,
      listen: false,
    );
    final state = controller.state;
    final origin = state.origin!;
    final destination = state.destination!;

    return Positioned(
      top: 10,
      left: 15,
      right: 15,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TimeLineTile(
                          label: 'Pick up',
                          isTop: true,
                          desciption: origin.title,
                          onPressed: () {},
                        ),
                        TimeLineTile(
                          label: 'Drop off',
                          isTop: false,
                          desciption: destination.title,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  CupertinoButton(
                    color: Colors.black.withOpacity(0.2),
                    padding: const EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(30),
                    child: const Icon(
                      Icons.sync,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {},
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
