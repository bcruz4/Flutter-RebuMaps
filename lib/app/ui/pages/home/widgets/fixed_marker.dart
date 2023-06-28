import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FixedMarker extends StatelessWidget {
  const FixedMarker({super.key});

  @override
  Widget build(BuildContext context) {
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
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    //utilizaremos spinkit para personalizar el CircularProgressIndicator
                    //consultar pub.dev para detalles
                    child: const SpinKitCircle(
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
