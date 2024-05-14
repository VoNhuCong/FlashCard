import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:second_pro/store.dart';
import 'package:flutter/material.dart';
import 'library.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _word = "Cong";
  bool _isGifVisible = false;
  bool _isWordVisible = false;
  List<String> _words = [];

  final store = CounterStorage();

  @override
  void initState() {
    super.initState();
    updateWord();
  }

  void updateWord(){
    store.readWords().then((value) {
      setState(() {
        _words = value;
      });
    });
  }

  String randomWord() {
    String word = "";
    var random = Random();
    int randomNumber = random.nextInt(_words.length - 1);
    word = _words.elementAt(randomNumber);
    return word;
  }

  void setWord(String word) {
    setState(() {
      _word = word;
    });
  }

  void setWordVisible(bool isV) {
    setState(() {
      _isWordVisible = isV;
    });
  }

  void setGifVisible(bool isVisible) {
    setState(() {
      _isGifVisible = isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 9,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "What is the word mean?",
                        style: TextStyle(
                            fontSize: 26, fontFamily: 'DancingScript'),
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: _isWordVisible,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent, width: 3), // Màu và độ dày của viền
                            borderRadius: BorderRadius.circular(25), // Độ cong của viền
                          ),
                            child: Text(
                              _word,
                              style: const TextStyle(
                                  fontSize: 50, fontFamily: 'DancingScript', color: Colors.blueAccent
                              ),
                            ),
                          ),

                      ),
                      Visibility(
                        visible: _isGifVisible,
                        child: Image.asset(
                          "resources/gif/vitualhug.gif",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            updateWord();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Library(storage: store),
                                ));
                          },
                          child: const Text("Thư viện"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setWordVisible(false);
                            setGifVisible(true);
                            Future.delayed(const Duration(seconds: 3), () {
                              setGifVisible(false);
                              setWord(randomWord());
                              setWordVisible(true);
                            });
                            //_library
                          },
                          child: const Text("Bắt đầu"),
                        )
                      ],
                    )))
          ],
        ));
  }
}
