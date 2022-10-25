import 'dart:math';

import 'package:flutter/material.dart';
import '../components/voice_input.dart';

class FullExamination extends StatelessWidget {
  final List<String> singleWords;
  final List<String> doubleWords;
  final List<String> sentances;
  FullExamination(
      {super.key,
      required this.singleWords,
      required this.doubleWords,
      required this.sentances});

  void _buildVoiceInputs(
      List<Row> children, List<String> wordLists, int columnCount) {
    int count = 0;
    List<Row> rows = [];
    List<Column> voiceInputs = [];
    for (var word in wordLists) {
      voiceInputs.add(
        Column(children: [VoiceInputComponent(label: word)]),
      );
      count++;
      if (count == columnCount) {
        rows.add(Row(
          children: voiceInputs,
        ));
        voiceInputs.clear();
        count = 0;
      }
    }
    if (count != 0) {
      rows.add(Row(
        children: voiceInputs,
      ));
    }
    children.addAll(rows);
  }

  final TextStyle _titleStyle = const TextStyle(
    color: Colors.amber,
    fontSize: 55.0,
  );

  @override
  Widget build(BuildContext context) {
    List<Row> rows = [];
    rows.add(Row(children: [Text("Single Words", style: _titleStyle)]));
    _buildVoiceInputs(rows, singleWords, 4);
    rows.add(Row(children: [Text("Double Words", style: _titleStyle)]));
    _buildVoiceInputs(rows, doubleWords, 2);
    rows.add(Row(children: [Text("Sentances", style: _titleStyle)]));
    _buildVoiceInputs(rows, sentances, 1);
    return Scaffold(
      body: ListView(children: rows),
    );
  }
}
