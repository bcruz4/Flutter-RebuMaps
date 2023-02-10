import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps/app/domain/ui/pages/request_permission/request_permission_controller.dart';
import 'package:google_maps/app/domain/ui/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({super.key});
  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage>
    with WidgetsBindingObserver {
  //retornar locationWhenInUse
  final _controller = RequestPermissionController(Permission.locationWhenInUse);
  late StreamSubscription _subscription;
  bool _fromSettings = false;

  @override
  void initState() {
    //escuchar cuando cambia el ciclo de vida de la app
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    _subscription = _controller.onStatusChanged.listen(
      (status) {
        switch (status) {
          case PermissionStatus.granted:
            _goToHome();
            break;
          case PermissionStatus.permanentlyDenied:
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("INFO"),
                content: const Text('Do manually'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      _fromSettings = await openAppSettings();
                    },
                    child: const Text('Settings'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            );
            // openAppSettings(); hace abrir el apartado de configuraciones para conceder permisos de manera manual
            // openAppSettings();
            break;
          case PermissionStatus.denied:
            break;
          case PermissionStatus.restricted:
            break;
          case PermissionStatus.limited:
            break;
        }
        //si el usuario no sda permiso nos direccion al 'HOME'
        //if (status == PermissionStatus.granted) {
        //pushReplacement.- para eliminar la ruta actual y navegar a home
        //Navigator.pushReplacementNamed(context, Routes.HOME);
        //}
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('state $state');
    if (state == AppLifecycleState.resumed && _fromSettings == true) {
      final status = await _controller.check();
      if (status == PermissionStatus.granted) {
        _goToHome();
      }
    }
    _fromSettings == false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.pushReplacementNamed(context, Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: ElevatedButton(
            child: const Text('Allow'),
            onPressed: () {
              _controller.request();
            },
          ),
        ),
      ),
    );
  }
}
