import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPLE Character Generator',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SPLE Character Generator Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // all the string variables to save the form value here
  Map<String, String?> stringFormInput = {
    'name': 'character',
  };

  List stringList = [""];

  // all the int variables to save the form value here
  Map<String, int?> numberFormInput = {
    'health': 10,
    'mp': 10,
    'level': 1,
    'attack': 1,
    'defense': 1,
    'speed': 1,
  };

  List numberList = [""];

  List extraStats = [
    'attack',
    'defense',
    'speed',
  ];

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          child: Text("Warrior Male"), value: "warrior_m.png"),
      const DropdownMenuItem(
          child: Text("Warrior Female"), value: "warrior_f.png"),
      const DropdownMenuItem(child: Text("Mage Male"), value: "mage_m.png"),
      const DropdownMenuItem(child: Text("Mage Female"), value: "mage_f.png"),
      const DropdownMenuItem(child: Text("Healer Male"), value: "healer_m.png"),
      const DropdownMenuItem(
          child: Text("Healer Female"), value: "healer_f.png"),
      const DropdownMenuItem(child: Text("Ranger Male"), value: "ranger_m.png"),
      const DropdownMenuItem(
          child: Text("Ranger Female"), value: "ranger_f.png"),
      const DropdownMenuItem(child: Text("Ninja Male"), value: "ninja_m.png"),
      const DropdownMenuItem(child: Text("Ninja Female"), value: "ninja_f.png"),
      const DropdownMenuItem(
          child: Text("Townfolk Male"), value: "townfolk1_m.png"),
      const DropdownMenuItem(
          child: Text("Townfolk Female"), value: "townfolk1_f.png"),
    ];
    return menuItems;
  }

  // String selectedValue = "warrior_m.png";
  String? selectedSpriteValue = null;

  // Global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  void _processStats() {
    // to process and save all of the input stats

    setState(() {
      //print("Character stats has been saved");

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        // to get key list from all the attributes
        stringList = stringFormInput.keys.toList();
        numberList = numberFormInput.keys.toList();

        showDialog(
          context: context,
          builder: (BuildContext context) => _confirmBuildDialog(context),
        );
      }
    });
  }

  void _generateCharacter() {
    // to start generating character objects based on input stats

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating Character')),
    );

    // To copy template that is gonna used to generate object
    copyTemplate();

    String charName = "Player";
    bool nameChanged = false;
    stringFormInput.forEach((key, value) {
      if (key == 'name' && value != 'Player') {
        charName = value.toString();
        nameChanged = true;
      }
      addNewStringAttribute(key, value.toString());
    });

    numberFormInput.forEach((key, value) {
      if (key == 'health') {
        editHealthValue(value.toString());
      } else if (key == 'mp' || key == 'level') {
        addNewIntAttribute(key, value.toString());
      } else {
        addNewIntAttribute("stat_" + key, value.toString());
      }
    });

    // to change sprite of the character
    if (selectedSpriteValue != "warrior_m.png") {
      changeCharacterSprite(selectedSpriteValue.toString());
    }

    if (nameChanged) editFileNameAndPath(charName);

    // create output by copying all edited files
    generateOutput();

    // use to put the output file in the download directory instead
    // downloadFile();
  }

  void copyTemplate() {
    // to copy the object template which will be used

    // need to clear the directory first
    try {
      Directory('assets/generated/').deleteSync(recursive: true);
    } on FileSystemException {}
    // and then copy the template directory
    copyPathSync('assets/templates/', 'assets/generated/');
  }

  void generateOutput() {
    // to generate the processed template object

    // need to clear the directory first
    try {
      Directory('assets/output/').deleteSync(recursive: true);
    } on FileSystemException {}
    // and then copy the edited file to the output folder
    copyPathSync('assets/generated/', 'assets/output/');
  }

  // to get all the files that are gonna be edited:

  File get _playergd {
    // return File('assets/templates/player.txt');
    return File('assets/generated/Scripts/Player.gd');
  }

  File get _playertscn {
    // return File('assets/templates/player.txt');
    return File('assets/generated/Scenes/Player.tscn');
  }

  File get _playerHealthgd {
    // return File('assets/templates/player.txt');
    return File(
        'assets/generated/Scenes/rpg_combat/combatants/health/PlayerHealth.gd');
  }

  File get _playerHealthtscn {
    // return File('assets/templates/player.txt');
    return File(
        'assets/generated/Scenes/rpg_combat/combatants/health/PlayerHealth.tscn');
  }

  File get _playerCombatantgd {
    // return File('assets/templates/player.txt');
    return File(
        'assets/generated/Scenes/rpg_combat/combatants/PlayerCombatant.gd');
  }

  File get _playerCombatanttscn {
    // return File('assets/templates/player.txt');
    return File(
        'assets/generated/Scenes/rpg_combat/combatants/PlayerCombatant.tscn');
  }

  File get _combatanttscn {
    // return File('assets/templates/player.txt');
    return File('assets/generated/Scenes/rpg_combat/combatants/Combatant.tscn');
  }

  void editHealthValue(String value) {
    // to edit the health value of the game object

    File file = _playerHealthgd;

    int order = 6;
    int counter = 0;
    String texts = "";
    List contents = file.readAsLinesSync();
    contents.forEach((line) {
      counter += 1;
      if (counter == order) {
        texts = texts + "export var life = $value" + "\n";
      } else if (counter == order + 1) {
        texts = texts + "export var max_life = $value" + "\n";
      } else {
        texts = texts + line + "\n";
      }
    });

    file.writeAsStringSync(texts, mode: FileMode.write);
  }

  void addNewStringAttribute(String key, String value) {
    // to add new string attribute to the game object

    File file = _playerCombatantgd;

    // change variable name for "name" because its generic
    if (key == "name") key = "char_name";

    file.writeAsStringSync("const $key = \"$value\"\n", mode: FileMode.append);
  }

  void addNewIntAttribute(String key, String value) {
    // to add new integer attribute to the game object

    File file = _playerCombatantgd;

    file.writeAsStringSync("export (int) var $key = $value\n",
        mode: FileMode.append);
  }

  void changeCharacterSprite(String spriteValue) {
    File file = _playergd;
    String line = "\tvar texture = \"$spriteValue\"";
    changeScriptLine(file, line, 14);
  }

  void editFileNameAndPath(String name) async {
    // to edit all the name and the path reference of certain files

    File playergd = _playergd;
    File playertscn = _playertscn;
    File playerHealthgd = _playerHealthgd;
    File playerHealthtscn = _playerHealthtscn;
    File playerCombatantgd = _playerCombatantgd;
    File playerCombatanttscn = _playerCombatanttscn;

    // no change, but has reference to PlayerHealth.tscn
    File combatanttscn = _combatanttscn;

    // change the file name
    changeFileNameOnlySync(playergd, name + ".gd");
    changeFileNameOnlySync(playerHealthgd, name + "Health.gd");

    // change the file name and assign them back for another uses
    playerCombatantgd =
        changeFileNameOnlySync(playerCombatantgd, name + "Combatant.gd");
    playertscn = changeFileNameOnlySync(playertscn, name + ".tscn");
    playerHealthtscn =
        changeFileNameOnlySync(playerHealthtscn, name + "Health.tscn");
    playerHealthtscn =
        changeFileNameOnlySync(playerHealthtscn, name + "Health.tscn");
    playerCombatanttscn =
        changeFileNameOnlySync(playerCombatanttscn, name + "Combatant.tscn");

    String playertscnLine =
        "[ext_resource path=\"res://Scripts/$name.gd\" type=\"Script\" id=2]";
    String playerHealthtscnLine =
        "[ext_resource path=\"res://Scenes/rpg_combat/combatants/health/${name}Health.gd\" type=\"Script\" id=1]";
    String playerCombatanttscnLine =
        "[ext_resource path=\"res://Scenes/rpg_combat/combatants/${name}Combatant.gd\" type=\"Script\" id=1]";

    String playerCombatanttscnLine2 =
        "[ext_resource path=\"res://Scenes/rpg_combat/combatants/health/${name}Health.tscn\" type=\"PackedScene\" id=3]";
    String combatanttscnLine =
        "[ext_resource path=\"res://Scenes/rpg_combat/combatants/health/${name}Health.tscn\" type=\"PackedScene\" id=2]";

    String playertscnLine2 = "[node name=\"$name\" instance=ExtResource( 1 )]";
    String playerHealthtscnLine2 =
        "[node name=\"${name}Health\" type=\"Node\"]";
    String playerCombatanttscnLine3 =
        "[node name=\"${name}Combatant\" type=\"Node2D\"]";
    String playerCombatanttscnLine4 =
        "[node name=\"${name}Health\" parent=\".\" instance=ExtResource( 3 )]";
    String combatanttscnLine2 =
        "[node name=\"${name}Health\" parent=\".\" instance=ExtResource( 2 )]";

    String playerCombatantgdLine = "class_name ${name}Combatant";

    // change scene reference to script
    changeScriptLine(playertscn, playertscnLine, 4);
    changeScriptLine(playerHealthtscn, playerHealthtscnLine, 3);
    changeScriptLine(playerCombatanttscn, playerCombatanttscnLine, 3);

    // change scene reference to another related scene
    changeScriptLine(playerCombatanttscn, playerCombatanttscnLine2, 5);
    changeScriptLine(combatanttscn, combatanttscnLine, 4);

    // change the node name on the scene
    changeScriptLine(playertscn, playertscnLine2, 6);
    changeScriptLine(playerHealthtscn, playerHealthtscnLine2, 5);
    changeScriptLine(playerCombatanttscn, playerCombatanttscnLine3, 7);
    changeScriptLine(playerCombatanttscn, playerCombatanttscnLine4, 14);
    changeScriptLine(combatanttscn, combatanttscnLine2, 10);

    // change class name on the script
    changeScriptLine(playerCombatantgd, playerCombatantgdLine, 3);
  }

  // source: https://api.flutter.dev/flutter/dart-io/File/renameSync.html
  // , https://stackoverflow.com/a/59896674
  File changeFileNameOnlySync(File file, String newFileName) {
    // to rename a file

    String dir = path.dirname(file.path);
    String newPath = dir + "/" + newFileName;
    //print('NewPath: ${newPath}');
    return file.renameSync(newPath);
  }

  void changeScriptLine(File file, String text, int order) {
    // to change a line of a file

    int counter = 0;
    String texts = "";
    List contents = file.readAsLinesSync();
    contents.forEach((line) {
      counter += 1;
      if (counter == order) {
        texts = texts + text + "\n";
      } else {
        texts = texts + line + "\n";
      }
    });

    file.writeAsStringSync(texts, mode: FileMode.write);
  }

  Future<String> get _downloadPath async {
    // to get download directory (currently unused)
    Directory? directory = await getDownloadsDirectory();

    if (directory != null) {
      return directory.path;
    }
    // if download directory not found, change to documents directory
    else {
      directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  void downloadFile() async {
    // to generate output on the download directory (currently unused)
    final path = await _downloadPath;
    copyPath('assets/generated/', '$path/generated_object');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: const Center(
                  child: Text(
                'Character Generator',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              )),
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Add TextFormFields and ElevatedButton here.
                    const Padding(padding: EdgeInsets.all(10)),
                    _characterFormTextInput('Name', true),

                    // dropdown for sprites selection
                    Container(
                      padding: EdgeInsets.all(20),
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          hint: Text("Select a sprite for your character"),
                          value: selectedSpriteValue,
                          validator: (value) =>
                              value == null ? "Please select a sprite" : null,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSpriteValue = newValue!;
                            });
                          },
                          items: dropdownItems),
                    ),

                    const Padding(padding: EdgeInsets.all(10)),

                    const Divider(),
                    const Text("Basic Stats"),
                    _characterFormNumberInput('Health', true, true),
                    _characterFormNumberInput('MP', false, true),
                    _characterFormNumberInput('Level', false, true),
                    const Padding(padding: EdgeInsets.all(10)),

                    const Divider(),
                    const Text("Extra Stats (Optional)"),

                    ColumnBuilder(
                      itemCount: extraStats.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Flexible(
                                child: _characterFormNumberInput(
                                    extraStats[index], true, false),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    numberFormInput.remove(extraStats[index]);
                                    extraStats.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.remove),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Add Custom Stats"),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildAddStatsDialog(context),
                            );
                          },
                        ),
                      ),
                    ),

                    const Padding(padding: EdgeInsets.all(30)),

                    // For testing purposes
                    // Text("Name : " + stringFormInput["name"].toString()),
                    // const Padding(padding: EdgeInsets.all(5)),
                    // Text("Health : " + numberFormInput["health"].toString()),
                    // const Padding(padding: EdgeInsets.all(5)),
                    // Text("MP : " + numberFormInput["mp"].toString()),
                    // const Padding(padding: EdgeInsets.all(5)),
                    // Text("Level : " + numberFormInput["level"].toString()),
                    // const Padding(padding: EdgeInsets.all(5)),
                    // Text("Attack : " + numberFormInput["attack"].toString()),
                    // const Padding(padding: EdgeInsets.all(5)),
                    // Text("Defense : " + numberFormInput["defense"].toString()),
                    // const Padding(padding: EdgeInsets.all(5)),
                    // Text("Speed : " + numberFormInput["speed"].toString()),
                    // const Padding(padding: EdgeInsets.all(5)),
                    // Text("Extra Stats : " + extraStats.length.toString()),
                    // const Padding(padding: EdgeInsets.all(5)),
                    // Text(
                    //     "Total Stats : " + (numberFormInput.length).toString()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _processStats,
        label: const Text('Generate'),
        tooltip: 'Generate Character',
        icon: const Icon(Icons.accessibility),
      ),
    );
  }

  Widget _characterFormTextInput(String fieldName, bool required) {
    String label = fieldName;
    if (!required) {
      label = label + " (Optional)";
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          //border: UnderlineInputBorder(),
        ),
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (required) {
              return 'Please do not leave the field empty';
            } else {
              // Do something that mark that the attributes arent included
              //stringFormInput[fieldName.toLowerCase()] = null;
              stringFormInput.remove(fieldName.toLowerCase());
            }
          }
          return null;
        },
        onSaved: (String? value) {
          //_name = value.toString();
          if (value != null && value.isNotEmpty) {
            stringFormInput[fieldName.toLowerCase()] = value;
          }
        },
      ),
    );
  }

  Widget _characterFormNumberInput(
      String fieldName, bool required, bool moreThanZero) {
    String label = fieldName;
    if (!required) {
      label = label + " (Optional)";
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          //border: UnderlineInputBorder(),
        ),
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (required) {
              return 'Please do not leave the field empty';
            } else {
              // Do something that mark that the attributes arent included
              numberFormInput.remove(fieldName.toLowerCase());
            }
          } else if (moreThanZero && int.parse(value) < 1) {
            return 'Value cannot be less than 1';
          }
          return null;
        },
        onSaved: (value) {
          //_name = value.toString();
          if (value != null && value.isNotEmpty) {
            numberFormInput[fieldName.toLowerCase()] =
                int.parse(value.toString());
          }
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }

  Widget _buildAddStatsDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('Add New Stats'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        //const Text('Insert your new stats name'),
        AddStatsForm(
          list: extraStats,
          onStatsInput: (String stats) {
            setState(() {
              extraStats.add(stats);
            });
          },
        ),
      ]),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 17),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
      elevation: 16,
    );
  }

  Widget _confirmBuildDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('Confirm Character Build'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Stats of your character'),
          const Padding(padding: EdgeInsets.all(5)),
          ColumnBuilder(
            itemCount: stringFormInput.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(1),
                child: Text(stringList[index] +
                    " : " +
                    stringFormInput[stringList[index]].toString()),
              );
            },
          ),
          ColumnBuilder(
            itemCount: numberFormInput.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(1),
                child: Text(numberList[index] +
                    " : " +
                    numberFormInput[numberList[index]].toString()),
              );
            },
          ),
          Container(
              padding: const EdgeInsets.all(1),
              child: Text("sprite : " + selectedSpriteValue.toString())),
        ]),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 17),
          ),
          onPressed: _generateCharacter,
          child: const Text('Generate Character'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 17),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
      elevation: 16,
    );
  }
}

class ColumnBuilder extends StatelessWidget {
  // Source code: https://gist.github.com/slightfoot/a75d6c368f1b823b594d9f04bf667231
  final IndexedWidgetBuilder? itemBuilder;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;
  final int? itemCount;

  const ColumnBuilder({
    Key? key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.mainAxisAlignment: MainAxisAlignment.start,
    this.mainAxisSize: MainAxisSize.max,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection: VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: new List.generate(
              this.itemCount!, (index) => this.itemBuilder!(context, index))
          .toList(),
    );
  }
}

typedef StatsCallback = void Function(String stats);

class AddStatsForm extends StatefulWidget {
  const AddStatsForm({Key? key, required this.list, required this.onStatsInput})
      : super(key: key);

  final List list;
  final StatsCallback onStatsInput;

  @override
  State<AddStatsForm> createState() => _AddStatsFormState();
}

class _AddStatsFormState extends State<AddStatsForm> {
  // to save stats names
  String statsName = '';

  // to save all the reserved names that can't be used
  List reservedNames = [
    'name',
    'hp',
    'mp',
    'level',
  ];

  // Global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _statsFormKey = GlobalKey<FormState>();

  String _saveAndReturnValue() {
    if (_statsFormKey.currentState!.validate()) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Adding Stats')),
      // );
      _statsFormKey.currentState!.save();
      widget.onStatsInput(statsName);
    }
    return statsName;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Form(
            key: _statsFormKey,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Stats Name",
                //border: UnderlineInputBorder(),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please do not leave the field empty';
                } else if (widget.list.contains(value.toLowerCase()) ||
                    reservedNames.contains(value.toLowerCase())) {
                  return 'Stats already exists';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  statsName = value.toLowerCase();
                }
              },
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 17),
            ),
            onPressed: () {
              setState(() {
                _saveAndReturnValue();
                //print(statsName);
              });
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
