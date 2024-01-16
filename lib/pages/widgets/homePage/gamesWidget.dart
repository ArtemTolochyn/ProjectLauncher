import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:project_launcher/utils/gameController.dart';
import 'components/gameCard.dart';

typedef void RemoveCallback(int foo);

class GamesWidget extends StatefulWidget {
  Size screenSize;
  AnimationController animationController;
  GameController gameController;

  RemoveCallback enableRemove;

  VoidCallback callback;

  GamesWidget({
    super.key,
    required this.gameController,
    required this.screenSize,
    required this.animationController,
    required this.enableRemove,
    required this.callback
  });

  @override
  State<GamesWidget> createState() => _GamesWidgetState();
}

class _GamesWidgetState extends State<GamesWidget> with TickerProviderStateMixin {
  late ScrollController scrollController;

  late Animation animation;

  late Animation opacityAnimation;

  double scroll = 0;

  Future<void> animInit()
  async {
    await Future.delayed(const Duration(seconds: 1));
    animation = Tween<double>(
        begin: 15.toVWLength.toPX(
            constraint: widget.screenSize.width,
            screenSize: widget.screenSize
        ),
        end: 1.toVWLength.toPX(
            constraint: widget.screenSize.width,
            screenSize: widget.screenSize
        )).animate(widget.animationController);
  }

  @override
  void initState() {
    super.initState();

    animation = Tween<double>(
        begin: 15.toVWLength.toPX(
            constraint: widget.screenSize.width,
            screenSize: widget.screenSize
        ),
        end: 1.toVWLength.toPX(
            constraint: widget.screenSize.width,
            screenSize: widget.screenSize
        )).animate(widget.animationController);
    opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(widget.animationController);

    animInit();

    scrollController = ScrollController();
  }

  void scrollEvent(signal) {
    if (signal > 0) {
      if (scroll <= 32.2.toVWLength.toPX(
        constraint: widget.screenSize.width, screenSize: widget.screenSize,) *
          (widget.gameController.gameList.length - 4)) {
        scroll = scroll + 32.2.toVWLength.toPX(
          constraint: widget.screenSize.width, screenSize: widget.screenSize,);
        scrollController.animateTo(
            scroll, duration: const Duration(microseconds: 200000),
            curve: Curves.easeOut);
      }
    }
    else {
      if (scroll >= 32.toVWLength.toPX(
        constraint: widget.screenSize.width, screenSize: widget.screenSize,)) {
        scroll = scroll - 32.2.toVWLength.toPX(
          constraint: widget.screenSize.width, screenSize: widget.screenSize,);
        scrollController.animateTo(
            scroll, duration: const Duration(microseconds: 200000),
            curve: Curves.easeOut);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.toVHLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedBuilder(animation: widget.animationController,
              builder: (context, child) {
                return Transform.translate(
                    offset: Offset(0.0, animation.value),
                    child: MouseRegion(
                        onEnter: (details) {
                          widget.animationController.forward();
                        },
                        onExit: (details) {
                          widget.animationController.reverse();
                        },
                        child: Listener(
                          onPointerSignal: (signal) =>
                          signal is PointerScrollEvent
                              ? scrollEvent(signal.scrollDelta.direction)
                              : false,
                          child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1000,
                                      offset: const Offset(0, 0),
                                    ),
                                  ]
                              ),
                              height: widget.animationController.value > 0 ? 22.5.toVWLength
                                  .toPX(constraint: widget.screenSize.width,
                                screenSize: widget.screenSize,) : 17.5.toVWLength.toPX(
                                constraint: widget.screenSize.width,
                                screenSize: widget.screenSize,),
                              width: 100.toVWLength.toPX(
                                constraint: widget.screenSize.width,
                                screenSize: widget.screenSize,),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    top: widget.animationController.value > 0 ? 5.toVWLength
                                        .toPX(constraint: widget.screenSize.width,
                                      screenSize: widget.screenSize,) : 0,
                                    left: 1.6.toVWLength.toPX(
                                      constraint: widget.screenSize.width,
                                      screenSize: widget.screenSize,),
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.only(right: 1.toVWLength.toPX(
                                        constraint: widget.screenSize.width,
                                        screenSize: widget.screenSize,)),
                                      controller: scrollController,
                                      clipBehavior: Clip.none,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: [
                                            ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: widget.gameController.gameList
                                                  .isEmpty ? 0 : widget.gameController
                                                  .gameList.length - 1,
                                              itemBuilder: (_, index) =>
                                                  GameCard(
                                                      index + 1,
                                                      widget.gameController.gameList,
                                                      widget.enableRemove
                                                  ),
                                            )
                                          ]
                                      ),
                                    ),),
                                  AnimatedBuilder(animation: widget.animationController,
                                      builder: (context, child) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  1.5.toVWLength.toPX(
                                                    constraint: widget.screenSize.width,
                                                    screenSize: widget.screenSize,),
                                                  2.toVWLength.toPX(
                                                    constraint: widget.screenSize.width,
                                                    screenSize: widget.screenSize,), 0, 0),
                                              child: Text("Your games", style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                    opacityAnimation.value),
                                                fontSize: 1.5.toVWLength.toPX(
                                                  constraint: widget.screenSize.width,
                                                  screenSize: widget.screenSize,),
                                                fontWeight: FontWeight.bold,
                                                shadows: <Shadow>[
                                                  Shadow(
                                                    offset: const Offset(0.0, 0.0),
                                                    blurRadius: 20.0,
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 1).withOpacity(
                                                        opacityAnimation.value),
                                                  ),
                                                ],
                                              ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              alignment: Alignment.center,
                                              height: 2.5.toVWLength.toPX(
                                                constraint: widget.screenSize.width,
                                                screenSize: widget.screenSize,),
                                              margin: EdgeInsets.fromLTRB(0,
                                                  2.toVWLength.toPX(
                                                    constraint: widget.screenSize.width,
                                                    screenSize: widget.screenSize,),
                                                  1.5.toVWLength.toPX(
                                                    constraint: widget.screenSize.width,
                                                    screenSize: widget.screenSize,), 0),
                                              child: InkWell(
                                                  onTap: () {
                                                    widget.callback();
                                                  },
                                                  child: Text(
                                                    "+ Add game", style: TextStyle(
                                                    color: Colors.white.withOpacity(
                                                        opacityAnimation.value),
                                                    fontSize: 1.5.toVWLength.toPX(
                                                      constraint: widget.screenSize.width,
                                                      screenSize: widget.screenSize,),
                                                    fontWeight: FontWeight.bold,
                                                    shadows: <Shadow>[
                                                      Shadow(
                                                        offset: const Offset(0.0, 0.0),
                                                        blurRadius: 20.0,
                                                        color: const Color.fromARGB(
                                                            255, 0, 0, 1).withOpacity(
                                                            opacityAnimation.value),
                                                      ),
                                                    ],
                                                  ),)
                                              ),
                                            )
                                          ],
                                        );
                                      })
                                ],
                              )
                          ),
                        )
                    )
                );
              })
        ],
      ),
    );
  }
}
