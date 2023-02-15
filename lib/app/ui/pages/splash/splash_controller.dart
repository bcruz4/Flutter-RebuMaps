import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:google_maps/app/domain/ui/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends ChangeNotifier {
  // comprobar los accesos de ubicacion /home or ?reques permission
  final Permission _locationPermission;

  String? _routeName;
  String? get routeName => _routeName;

  //constructor
  SplashController(this._locationPermission);

  //
  Future<void> checkPermission() async {
    final isGrated = await _locationPermission.isGranted;
    _routeName = isGrated ? Routes.HOME : Routes.PERMISSIONS;
    notifyListeners();
  }
}
