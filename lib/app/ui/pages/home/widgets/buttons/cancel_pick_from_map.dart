import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:provider/provider.dart';

class CancelPickFromMapButton extends StatelessWidget {
  const CancelPickFromMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    final visible = context.select<HomeController, bool>(
      (controller) => controller.state.pickFromMap != null,
    );
    if (!visible) {
      return Container();
    }
    return Positioned(
      left: 15,
      top: 15,
      child: SafeArea(
        child: CupertinoButton(
          onPressed: context.read<HomeController>().cancelPickFromMap,
          padding: const EdgeInsets.all(7),
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          child: const Icon(
            Icons.close_rounded,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
