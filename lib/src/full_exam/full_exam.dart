import 'dart:math';

import 'package:flutter/material.dart';
import '../components/voice_input.dart';

const TextStyle gFullExaminationSubTitleStyle = TextStyle(
  color: Colors.amber,
  fontSize: 55.0,
);
const int gFullExaminationWeightSingleWords = 1;
const int gFullExaminationWeightDoubleWords = 2;
const int gFullExaminationWeightSentances = 3;

class _FullExaminationState extends State<FullExamination> {
  List<VoiceInputComponent> singleComponents = [];
  List<VoiceInputComponent> doubleComponents = [];
  List<VoiceInputComponent> sentanceComponents = [];
  double finishValue = 0.0;
  LinearProgressIndicator? _processBar;
  void _calculateFinishValue() {
    int process = 0;
    int total = 0;
    for (VoiceInputComponent compo in singleComponents) {
      total += gFullExaminationWeightSingleWords;
      if (compo.recordPath != '') process += gFullExaminationWeightSingleWords;
    }
    for (VoiceInputComponent compo in doubleComponents) {
      total += gFullExaminationWeightDoubleWords;
      if (compo.recordPath != '') process += gFullExaminationWeightDoubleWords;
    }
    for (VoiceInputComponent compo in sentanceComponents) {
      total += gFullExaminationWeightSentances;
      if (compo.recordPath != '') process += gFullExaminationWeightSentances;
    }
    finishValue = process.toDouble() / total.toDouble();
  }

  void _buildVoiceInputs(List<Widget> children, List<String> wordLists,
      int columnCount, List<VoiceInputComponent>? ret) {
    int count = 0;
    List<Widget> rows = [];
    List<VoiceInputComponent> voiceInputs = [];
    for (var word in wordLists) {
      VoiceInputComponent component = VoiceInputComponent(label: word);
      voiceInputs.add(component);
      ret!.add(component);
      count++;
      if (count == columnCount) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: List<VoiceInputComponent>.from(voiceInputs),
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

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    _processBar = LinearProgressIndicator(value: finishValue);
    rows.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: _processBar,
      ),
    );
    rows.add(Row(children: [
      Text("Single Words", style: gFullExaminationSubTitleStyle)
    ]));
    _buildVoiceInputs(rows, widget.singleWords!, 4, singleComponents);
    rows.add(Row(children: [
      Text("Double Words", style: gFullExaminationSubTitleStyle)
    ]));
    _buildVoiceInputs(rows, widget.doubleWords!, 2, doubleComponents);
    rows.add(Row(
        children: [Text("Sentances", style: gFullExaminationSubTitleStyle)]));
    _buildVoiceInputs(rows, widget.sentances!, 1, sentanceComponents);
    _calculateFinishValue();
    rows.add(ElevatedButton(
      child: const Text(
        'Submit',
        style: gFullExaminationSubTitleStyle,
      ),
      onPressed: () {
        // FIXME 22.11.1
        int k = 1;
      },
    ));
    return Scaffold(
      body: ListView(children: rows),
    );
  }
}

class FullExamination extends StatefulWidget {
  List<String>? singleWords;
  List<String>? doubleWords;
  List<String>? sentances;
  static const String routeName = 'fullexam';
  FullExamination(
      {super.key,
      required this.singleWords,
      required this.doubleWords,
      required this.sentances});
  @override
  State<FullExamination> createState() => _FullExaminationState();
}
