import 'dart:io';

import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  Size screenSize;
  String config;
  String theme;
  Logo({super.key, required this.screenSize, required this.config, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 25,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      margin: EdgeInsets.all(2.5.toVHLength.toPX( constraint: screenSize.width, screenSize: screenSize)),
      height: 3.5.toVHLength.toPX( constraint: screenSize.width, screenSize: screenSize),
      width: 3.5.toVHLength.toPX( constraint: screenSize.width, screenSize: screenSize),
      child: SvgPicture.file(
        File("$config/themes/$theme/logo.svg"),
        fit: BoxFit.contain,
      ),
    );
  }
}
