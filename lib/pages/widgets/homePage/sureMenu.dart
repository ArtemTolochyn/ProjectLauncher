import 'dart:io';
import 'dart:ui';

import 'package:dimension/dimension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../utils/gameController.dart';
import '../global/components/transparentButton.dart';

class SureMenu extends StatefulWidget {

  bool addMenu;
  Size screenSize;
  VoidCallback callback;

  VoidCallback removeGame;

  SureMenu({super.key, required this.addMenu, required this.screenSize, required this.callback, required this.removeGame});

  @override
  State<SureMenu> createState() => _SureMenuState();
}

class _SureMenuState extends State<SureMenu> {

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: widget.addMenu == true? false: true,
        child:  AnimatedOpacity(
          duration: const Duration(microseconds: 200000),
          opacity: widget.addMenu == true? 1: 0,
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.7),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30)
              ),
              height: 15.toVHLength.toPX( constraint: widget.screenSize.height, screenSize: widget.screenSize ),
              width: 28.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: Container(
                    decoration:  BoxDecoration(
                        color: const Color.fromRGBO(45, 46, 48, 0.7),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Remove game?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TransparentButton(
                              margin: const EdgeInsets.only(top: 20),
                              width: 160,
                              text: "No",
                              onPressed: () {
                                widget.callback();
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TransparentButton(
                              margin: const EdgeInsets.only(top: 20),
                              width: 160,
                              text: "Yes",
                              onPressed: () {
                                widget.removeGame();
                              },
                            ),
                          ],
                        ),
                      ]
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
