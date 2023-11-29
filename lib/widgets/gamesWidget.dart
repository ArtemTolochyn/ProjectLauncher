import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:project_launcher/utils/globals.dart' as globals;
import 'components/gameButton.dart';

class gamesWidget extends StatefulWidget {
  final List gameList;
  final Size screenSize;
  final Animation<double> opacityText;
  final AnimationController animationController;
  final Widget child;
  const gamesWidget(this.gameList, this.screenSize, this.opacityText, this.animationController, {required this.child, super.key});

  @override
  State<gamesWidget> createState() => _gamesWidgetState();
}

class _gamesWidgetState extends State<gamesWidget> with TickerProviderStateMixin {
  late ScrollController scrollController;
  double scroll = 0;

  @override
  void initState() {

    super.initState();
    scrollController = ScrollController();
  }

  void scrollEvent(signal)
  {
    if (signal > 0)
    {
      if (scroll <= 32.3.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,) * (widget.gameList.length - 5))
        {
          scroll = scroll + 32.3.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,);
          scrollController.animateTo(scroll, duration: const Duration(microseconds: 200000), curve: Curves.easeOut);
        }
    }
    else
    {
      if (scroll >= 32.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,))
      {
        scroll = scroll - 32.3.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,);
        scrollController.animateTo(scroll, duration: const Duration(microseconds: 200000), curve: Curves.easeOut);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Listener(
      onPointerSignal: (signal) => signal is PointerScrollEvent? scrollEvent(signal.scrollDelta.direction): false,
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
          height: widget.animationController.value > 0 ? 22.5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,) : 17.5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,),
          width: 100.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,),
          child: Stack(
            children: [
              Positioned.fill(
                top: widget.animationController.value > 0 ? 5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,) : 0,
                left: 1.6.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,),
                child: SingleChildScrollView(
                    padding: EdgeInsets.only(right: 1.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,)),
                    controller: scrollController,
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.gameList.isEmpty? 0: widget.gameList.length - 1,
                            itemBuilder: (_, index) => gameButton(index + 1, widget.gameList),
                          )
                        ]
                    ),
                ),),
              AnimatedBuilder(animation: widget.animationController, builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(1.5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,), 2.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,), 0, 0),
                        child: Text("Your games", style: TextStyle(
                          color: Colors.white.withOpacity(widget.opacityText.value),
                          fontSize: 1.5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,),
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 20.0,
                              color: const Color.fromARGB(255, 0, 0, 1).withOpacity(widget.opacityText.value),
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
                        height: 2.5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,),
                        margin: EdgeInsets.fromLTRB(0, 2.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,), 1.5.toVWLength.toPX( constraint: widget.screenSize.width, screenSize: widget.screenSize,), 0),
                        child: widget.child
                      )
                    ],
                );
              })
            ],
          )
      ),
    );
  }
}
