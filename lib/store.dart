import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print("Kiem tra duowng dan");
    print(path);
    return File('$path/words.txt');
  }

  Future<List<String>> readWords() async {
    try {
      final file = await _localFile;

      // Read the file
      List<String> contents = await file.readAsLines();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      print(e);
      return [];
    }
  }

  Future<File> writeWord(String word) async {
    final file = await _localFile;
    return file.writeAsString("$word\n", mode: FileMode.writeOnlyAppend);
  }
}