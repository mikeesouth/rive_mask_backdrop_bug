import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 3.19',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Impeller issue with backdrop filter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const width = 300.0;
  static const height = 200.0;

  static Artboard? _riveArtboard1;
  static Artboard? _riveArtboard2;

  @override
  void initState() {
    super.initState();

    _loadArtboard();
  }

  void _loadArtboard() async {
    final riveFileData1 = await rootBundle.load('assets/test1.riv');
    final riveFile1 = RiveFile.import(riveFileData1);
    final riveFileData2 = await rootBundle.load('assets/test2.riv');
    final riveFile2 = RiveFile.import(riveFileData2);

    setState(() {
      _riveArtboard1 = riveFile1.artboardByName('test');
      _riveArtboard2 = riveFile2.artboardByName('test');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Row(
              children: [
                const SizedBox(
                  width: width,
                  height: height,
                  child: RiveAnimation.network(
                    'https://cdn.rive.app/animations/vehicles.riv',
                  ),
                ),
                SizedBox(
                  width: width,
                  height: height,
                  child: _riveArtboard1 != null
                      ? Rive(artboard: _riveArtboard1!)
                      : Container(color: Colors.orange),
                ),
                SizedBox(
                  width: width,
                  height: height,
                  child: _riveArtboard2 != null
                      ? Rive(artboard: _riveArtboard2!)
                      : Container(color: Colors.orange),
                ),
              ],
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 100),
                width: 800,
                height: 400,
                color: Colors.white,
                padding: const EdgeInsets.all(15),
                child: const Text(
                  '''The three rive assets above should be blurred and dimmed by the backdrop filter.

- The left one (the bus) works correctly.

- The middle one (test1.riv) contains one clipping shape and it also works correct.

- The right one (test2.riv) contains two clipping shapes and it is not blurred or dimmed in Impeller on iOS, it works on Android, web and non-impeller on iOS. It also worked before the backdrop filter optimizations in Flutter 3.19 (so it works in 3.16.X)''',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
