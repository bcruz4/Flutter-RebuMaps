// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/splash/splash_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _controller = SplashController(Permission.locationWhenInUse);

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance!.addPostFrameCallback(
    WidgetsBinding.instance.addPostFrameCallback(
      //WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        _controller.checkPermission();
      },
    );
    _controller.addListener(
      () {
        if (_controller.routeName != null) {
          Navigator.pushReplacementNamed(context, _controller.routeName!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
