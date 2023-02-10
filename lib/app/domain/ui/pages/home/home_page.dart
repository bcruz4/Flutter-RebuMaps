//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps/app/domain/ui/pages/home/home_controller.dart';
import 'package:google_maps/app/domain/ui/pages/home/widgets/mapView.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  //final _controller = HomeController();\
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) {
        final controller = HomeController();
        return controller;
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: Selector<HomeController, bool>(
          selector: (_, controller) => controller.state.loading,
          builder: (context, loading, loadingWidget) {
            if (loading) {
              return loadingWidget!;
            }
            return const MapView();
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
