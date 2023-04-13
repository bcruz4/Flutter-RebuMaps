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
            painter: MyCustomPaiter(),
          ),
        ),
      ),
    );
  }
}

class MyCustomPaiter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(5),
    );
    canvas.drawRRect(rRect, paint);
    //cambiar color del pincel
    paint.color = Colors.amber;
    canvas.drawCircle(
      Offset(20, size.height / 2),
      10,
      paint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Universidad Mayor de San Andres',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
      //maximo de lineas
      maxLines: 2,
    );

    textPainter.layout(
      maxWidth: size.width - 40,
    );

    textPainter.paint(
      canvas,
      Offset(40, size.height / 2 - textPainter.size.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
