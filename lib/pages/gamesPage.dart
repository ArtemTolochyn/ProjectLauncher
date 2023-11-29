import 'dart:io';
import 'dart:ui';

import 'package:dimension/dimension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_launcher/pages/playPage.dart';

import '../utils/gameController.dart';
import '../widgets/components/editButton.dart';
import '../widgets/components/playButton.dart';
import '../widgets/gamesWidget.dart';
import '../widgets/homeBackground.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key, config});
  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  List gameList = [];
  late String config;
  late String theme;
  late gamesWidget games;
  late AnimationController animationController;
  late Animation<double> opacity;
  late Animation<double> tween;
  late Animation<double> opacityText;
  late Animation<double> homeBackgroundAnimation;
  bool addMenu = false;
  double sliderBottom = 100;
  double sliderTop = 100;
  double sliderSize = 50;
  double opacityLaunch = 1;
  FilePickerResult? filePath;
  String backgroundPath = '';
  String logoPath = '';
  String nameGame = '';
  String commandGame = '';
  GameController game = GameController();
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
      addMenu = false;
      await game.addGame(
          nameGame,
          commandGame,
          sliderTop ~/ 2,
          sliderBottom ~/ 2,
          sliderSize.toInt(),
          backgroundPath,
          logoPath);
      setState(() {
        opacityLaunch = 1;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => super.widget));
      });}
  }

  play() async {
    await game.playGame(0);
    Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const PlayPage(), transitionDuration: const Duration(seconds: 0),),);
  }

  initConfig() async {
    config = game.config;
    theme = "stadia";
    gameList = await game.getHistory();
    setState(() {
      gameList = gameList;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      opacityLaunch = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    initConfig();
    animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 200000)
    );
    opacity = Tween<double>(begin: 0.0, end: 0.8).animate(animationController);
    opacityText = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    homeBackgroundAnimation = Tween<double>(begin: 1.0, end: 15).animate(animationController);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    tween = Tween<double>(begin: 15.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,), end: 1.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,)).animate(animationController);
    return Scaffold(
        body: Stack(
          children: [
            HomeBackground(gameList, screenSize, config, animationController, homeBackgroundAnimation),
            Row(
              children: [
                Container(
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
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        height: 25.toVHLength.toPX(
                          constraint: screenSize.height,
                          screenSize: screenSize,),
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
                    Container(
                      width: 128,
                      margin: EdgeInsets.only(top: 48.toVHLength.toPX( constraint: screenSize.width, screenSize: screenSize),),
                      child: InkWell(
                        onTap: () => play(),
                        child: playButton(screenSize, config, theme),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child: AnimatedBuilder(animation: animationController,
                          builder: (context, child) {
                            return Container(
                              height: 100.toVHLength.toPX(
                                constraint: screenSize.height,
                                screenSize: screenSize,),
                              color: Color.fromRGBO(0, 0, 0, opacity.value),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 100.toVHLength.toPX( constraint: screenSize.width, screenSize: screenSize),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          AnimatedBuilder(animation: animationController,
                              builder: (context, child) {
                                return Transform.translate(
                                    offset: Offset(0.0, tween.value),
                                    child: MouseRegion(
                                      onEnter: (details) {
                                        animationController.forward();
                                      },
                                      onExit: (details) {
                                        animationController.reverse();
                                      },
                                      child: gamesWidget(gameList, screenSize, opacityText, animationController,
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                addMenu = true;
                                              });
                                            },
                                            child: Text("+ Add game", style: TextStyle(
                                              color: Colors.white.withOpacity(opacityText.value),
                                              fontSize: 1.5.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,),
                                              fontWeight: FontWeight.bold,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: const Offset(0.0, 0.0),
                                                  blurRadius: 20.0,
                                                  color: const Color.fromARGB(255, 0, 0, 1).withOpacity(opacityText.value),
                                                ),
                                              ],
                                            ),)
                                        ),
                                      ),
                                    )
                                );
                              })
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            IgnorePointer(
                ignoring: addMenu == true? false: true,
                child:  AnimatedOpacity(
                  duration: const Duration(microseconds: 200000),
                  opacity: addMenu == true? 1: 0,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black.withOpacity(0.7),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)
                      ),
                      height: 39.toVHLength.toPX( constraint: screenSize.height, screenSize: screenSize ) + 285,
                      width: 28.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ) + 280,
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
                                            height: 30.toVHLength.toPX( constraint: screenSize.height, screenSize: screenSize ),
                                            width: 30.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ),
                                            decoration:  BoxDecoration(
                                                color: Colors.black.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12)
                                            ),
                                            child:
                                            Stack(
                                              children: [
                                                backgroundPath.isNotEmpty? Image.file(File(backgroundPath),
                                                  height: 30.toVHLength.toPX( constraint: screenSize.height, screenSize: screenSize ),
                                                  width: 30.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ),
                                                  fit: BoxFit.cover,
                                                ): Container(),
                                                Positioned(
                                                  left: (15/100*(sliderBottom-sliderSize)).toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ),
                                                  bottom: (15/100*(sliderTop-sliderSize)).toVHLength.toPX( constraint: screenSize.height, screenSize: screenSize ),
                                                  child: logoPath.isNotEmpty? Image.file(File(logoPath),
                                                    height: (30 / 100 * sliderSize).toVHLength.toPX( constraint: screenSize.height, screenSize: screenSize ),
                                                    width: (30 / 100 * sliderSize).toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ),
                                                  ): Container(),
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 25),
                                      height: 35.toVHLength.toPX( constraint: screenSize.height, screenSize: screenSize ),
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
                                    width: 31.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ),
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
                                    width: 31.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ),
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
                                      padding: EdgeInsets.fromLTRB(0.5.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ), 0, 0.5.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ), 0),
                                      alignment: Alignment.center,
                                      height: 45,
                                      width: 14.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ),
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
                                      padding: EdgeInsets.fromLTRB(0.5.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ), 0, 0.5.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ), 0),
                                      alignment: Alignment.center,
                                      height: 45,
                                      width: 14.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize ),
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
                                    editButton(
                                      margin: const EdgeInsets.only(top: 20),
                                      width: 160,
                                      text: "Background",
                                      onPressed: () {selectFile("background");},
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    editButton(
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
                                    editButton(
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
                                          addMenu = false;
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    editButton(
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
            ),
            IgnorePointer(ignoring: opacityLaunch == 1? false: true,
              child: AnimatedContainer(
                color: Colors.black.withOpacity(opacityLaunch), duration: const Duration(microseconds: 1000000),
              ),
            ),
          ],
        ));
  }
}