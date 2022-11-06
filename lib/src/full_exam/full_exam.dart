import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:project_soe/src/app_home/app_home.dart';
import 'package:project_soe/src/nl_choice/nl_choice.dart';
import 'package:project_soe/src/components/voice_input.dart';
import 'package:project_soe/src/data/params.dart';
import 'package:project_soe/src/data/styles.dart';
import 'package:project_soe/src/data/exam_data.dart';
/*
class FullExaminationProcess extends StatelessWidget {
  final ValueNotifier<double> finishValue;
  const FullExaminationProcess({
    super.key,
    required this.finishValue,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: finishValue,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: LinearProgressIndicator(value: finishValue.value),
        );
      },
    );
  }
}

class FullExamination extends StatelessWidget {
  final List<String>? singleWords;
  final List<String>? doubleWords;
  final List<String>? sentances;
  static const String routeName = 'fullexam';
  FullExamination(
      {super.key,
      required this.singleWords,
      required this.doubleWords,
      required this.sentances});
  // private variables
  final List<VoiceInputComponent> _singleComponents = [];
  final List<VoiceInputComponent> _doubleComponents = [];
  final List<VoiceInputComponent> _sentanceComponents = [];
  bool _isFirstBuild = true;
  final ValueNotifier<double> _finishValueNotifier = ValueNotifier<double>(0.0);
  // 计算完成度, 用于ProcessBar的显示.
  double _calculateFinishValue() {
    int process = 0;
    int total = 0;
    for (VoiceInputComponent compo in _singleComponents) {
      total += gFullExaminationWeightSingleWords;
      if (compo.recordPath != '') {
        process += gFullExaminationWeightSingleWords;
      }
    }
    for (VoiceInputComponent compo in _doubleComponents) {
      total += gFullExaminationWeightDoubleWords;
      if (compo.recordPath != '') {
        process += gFullExaminationWeightDoubleWords;
      }
    }
    for (VoiceInputComponent compo in _sentanceComponents) {
      total += gFullExaminationWeightSentances;
      if (compo.recordPath != '') {
        process += gFullExaminationWeightSentances;
      }
    }
    return process.toDouble() / total.toDouble();
  }

  // 构造VoiceInputComponent的函数, 第一次构造时将其加入List
  void _buildVoiceInputs(List<Widget> children, List<String> wordLists,
      int columnCount, List<VoiceInputComponent>? ret, bool isFirst) {
    int count = 0;
    List<Widget> rows = [];
    List<VoiceInputComponent> voiceInputs = [];
    for (var word in wordLists) {
      VoiceInputComponent component = VoiceInputComponent(label: word);
      voiceInputs.add(component);
      if (isFirst) {
        ret!.add(component);
        component.addListener(() {
          _finishValueNotifier.value = _calculateFinishValue();
        });
      }
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

  // 检查是否完成所有的试题
  bool _checkFinishAll() {
    for (VoiceInputComponent compo in _singleComponents) {
      if (compo.recordPath == '') {
        return false;
      }
    }
    for (VoiceInputComponent compo in _doubleComponents) {
      if (compo.recordPath == '') {
        return false;
      }
    }
    for (VoiceInputComponent compo in _sentanceComponents) {
      if (compo.recordPath == '') {
        return false;
      }
    }
    return true;
  }

  // TODO 弹出SnackBar 提示尚未完成测试.
  void _showUnfinishedTip(BuildContext context) {
    Navigator.pushNamed(context, ApplicationHome.routeName);
  }

  // TODO 提交测试
  void _submitFullExam(BuildContext context) {
    Navigator.pushNamed(context, ApplicationHome.routeName);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    rows.add(FullExaminationProcess(finishValue: _finishValueNotifier));
    rows.add(Row(children: const [
      Text("Single Words", style: gFullExaminationSubTitleStyle)
    ]));
    _buildVoiceInputs(rows, singleWords!, 4, _singleComponents, _isFirstBuild);
    rows.add(Row(children: const [
      Text("Double Words", style: gFullExaminationSubTitleStyle)
    ]));
    _buildVoiceInputs(rows, doubleWords!, 2, _doubleComponents, _isFirstBuild);
    rows.add(Row(children: const [
      Text("Sentances", style: gFullExaminationSubTitleStyle)
    ]));
    _buildVoiceInputs(rows, sentances!, 1, _sentanceComponents, _isFirstBuild);
    _calculateFinishValue();
    _isFirstBuild = false;
    rows.add(ElevatedButton(
      child: const Text(
        'Submit',
        style: gFullExaminationSubTitleStyle,
      ),
      onPressed: () {
        if (_checkFinishAll()) {
          _submitFullExam(context);
        } else {
          _showUnfinishedTip(context);
        }
      },
    ));
    return Scaffold(
      body: ListView(children: rows),
    );
  }
}
*/

List<List<QuestionData>> parseWordMap(http.Response response) {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final parsed = decoded['data']['cpsrcdList']
      .cast<Map<String, dynamic>>()
      .map<QuestionData>((json) => QuestionData.fromJson(json))
      .toList();
  Map<int, List<QuestionData>> map = Map<int, List<QuestionData>>.identity();
  for (QuestionData questionData in parsed) {
    if (map.containsKey(questionData.type)) {
      map[questionData.type]!.add(questionData);
    } else {
      map[questionData.type] = List<QuestionData>.empty(growable: true);
      map[questionData.type]!.add(questionData);
    }
  }
  return map.entries.map((entry) => entry.value).toList();
}

Future<List<List<QuestionData>>> fetchWordMap(
    http.Client client, String id) async {
  final response = await client.get(
    Uri.parse('http://47.101.58.72:8002/api/cpsgrp/v1/detail?cpsgrpId=$id'),
  );
  return compute(parseWordMap, response);
}

class _FullExaminationState extends State<FullExamination> {
  _FullExaminationState();
  int _index = 0;
  int _mapSize = 0;
  VoiceInputPage? _inputPage;
  List<String>? _recordList;

  void _forward() {
    if (_index <= 0) {
      return;
    } else {
      _recordList![_index] = _inputPage!.recordPath;
      setState(() {
        _index = _index - 1;
        _process.value = _index.toDouble() / _mapSize.toDouble();
      });
    }
  }

  void _next() {
    if (_index >= (_mapSize - 1)) {
      return;
    } else {
      _recordList![_index] = _inputPage!.recordPath;
      setState(() {
        _index = _index + 1;
        _process.value = _index.toDouble() / _mapSize.toDouble();
      });
    }
  }

  final ValueNotifier<double> _process = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    final examId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder<List<List<QuestionData>>>(
      future: fetchWordMap(http.Client(), examId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          _inputPage = VoiceInputPage(wordList: snapshot.data![_index]);
          _mapSize = snapshot.data!.length;
          _recordList = List<String>.generate(_mapSize, (index) => '');
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              toolbarHeight: 60.0,
              title: Column(
                children: [
                  AnimatedBuilder(
                    animation: _process,
                    builder: (context, child) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: LinearProgressIndicator(
                            color: Colors.red, value: _process.value),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _forward,
                        child: Icon(Icons.arrow_left),
                        style: gFullExaminationNavButtonStyle,
                      ),
                      const Text(
                        'Full Examination',
                        style: gFullExaminationTitleStyle,
                      ),
                      ElevatedButton(
                        onPressed: _next,
                        child: Icon(Icons.arrow_right),
                        style: gFullExaminationNavButtonStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: _inputPage,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class FullExamination extends StatefulWidget {
  const FullExamination({super.key});
  static const String routeName = 'fullExam';
  @override
  State<StatefulWidget> createState() => _FullExaminationState();
}
