import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_launcher/utils/gameController.dart';

typedef void RemoveCallback(int foo);

class PlayButton extends StatefulWidget {
  final Size screenSize;
  final String config;
  final String theme;

  RemoveCallback enableRemove;

  GameController gameController;
  PlayButton({
    super.key,
    required this.screenSize,
    required this.config,
    required this.theme,
    required this.gameController,

    required this.enableRemove

  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> buttonAnimation;
  late Animation<double> buttonScale;
  late Animation<double> buttonOpacity;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400)
    );
    buttonAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    buttonScale = Tween<double>(begin: 4.0, end: 2.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    buttonOpacity = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      margin: EdgeInsets.only(top: 48.toVHLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize),),
      child: GestureDetector(
        onTap: () => widget.gameController.playGame(id: 0, context: context),

        onSecondaryTap: () => widget.enableRemove(0),
        child: Align(
            child: MouseRegion(
              onEnter: (info) {
                animationController.reset();
                animationController.forward();
              },
              child: SizedBox(
                height: 128,
                width: 128,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(300)
                      ),
                      child: Image.file(File("${widget.config}/themes/${widget.theme}/playButton.webp"),
                        height: 126,
                        width: 126,
                        fit: BoxFit.fill,
                        isAntiAlias: true,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    Container(
                      height: 126,
                      width: 126,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(300),
                          border: Border.all(color: Colors.red.shade700, width: 4)
                      ),
                    ),
                    AnimatedBuilder(animation: animationController,
                        builder: (context, child) {
                          return
                            Transform.scale(
                              scale: buttonAnimation.value,
                              child: Container(
                                height: 126,
                                width: 126,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(300),
                                    border: Border.all(color: Colors.red.shade700.withOpacity(buttonOpacity.value), width: buttonScale.value)
                                ),
                              ),
                            );
                        }
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: -30,
                              blurRadius: 30,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(left: 4),
                        height: 128,
                        width: 128,
                        padding: const EdgeInsets.all(43),
                        child: SvgPicture.file(File("${widget.config}/themes/${widget.theme}/playIcon.svg"))
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
