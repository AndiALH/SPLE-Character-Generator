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
    'class': 'warrior',
  };

  Map<String, int?> numberFormInput = {
    'health': 10,
    'mp': 10,
    'level': 1,
    'attack': 1,
    'defense': 1,
    'speed': 1,
  };

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
                    const Padding(padding: EdgeInsets.all(20)),

                    const Divider(),
                    const Text("Basic Stats"),
                    _characterFormNumberInput('Health', true),
                    const Padding(padding: EdgeInsets.all(10)),
                    _characterFormNumberInput('MP', false),
                    const Padding(padding: EdgeInsets.all(10)),
                    _characterFormNumberInput('Level', false),
                    const Padding(padding: EdgeInsets.all(20)),

                    const Divider(),
                    const Text("Extra Stats (Optional)"),
                    _characterFormNumberInput('Attack', true),
                    const Padding(padding: EdgeInsets.all(10)),
                    _characterFormNumberInput('Defense', true),
                    const Padding(padding: EdgeInsets.all(10)),
                    _characterFormNumberInput('Speed', true),
                    const Padding(padding: EdgeInsets.all(20)),

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

    return TextFormField(
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
            stringFormInput[fieldName.toLowerCase()] = null;
          }
        }
        return null;
      },
      onSaved: (String? value) {
        //_name = value.toString();
        if (value != null && value.isNotEmpty) {
          stringFormInput.remove(fieldName.toLowerCase());
        }
      },
    );
  }

  Widget _characterFormNumberInput(String fieldName, bool required) {
    String label = fieldName;
    if (!required) {
      label = label + " (Optional)";
    }

    return TextFormField(
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
    );
  }
}
