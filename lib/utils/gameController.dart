import 'dart:io';

import 'package:process_run/process_run.dart';

class GameController
{
  var config = "${Platform.environment['HOME']!}/.config/PLauncher";
  List gameList = [];
  List gameString = [];
  List lines = [];
  late String name;
  late String description;
  late String command;
  late String top;
  late String bottom;
  late String size;

  late List folderList;
  late List folderListFixed;
  late int maxID;


  Future<List> getHistory() async {
    gameString = [];
    gameList = [];
    await File("$config/gamedata/history").readAsString()
        .then((value) => gameString = value.split('\n'));

    for (var i = 0; i < gameString.length; i++)
      {
        try {
          await File("${"$config/gamedata/" + gameString[i]}/config")
              .readAsString()
              .then((value) async =>
          {
            lines = await value.split("\n"),
            name = await lines[0].split(':')[1].trim(),
            description = await lines[1].split(':')[1].trim(),
            command = await lines[2].split(': ')[1].trim(),
            top = await lines[3].split(':')[1].trim(),
            bottom = await lines[4].split(':')[1].trim(),
            size = await lines[5].split(':')[1].trim(),
            gameList.add([i, gameString[i], name, description, command, top, bottom, size])
          });
        }
        catch(e)
        {
          //pass
        }
      }

    return gameList;
  }

  playGame(id) async
  {
    gameList = await getHistory();
    await File("$config/gamedata/history").readAsString().then((value) => File("$config/gamedata/history").writeAsString( '${gameList[id][1]}\n${value.replaceAll('\n${gameList[id][1]}', '').replaceAll('${gameList[id][1]}\n', '')}'));
    var shell = Shell();
    shell.run(gameList[id][4]);
    return;
  }

  addGame(name, command, top, bottom, size, backgroundPath, logoPath) async {
    try
    {
      folderList = [];
      folderListFixed = [];
      maxID = File("$config/gamedata/history").readAsStringSync().replaceAll("\n\n", "\n").split("\n").length;
      File("$config/gamedata/${(maxID).toString()}/config").createSync(recursive: true);
      File("$config/gamedata/${(maxID).toString()}/config").writeAsString('name: $name\ndescription: none\ncommand: $command\ntop: $top\nbottom: $bottom\nsize: $size');
      await File(backgroundPath).copy("$config/gamedata/${(maxID).toString()}/background.png");
      await File(logoPath).copy("$config/gamedata/${(maxID ).toString()}/logo.png");
      await File("$config/gamedata/history").readAsString().then((value) => File("$config/gamedata/history").writeAsString( '${maxID}\n$value'));
      return "ok";
    }
    catch(e)
    {
      return "error";
    }

  }

  editGame(id, name, description, command, top, bottom, backgroundPath, logoPath) async {
    File("$config/gamedata/$id/config").deleteSync();
    File("$config/gamedata/$id/config").createSync(recursive: true);
    File("$config/gamedata/$id/config").writeAsString('name: $name\ndescription: $description\ncommand: $command\ntop: $top\nbottom: $bottom');

    if (backgroundPath != "false")
    {
      await File(backgroundPath).copySync("$config/gamedata/$id/background.png");
    }
    if (logoPath != "false")
    {
      await File(logoPath).copySync("$config/gamedata/$id/logo.png");
    }
  }

  removeGame(id) async {
    Directory("$config/gamedata/$id").deleteSync(recursive: true);
  }

}