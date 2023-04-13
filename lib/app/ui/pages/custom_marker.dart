import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: SizedBox(
          width: 300,
          height: 60,
          child: CustomPaint(
            painter: MyCustomPaiter(
              label: "Universidad Mayor de San Andres",
              duration: 25,
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomPaiter extends CustomPainter {
  final String label;
  final int? duration;

  MyCustomPaiter({
    required this.label,
    required this.duration,
  });

  void _drawText({
    required Canvas canvas,
    required Size size,
    required String text,
    required double width,
    double? dx,
    double? dy,
    String? fontFamily,
    double fontSize = 18,
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
      //maximo de lineas
      maxLines: 2,
    );

    textPainter.layout(
      maxWidth: width,
    );

    textPainter.paint(
      canvas,
      Offset(
        dx ?? size.height / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.size.height / 2 + (dy ?? 0),
      ),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    //final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(5),
    );
    canvas.drawRRect(rRect, paint);

    //cambiar color del pincel
    paint.color = Colors.black87;

    final miniRect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.height,
      size.height,
      topLeft: const Radius.circular(5),
      bottomLeft: const Radius.circular(5),
    );

    canvas.drawRRect(miniRect, paint);

    _drawText(
      canvas: canvas,
      size: size,
      text: label,
      dx: size.height + 10,
      width: size.width - size.height - 10,
    );

    if (duration == null) {
      _drawText(
        canvas: canvas,
        size: size,
        text: String.fromCharCode(
          Icons.gps_fixed_rounded.codePoint,
        ),
        fontFamily: Icons.gps_fixed_rounded.fontFamily,
        fontSize: 25,
        color: Colors.white,
        width: size.height,
      );
    } else {
      _drawText(
        canvas: canvas,
        size: size,
        text: "$duration",
        fontSize: 28,
        dy: -9,
        color: Colors.white,
        width: size.height,
        fontWeight: FontWeight.w300,
      );
      _drawText(
        canvas: canvas,
        size: size,
        text: "MIN",
        fontSize: 20,
        dy: 14,
        color: Colors.white,
        width: size.height,
        fontWeight: FontWeight.bold,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
