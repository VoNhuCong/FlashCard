import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'store.dart';

class Library extends StatefulWidget {
  const Library({super.key, required this.storage});

  final CounterStorage storage;

  @override
  _Library createState() => _Library();

}

class _Library extends State<Library> {

  List<String> _word = [];

  final _inputText = TextEditingController();

  final  _focusInput = FocusNode();

  List<InkWell> _wordInkList = [];

  @override
  void initState() {
    super.initState();
    widget.storage.readWords().then((value) {
      setState(() {
        _word = value;
        _focusInput.requestFocus();
        _wordInkList = GenWordInkList();
      });
    });
  }

  String getRandomWord () {
    var random = Random();
    int randomNumber = random.nextInt(_word.length);
    return _word.elementAt(randomNumber);
  }

  void updateState(){
    widget.storage.readWords().then((value) {
      setState(() {
        _word = value;
        _focusInput.requestFocus();
        _wordInkList = GenWordInkList();
        _inputText.clear();
        _inputText.clearComposing();
      });
    });
  }

  List<InkWell> GenWordInkList() {
    List<InkWell> words = [];
    for (int i = _word.length - 1; i >= 0; i--) {
      String curWord = _word.elementAt(i);
      InkWell wordInkWell = InkWell(
        onTap: () {
          print("something $i");
        },
        child: Container(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            curWord,
            style: const TextStyle(fontSize: 22.0),
          ),
        ))),
      );

      words.add(wordInkWell);
    }
    return words;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Library"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: TextField(
                            focusNode: _focusInput,
                          onEditingComplete: () {
                            print("onEditingComplete");
                            if(_inputText.text != ""){
                              widget.storage.writeWord(_inputText.text);
                            }
                            _inputText.clear();
                            updateState();
                          },
                          controller: _inputText,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'New word',
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                          flex: 2,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(50, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              onPressed: () {
                                if(_inputText.text != ""){
                                  widget.storage.writeWord(_inputText.text);
                                  updateState();
                                }
                              },
                              child: const Text("Add")))
                    ],
                  ),
                )),
            Expanded(
                flex: 9,
                child: Container(
                    // padding: const EdgeInsets.all(16.0), // set padding for all dimension
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    color: Colors.white70,
                    child: ListView(children: _wordInkList)
                )
            )],
        )
    );
  }
}
