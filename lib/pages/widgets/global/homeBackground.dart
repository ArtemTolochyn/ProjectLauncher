import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';


class HomeBackground extends StatefulWidget {
  final List gameList;
  final Size screenSize;
  final String config;
  final AnimationController animationController;
  const HomeBackground(this.gameList, this.screenSize, this.config,  this.animationController, {super.key});
  @override
  State<HomeBackground> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> backgroundAnimation;
  late Animation<double> logoAnimation;
  SizedBox homeWidget = const SizedBox();

  late Animation<double> homeBackgroundAnimation;

  @override
  void initState() {
    homeBackgroundAnimation = Tween<double>(begin: 1.0, end: 15).animate(widget.animationController);

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 8000)
    );
    backgroundAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    logoAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((value) => animationController.forward());
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (widget.gameList.isNotEmpty) {
        homeWidget = SizedBox(
          height: 100.toVHLength.toPX(
              constraint: widget.screenSize.width, screenSize: widget.screenSize),
          width: 100.toVWLength.toPX(
              constraint: widget.screenSize.width, screenSize: widget.screenSize),
          child: AnimatedBuilder(animation: widget.animationController,
    builder: (context, child) {
      return Stack(
          children: [
            AnimatedBuilder(animation: animationController,
                builder: (context, child) {
                  return Positioned(
                    left:
                    (100 * backgroundAnimation.value -
                        homeBackgroundAnimation.value / 2).toVWLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize) <= 100.toVWLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize)?
                    50.toVWLength.toPX(constraint: widget.screenSize
                        .width, screenSize: widget.screenSize) - 100.toVWLength.toPX(
                        constraint: widget.screenSize.width,
                        screenSize: widget.screenSize) / 2:
                    50.toVWLength.toPX(constraint: widget.screenSize
                        .width, screenSize: widget.screenSize) - (100 *
                        backgroundAnimation.value -
                        homeBackgroundAnimation.value / 2).toVWLength.toPX(
                        constraint: widget.screenSize.width,
                        screenSize: widget.screenSize) / 2
                    ,
                    top: (100 * backgroundAnimation.value -
                        homeBackgroundAnimation.value / 2).toVHLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize) <= 100.toVHLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize)?
                    50.toVHLength.toPX(constraint: widget.screenSize.width,
                        screenSize: widget.screenSize) - 100.toVHLength.toPX(
                        constraint: widget.screenSize.width,
                        screenSize: widget.screenSize) / 2:
                    50.toVHLength.toPX(constraint: widget.screenSize.width,
                        screenSize: widget.screenSize) - (100 *
                        backgroundAnimation.value -
                        homeBackgroundAnimation.value / 2).toVHLength.toPX(
                        constraint: widget.screenSize.width,
                        screenSize: widget.screenSize) / 2
                    ,
                    width: (100 * backgroundAnimation.value -
                        homeBackgroundAnimation.value / 2).toVWLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize) <= 100.toVWLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize)?
                    100.toVWLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize):
                    (100 * backgroundAnimation.value -
                        homeBackgroundAnimation.value / 2).toVWLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize)
                    ,
                    height: (100 * backgroundAnimation.value -
                        homeBackgroundAnimation.value / 2).toVHLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize) <= 100.toVHLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize)?
                    100.toVHLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize):
                    (100 * backgroundAnimation.value -
                        homeBackgroundAnimation.value / 2).toVHLength.toPX(
                        constraint: widget.screenSize.width, screenSize: widget
                        .screenSize),
                    child: Image.file(
                      File("${widget.config}/gamedata/${widget
                          .gameList[0][1]}/background.png",),
                      filterQuality: FilterQuality.medium,
                      isAntiAlias: true,
                      fit: BoxFit.cover,
                    ),
                  );
                }),
            AnimatedBuilder(animation: animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: logoAnimation.value -
                        (homeBackgroundAnimation.value / 100) - 0.1
                      ,
                    child: Transform.translate(
                        offset: Offset(-(50 - int.parse(widget.gameList[0][6])).toVWLength.toPX(
                            constraint: widget.screenSize.height, screenSize: widget
                            .screenSize ), (50 - int.parse(widget.gameList[0][5])).toVHLength.toPX(
                            constraint: widget.screenSize.height, screenSize: widget
                            .screenSize )),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(((100 - int.parse(widget.gameList[0][7]))/2).toVWLength.toPX(
                              constraint: widget.screenSize.width, screenSize: widget
                              .screenSize), ((100 - int.parse(widget.gameList[0][7]))/2).toVHLength.toPX(
                              constraint: widget.screenSize.width, screenSize: widget
                              .screenSize), ((100 - int.parse(widget.gameList[0][7]))/2).toVWLength.toPX(
                              constraint: widget.screenSize.width, screenSize: widget
                              .screenSize), ((100 - int.parse(widget.gameList[0][7]))/2).toVHLength.toPX(
                              constraint: widget.screenSize.width, screenSize: widget
                              .screenSize),),
                          child: Image.file(
                            File("${widget.config}/gamedata/${widget
                                .gameList[0][1]}/logo.png",),
                            filterQuality: FilterQuality.medium, isAntiAlias: true,
                          ),
                        ),
                      ),
                    );
                })
          ]);
          })
        );
      }
    }
    catch(e)
    {
      //pass
    }
    return homeWidget;
  }
}
