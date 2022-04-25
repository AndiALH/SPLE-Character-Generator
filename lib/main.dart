import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SPLE Character Generator Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;

  // all the variables to save the form value here
  //String _name = 'Character';
  Map<String, String?> stringFormInput = {
    'name': 'character',
  };

  Map<String, int?> numberFormInput = {
    'health': 10,
    'mp': 10,
    'level': 1,
    'attack': 1,
    'defense': 1,
    'speed': 1,
  };

  List extraStats = [
    'attack',
    'defense',
    'speed',
  ];

  // Global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  void _generateCharacter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      // For testing, delete later
      print("Character has been generated");

      if (_formKey.currentState!.validate()) {
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Generating Character')),
        );
        _formKey.currentState!.save();
        //_name = "abi";
      }
    });
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
        // child: Column(
        //   // Column is also a layout widget. It takes a list of children and
        //   // arranges them vertically. By default, it sizes itself to fit its
        //   // children horizontally, and tries to be as tall as its parent.
        //   //
        //   // Invoke "debug painting" (press "p" in the console, choose the
        //   // "Toggle Debug Paint" action from the Flutter Inspector in Android
        //   // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        //   // to see the wireframe for each widget.
        //   //
        //   // Column has various properties to control how it sizes itself and
        //   // how it positions its children. Here we use mainAxisAlignment to
        //   // center the children vertically; the main axis here is the vertical
        //   // axis because Columns are vertical (the cross axis would be
        //   // horizontal).
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     const Text(
        //       'You have clicked the button this many times:',
        //     ),
        //     Text(
        //       '$_counter',
        //       style: Theme.of(context).textTheme.headline4,
        //     ),
        //     Image.asset('assets/images/0.png'),
        //   ],
        // ),
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
                    const Padding(padding: EdgeInsets.all(10)),

                    const Divider(),
                    const Text("Basic Stats"),
                    _characterFormNumberInput('Health', true),
                    _characterFormNumberInput('MP', false),
                    _characterFormNumberInput('Level', false),
                    const Padding(padding: EdgeInsets.all(10)),

                    const Divider(),
                    const Text("Extra Stats (Optional)"),
                    // _characterFormNumberInput('Attack', true),
                    // const Padding(padding: EdgeInsets.all(10)),
                    // _characterFormNumberInput('Defense', true),
                    // const Padding(padding: EdgeInsets.all(10)),
                    // _characterFormNumberInput('Speed', true),
                    // const Padding(padding: EdgeInsets.all(20)),
                    // Row(
                    //   children: [
                    //     Flexible(
                    //       child: _characterFormNumberInput('Speed', true),
                    //     ),
                    //     IconButton(
                    //       onPressed: () {
                    //         // Respond to button press
                    //       },
                    //       icon: const Icon(Icons.remove),
                    //     ),
                    //   ],
                    // ),
                    // const Padding(padding: EdgeInsets.all(20)),

                    ColumnBuilder(
                      itemCount: extraStats.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Flexible(
                                child: _characterFormNumberInput(
                                    extraStats[index], true),
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
                    Text("Name : " + stringFormInput["name"].toString()),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text("Health : " + numberFormInput["health"].toString()),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text("MP : " + numberFormInput["mp"].toString()),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text("Level : " + numberFormInput["level"].toString()),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text("Attack : " + numberFormInput["attack"].toString()),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text("Defense : " + numberFormInput["defense"].toString()),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text("Speed : " + numberFormInput["speed"].toString()),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text("Extra Stats : " + extraStats.length.toString()),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                        "Total Stats : " + (numberFormInput.length).toString()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateCharacter,
        label: const Text('Generate'),
        tooltip: 'Generate Character',
        icon: const Icon(Icons.accessibility),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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

  Widget _characterFormNumberInput(String fieldName, bool required) {
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
          } else if (int.parse(value) < 1) {
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
  // Untuk menyimpan nama stats
  String statsName = '';

  // Menyimpan nama yang tidak bisa dipakai selain dari stats
  List reservedNames = [
    'name',
    'hp',
    'mp',
    'level',
  ];

  // Global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _statsFormKey = GlobalKey<FormState>();

  // String _returnValue() {
  //   return statsName;
  // }

  String _saveAndReturnValue() {
    // For testing, delete later
    print("Stats has been added");

    if (_statsFormKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adding Stats')),
      );
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
              decoration: InputDecoration(
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
