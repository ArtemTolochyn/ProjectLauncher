import 'dart:ui';
import 'package:flutter/material.dart';

export "package:project_launcher/widgets/components/editButton.dart" hide editButtonAsset;

class editButton extends StatelessWidget {
  final double width;
  final String text;
  final VoidCallback onPressed;
  final EdgeInsets? margin;
  const editButton({this.margin, required this.width, required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: margin,
      width: width,
      child: InkWell(
        onTap: onPressed,
        child: _editButtonAsset(width, text),
      ),
    );
  }
}


class _editButtonAsset extends StatefulWidget {
  final double width;
  final String text;
  const _editButtonAsset( this.width, this.text, {super.key});

  @override
  State<_editButtonAsset> createState() => _editButtonAssetState();
}

class _editButtonAssetState extends State<_editButtonAsset> with TickerProviderStateMixin {

  bool status = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: widget.width,
      child: MouseRegion(
        onEnter: (pointer) => setState(() {
          status = true;
        }),
        onExit: (pointer) => setState(() {
          status = false;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: status == false? Colors.black.withOpacity(0.25): Colors.white,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Text(
            widget.text,
            style: TextStyle(
                color: status == false? Colors.white: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
