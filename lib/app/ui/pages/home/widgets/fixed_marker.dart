import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_state.dart';

class FixedMarker extends StatelessWidget {
  final String? text;
  const FixedMarker({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pickFromMap = context.select<HomeController, PickFromMap?>(
        (controller) => controller.state.pickFromMap);
    if (pickFromMap == null) {
      return Container();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(0, -25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //padding: const EdgeInsets.all(5),
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    //utilizaremos spinkit para personalizar el CircularProgressIndicator
                    //consultar pub.dev para detalles
                    child: text != null
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 250,
                            ),
                            child: Text(
                              text!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : const SpinKitCircle(
                            color: Colors.white,
                            size: 24,
                          ),
                  ),
                ],
              ),
              Container(
                width: 2,
                height: 10,
                color: Colors.black,
              ),
            ],
          ),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
