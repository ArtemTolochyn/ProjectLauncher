import 'package:flutter/material.dart';
import 'package:project_launcher/pages/homePage.dart';
import 'package:project_launcher/utils/gameController.dart';


Future<void> main() async {
  GameController gameController = GameController();

  runApp(MaterialApp(
    home: HomePage(
      gameController: gameController,
    ),
  ));
}