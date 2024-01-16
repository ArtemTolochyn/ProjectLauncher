import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';

class ShadowEffect extends StatelessWidget {
  Size screenSize;
  ShadowEffect({super.key, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: true,
          child: Container(
            height: 25.toVHLength.toPX(
              constraint: screenSize.height,
              screenSize: screenSize,
            ),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.0, 63.toVHLength.toPX( constraint: screenSize.width, screenSize: screenSize)),
                    blurRadius: 150.0,
                    spreadRadius: 200,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ]
            ),
          ),
        ),
      ],
    );
  }
}
