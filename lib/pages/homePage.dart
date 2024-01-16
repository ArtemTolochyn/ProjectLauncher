import 'package:flutter/material.dart';
import 'package:project_launcher/pages/widgets/homePage/decorations/backgroundDarkEffect.dart';
import 'package:project_launcher/pages/widgets/global/components/logo.dart';
import 'package:project_launcher/pages/widgets/homePage/decorations/shadowEffect.dart';
import 'package:project_launcher/pages/widgets/homePage/editMenu.dart';
import 'package:project_launcher/pages/widgets/homePage/sureMenu.dart';

import '../utils/gameController.dart';
import 'widgets/homePage/components/playButton.dart';
import 'widgets/homePage/gamesWidget.dart';
import 'widgets/global/homeBackground.dart';

class HomePage extends StatefulWidget {
  GameController gameController;

  HomePage({super.key, required this.gameController});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late String config;
  late String theme;
  late GamesWidget games;
  late AnimationController animationController;

  int selectedGame = -1;

  double opacityLaunch = 1;

  bool addMenu = false;

  bool removeMenu = false;

  void enableMenu()
  {
    setState(() {
      addMenu = true;
    });
  }

  void disableMenu()
  {
    setState(() {
      addMenu = false;
    });
  }

  void enableRemove(int id)
  {
    selectedGame = id;
    setState(() {
      removeMenu = true;
    });
  }

  void disableRemove()
  {
    setState(() {
      removeMenu = false;
    });
  }

  Future<void> removeGame()
  async {
    setState(() {
      opacityLaunch = 1;
    });
    await widget.gameController.removeGame(id: selectedGame, context: context);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => super.widget));
    });
  }

  Future<void> reload()
  async {
    setState(() {
      opacityLaunch = 1;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => super.widget));
    });
  }

  initConfig() async {
    theme = "stadia";

    config = widget.gameController.config;
    await widget.gameController.getHistory();

    setState(() {
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
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            HomeBackground(widget.gameController.gameList, screenSize, config, animationController),

            Row(
              children: [
                Logo(
                  screenSize: screenSize,
                  config: config,
                  theme: theme,
                )
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ShadowEffect(screenSize: screenSize),

                    PlayButton(
                      screenSize: screenSize,
                      theme: theme,
                      config: config,
                      gameController: widget.gameController,
                      enableRemove: enableRemove
                    ),

                    BackgroundOpacityEffect(
                        animationController: animationController,
                        screenSize: screenSize
                    ),

                    GamesWidget(
                        gameController: widget.gameController,
                        screenSize: screenSize,
                        animationController: animationController,
                        enableRemove: enableRemove,
                        callback: enableMenu
                    )
                  ],
                )
              ],
            ),
            EditMenu(
              addMenu: addMenu,
              gameController: widget.gameController,
              screenSize: screenSize,
              callback: disableMenu,
              reload: reload,
            ),

            SureMenu(addMenu: removeMenu, screenSize: screenSize, callback: disableRemove, removeGame: removeGame),

            IgnorePointer(ignoring: opacityLaunch == 1? false: true,
              child: AnimatedContainer(
                color: Colors.black.withOpacity(opacityLaunch), duration: const Duration(microseconds: 1000000),
              ),
            ),
          ],
        ));
  }
}