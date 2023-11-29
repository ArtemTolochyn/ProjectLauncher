import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';
import 'package:project_launcher/pages/gamesPage.dart';
import '../utils/gameController.dart';
import '../widgets/components/editButton.dart';
import '../widgets/homeBackground.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {

  late AnimationController _controller;
  List gameList = [];
  late String config;
  late String theme;
  late AnimationController animationController;
  late Animation<double> homeBackgroundAnimation;
  final player = AudioPlayer();
  var shell = Shell();
  double opacityLaunch = 1;


  initConfig() async {
    GameController games = GameController();
    config = games.config;
    theme = "stadia";
    gameList = await games.getHistory();
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
    homeBackgroundAnimation = Tween<double>(begin: 1.0, end: 15).animate(animationController);
    player.play(UrlSource("file:///$config/themes/stadia/playSound.mp3"));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          HomeBackground(gameList, screenSize, config, animationController, homeBackgroundAnimation),
          AnimatedContainer(
            color: Colors.black.withOpacity(opacityLaunch), duration: const Duration(microseconds: 1000000),
          ),
          Container(
            margin: const EdgeInsets.all(50),
            alignment: Alignment.bottomLeft,
            child: editButton(
              width: 160,
              text: "Back to home",
              onPressed: () {Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const GamesPage(), transitionDuration: const Duration(seconds: 0),),);},
            ),
          )
        ],
      ),
    );
  }
}

