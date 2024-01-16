import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';

class BackgroundOpacityEffect extends StatefulWidget {
  AnimationController animationController;
  Size screenSize;
  
  BackgroundOpacityEffect({super.key, required this.animationController, required this.screenSize});

  @override
  State<BackgroundOpacityEffect> createState() => _BackgroundOpacityEffectState();
}

class _BackgroundOpacityEffectState extends State<BackgroundOpacityEffect> {

  late Animation<double> opacity;

  @override
  void initState() {
    opacity = Tween<double>(begin: 0.0, end: 0.8).animate(widget.animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: AnimatedBuilder(animation: widget.animationController,
          builder: (context, child) {
            return Container(
              height: 100.toVHLength.toPX(
                constraint: widget.screenSize.height,
                screenSize: widget.screenSize
              ),
              color: Color.fromRGBO(0, 0, 0, opacity.value),
            );
          }),
    );
  }
}
