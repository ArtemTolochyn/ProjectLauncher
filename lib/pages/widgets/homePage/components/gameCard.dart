import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:project_launcher/pages/playPage.dart';

import '../../../../main.dart';
import '../../../../utils/gameController.dart';

typedef void RemoveCallback(int foo);
class GameCard extends StatefulWidget {
  final int id;
  final List gameList;
  final RemoveCallback enableRemove;
  const GameCard(this.id, this.gameList, this.enableRemove, {super.key});

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> opacity;
  GameController gameController = GameController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 100000)
    );
    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => {
        gameController.playGame(id: widget.id, context: context)
      },
      onSecondaryTap: () => {
        widget.enableRemove(widget.id)
      },
      child: MouseRegion(
          onEnter: (details) {
            animationController.forward();
            },
          onExit: (details) {
            animationController.reverse();
            },
          child: Container(
            margin: EdgeInsets.fromLTRB(0.6.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,), 0,
                0.6.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,), 0),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
            ),
            padding: EdgeInsets.only(bottom: 1.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,)),
            height: 17.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,),
            width: 31.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,),
            child: Stack(
              children: [
                Positioned(top: 0.1.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.file(File("${Platform.environment['HOME']!}/.config/PLauncher/gamedata/${widget.gameList[widget.id][1]}/background.png"),
                        height: 15.9.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,),
                        width: 31.toVWLength.toPX( constraint: screenSize.width, screenSize: screenSize,),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                        isAntiAlias: false,),
                    )),
                AnimatedBuilder(animation: animationController,
                    builder: (context, child) {
                  return Container(
                    height: 16.toVWLength.toPX(
                      constraint: screenSize.width, screenSize: screenSize,),
                    width: 31.toVWLength.toPX(
                      constraint: screenSize.width, screenSize: screenSize,),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            color: Colors.orange.shade900.withOpacity(opacity.value), width: 4.5)
                    ),
                  );
                })
              ],
            ),
          )
      ),
  );
  }
}
