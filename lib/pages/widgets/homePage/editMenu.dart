import 'dart:io';
import 'dart:ui';

import 'package:dimension/dimension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../utils/gameController.dart';
import '../global/components/transparentButton.dart';

class EditMenu extends StatefulWidget {

  bool addMenu;
  GameController gameController;
  Size screenSize;
  VoidCallback callback;

  VoidCallback reload;

  EditMenu({super.key, required this.addMenu, required this.gameController, required this.screenSize, required this.callback, required this.reload});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  double sliderBottom = 100;
  double sliderTop = 100;
  double sliderSize = 50;
  FilePickerResult? filePath;
  String backgroundPath = '';
  String logoPath = '';
  String nameGame = '';
  String commandGame = '';
  TextEditingController nameGameController = TextEditingController();
  TextEditingController commandGameController = TextEditingController();

  selectFile(String type) async {
    filePath = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png'],
    );

    if (type == "logo")
    {
      setState(() {
        logoPath = filePath!.paths[0].toString();
      });
    }
    else
    {
      setState(() {
        backgroundPath = filePath!.paths[0].toString();
      });
    }
  }

  addGame() async
  {
    if(nameGame.isNotEmpty && commandGame.isNotEmpty && backgroundPath.isNotEmpty && logoPath.isNotEmpty) {
      widget.addMenu = false;
      await widget.gameController.addGame(
          nameGame,
          commandGame,
          sliderTop ~/ 2,
          sliderBottom ~/ 2,
          sliderSize.toInt(),
          backgroundPath,
          logoPath);
      widget.reload();
    }
  }

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
              height: 39.toVHLength.toPX( constraint: widget.screenSize.height, screenSize: widget.screenSize ) + 285,
              width: 28.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ) + 280,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: Container(
                    decoration:  BoxDecoration(
                        color: const Color.fromRGBO(45, 46, 48, 0.7),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          height: 40,
                          width: 160,
                          decoration:  BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: const Text(
                            "New game",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                    clipBehavior: Clip.antiAlias,
                                    margin: const EdgeInsets.only(left: 35),
                                    height: 30.toVHLength.toPX( constraint: widget.screenSize.height, screenSize: widget.screenSize ),
                                    width: 30.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ),
                                    decoration:  BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    child:
                                    Stack(
                                      children: [
                                        backgroundPath.isNotEmpty? Image.file(File(backgroundPath),
                                          height: 30.toVHLength.toPX( constraint: widget.screenSize.height, screenSize: widget.screenSize ),
                                          width: 30.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ),
                                          fit: BoxFit.cover,
                                        ): Container(),
                                        Positioned(
                                          left: (15/100*(sliderBottom-sliderSize)).toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ),
                                          bottom: (15/100*(sliderTop-sliderSize)).toVHLength.toPX( constraint: widget.screenSize.height, screenSize: widget.screenSize ),
                                          child: logoPath.isNotEmpty? Image.file(File(logoPath),
                                            height: (30 / 100 * sliderSize).toVHLength.toPX( constraint: widget.screenSize.height, screenSize: widget.screenSize ),
                                            width: (30 / 100 * sliderSize).toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ),
                                          ): Container(),
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 25),
                              height: 35.toVHLength.toPX( constraint: widget.screenSize.height, screenSize: widget.screenSize ),
                              width: 10,
                              child: RotatedBox(
                                  quarterTurns: 3,
                                  child: SliderTheme(
                                    data: const SliderThemeData(
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                                        trackHeight: 10
                                    ),
                                    child: Slider(
                                      min: 0.0,
                                      max: 200.0,
                                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      activeColor: Colors.black.withOpacity(0.2),
                                      inactiveColor: Colors.black.withOpacity(0.2),
                                      thumbColor: Colors.white,
                                      onChanged: (value) => setState(() {
                                        sliderTop = value;
                                      }), value: sliderTop,
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                        Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            height: 30,
                            width: 31.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ),
                            child: SliderTheme(
                              data: const SliderThemeData(
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                                  trackHeight: 10
                              ),
                              child: Slider(
                                min: 0.0,
                                max: 200.0,
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                activeColor: Colors.black.withOpacity(0.2),
                                inactiveColor: Colors.black.withOpacity(0.2),
                                thumbColor: Colors.white,
                                onChanged: (value) => setState(() {
                                  sliderBottom = value;
                                }), value: sliderBottom,
                              ),
                            )
                        ),
                        Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            height: 30,
                            width: 31.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ),
                            child: SliderTheme(
                              data: const SliderThemeData(
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                                  trackHeight: 10
                              ),
                              child: Slider(
                                min: 0.0,
                                max: 100.0,
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                activeColor: Colors.black.withOpacity(0.2),
                                inactiveColor: Colors.black.withOpacity(0.2),
                                thumbColor: Colors.white,
                                onChanged: (value) => setState(() {
                                  sliderSize = value;
                                }), value: sliderSize,
                              ),
                            )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0.5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ), 0, 0.5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ), 0),
                              alignment: Alignment.center,
                              height: 45,
                              width: 14.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: TextField(
                                controller: nameGameController,
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Name of the game',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.1),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                onChanged: (value) => nameGame = value,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0.5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ), 0, 0.5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ), 0),
                              alignment: Alignment.center,
                              height: 45,
                              width: 14.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize ),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: TextField(
                                controller: commandGameController,
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Command',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.1),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                onChanged: (value) => commandGame = value,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TransparentButton(
                              margin: const EdgeInsets.only(top: 20),
                              width: 160,
                              text: "Background",
                              onPressed: () {selectFile("background");},
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TransparentButton(
                              margin: const EdgeInsets.only(top: 20),
                              width: 160,
                              text: "Logo",
                              onPressed: () {selectFile("logo");},
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TransparentButton(
                              margin: const EdgeInsets.only(top: 20),
                              width: 130,
                              text: "Cancel",
                              onPressed: () {
                                setState(() {
                                  nameGameController.clear();
                                  commandGameController.clear();
                                  sliderSize = 50;
                                  sliderBottom = 100;
                                  sliderTop = 100;
                                  backgroundPath = '';
                                  logoPath = '';
                                  nameGame = '';
                                  commandGame = '';
                                  widget.callback();
                                });
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TransparentButton(
                              margin: const EdgeInsets.only(top: 20),
                              width: 130,
                              text: "Submit",
                              onPressed: () {
                                addGame();
                              },
                            ),
                          ],
                        )
                      ],
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
