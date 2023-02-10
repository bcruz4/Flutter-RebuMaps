//import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<Uint8List> imageToBytes(String path,
    {int width = 100, bool fromNetwork = false}) async {
  late Uint8List bytes;
  if (fromNetwork == true) {
    // si la imagen es de internet
    final file = await DefaultCacheManager().getSingleFile(path);
    bytes = await file.readAsBytes();
  } else {
    final byteData = await rootBundle.load(path);
    bytes = byteData.buffer.asUint8List();
  }

  final codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: width,
  );
  final frame = await codec.getNextFrame();
  final newByData = await frame.image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  return newByData!.buffer.asUint8List();
}
