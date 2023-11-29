import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter_svg/svg.dart';

class playButton extends StatefulWidget {
  final Size screenSize;
  final String config;
  final String theme;
  const playButton(this.screenSize, this.config, this.theme, {super.key});

  @override
  State<playButton> createState() => _playButtonState();
}

class _playButtonState extends State<playButton> with TickerProviderStateMixin {
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
    return Align(
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
    );
  }
}
