//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';

// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/data/providers/local/geolocator_wrapper.dart';
import 'package:google_maps/app/data/providers/remote/routes_api.dart';
import 'package:google_maps/app/data/providers/repositories_impl/routes_repository_impl.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:google_maps/app/ui/pages/home/widgets/mapView.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  //final _controller = HomeController();\
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) => HomeController(
        GeolocatorWrapper(),
        RoutesRepositoryImpl(
          RoutesAPI(Dio()),
        ),
      ),
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
