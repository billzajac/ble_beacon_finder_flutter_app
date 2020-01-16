
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  //int _range = 0;
  //StreamSubscription<RangingResult> _streamRanging;

  _initScanning() async {
    try {
      // https://pub.dev/packages/flutter_beacon
      // if you want to manage manual checking about the required permissions
      //   await flutterBeacon.initializeScanning;
      // or if you want to include automatic checking permission
      await flutterBeacon.initializeAndCheckScanning;
    } on PlatformException catch(e) {
      // library failed to initialize, check code and message
      debugPrint('initializeScanning Failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initScanning(); //running initialisation code for beacon scanning
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;
      _counter = _counter + 2;

      // https://pub.dev/packages/flutter_beacon
      //const beaconId = "wind-up";

      final regions = <Region>[];

      if (Platform.isIOS) {
        regions.add(Region(
            identifier: 'Apple Airlocate',
            proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
      } else {
        // android platform, it can ranging out of beacon that filter all of Proximity UUID
        regions.add(Region(identifier: 'com.beacon'));
      }

// to start ranging beacons
      _streamRanging = flutterBeacon.ranging(regions).listen((RangingResult result) {
        // result contains a region and list of beacons found
        // list can be empty if no matching beacons were found in range
      });

// to stop ranging beacons
      _streamRanging.cancel();

      // https://stackoverflow.com/questions/43813386/how-to-play-a-custom-sound-in-flutter
      // https://pub.dev/packages/audioplayers
      // Play the ping
      AudioCache player = new AudioCache();
      const alarmAudioPath = "ping.mp3";
      player.play(alarmAudioPath);
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
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
