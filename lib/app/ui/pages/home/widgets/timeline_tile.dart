import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeLineTile extends StatelessWidget {
  final String label, desciption;
  final VoidCallback onPressed;
  final bool isTop;
  const TimeLineTile(
      {super.key,
      required this.onPressed,
      required this.label,
      required this.desciption,
      required this.isTop});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: isTop ? 12 : 0,
          left: 6.5,
          bottom: isTop ? 0 : null,
          height: isTop ? null : 14,
          child: Container(
            width: 1,
            color: Colors.black,
          ),
        ),
        if (!isTop)
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.black12,
            margin: const EdgeInsets.only(left: 30),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.all(10),
                onPressed: onPressed,
                child: SizedBox(
                  //para que ocupe todo el ancho posible
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        desciption,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
