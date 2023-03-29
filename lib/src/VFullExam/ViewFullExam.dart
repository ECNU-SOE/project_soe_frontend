import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:project_soe/src/VAppHome/ViewAppHome.dart';
import 'package:project_soe/src/VFullExam/ViewFullExamResults.dart';
import 'package:project_soe/src/VNativeLanguageChoice/ViewNativeLanguageChoice.dart';
import 'package:project_soe/src/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/src/GGlobalParams/LabelText.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/VFullExam/DataExam.dart';

List<QuestionPageData> parseWordMap(http.Response response) {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final parsed = decoded['data']['topics'];
  List<QuestionPageData> retList = List.empty(growable: true);
  for (var topicMap in parsed) {
    List<QuestionData> questionList = List.empty(growable: true);
    for (var json in topicMap['subCpsrcds']) {
      questionList.add(QuestionData.fromJson(json));
    }
    QuestionPageData pageData = QuestionPageData(
      // type: getQuestionTypeFromInt(topicMap['type']),
      // type: getQuestionTypeFromInt(questionList[0].evalMode),
      questionList: questionList,
      evalMode: questionList[0].evalMode,
      cpsgrpId: topicMap['cpsgrpId'],
      id: topicMap['id'],
      weight: topicMap['score'],
      desc: topicMap['description'],
      title: topicMap['title'],
    );
    retList.add(pageData);
  }
  return retList;
}

Future<List<QuestionPageData>> fetchWordMap(
    http.Client client, String id) async {
  final response = await client.get(
    Uri.parse(
        "http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/detail?cpsgrpId=$id"),
  );
  return compute(parseWordMap, response);
}

class _FullExaminationBodyState extends State<_FullExaminationBody> {
  _FullExaminationBodyState();
  int _index = 0;
  int _listSize = 0;
  VoiceInputPage? _inputPage;
  List<VoiceInputPage>? _voiceInputs;
  final ValueNotifier<double> _process = ValueNotifier<double>(0.0);

  void _forward() {
    if (_index <= 0) {
      return;
    } else {
      if (_voiceInputs == null) {
        return;
      }
      if (_voiceInputs![_index].questionPageData.isRecording) {
        return;
      }
      setState(() {
        _index = _index - 1;
        _process.value = _index.toDouble() / _listSize.toDouble();
      });
    }
  }

  void _next() {
    if (_index >= (_listSize - 1)) {
      return;
    } else {
      if (_voiceInputs == null) {
        return;
      }
      if (_voiceInputs![_index].questionPageData.isRecording) {
        return;
      }
      setState(() {
        _index = _index + 1;
        _process.value = _index.toDouble() / _listSize.toDouble();
      });
    }
  }

  void onSubmitButtonPressed() {
    if (_checkAnyUploading()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 48.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(),
                Column(
                  children: [
                    Text(
                      "请等待语音评测完成.",
                      style: gFullExaminationTextStyle,
                    ),
                    Text(
                      '(点击空白处关闭提示)',
                      style: gFullExaminationTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      List<QuestionPageData> lst = List.empty(growable: true);
      for (final voiceInput in _voiceInputs!) {
        lst.add(voiceInput.questionPageData);
      }
      Navigator.pushNamed(context, FullExaminationResult.routeName,
          arguments: (FullExamResultScreenArguments(widget._examId, lst)));
    }
  }

  bool _checkAnyUploading() {
    if (null == _voiceInputs) {
      return false;
    }
    for (var voiceInput in _voiceInputs!) {
      if (voiceInput.questionPageData.isUploading) {
        return true;
      }
    }
    return false;
  }

  Widget _buildBottomWidget() {
    if (_index == (_listSize - 1)) {
      return Container(
        height: 60.0,
        child: ElevatedButton(
          child: Text(
            "提   交",
            style: gFullExaminationSubTitleStyle,
          ),
          style: gFullExaminationSubButtonStyle,
          onPressed: onSubmitButtonPressed,
        ),
      );
    } else {
      return LinearProgressIndicator(
        value: _process.value,
      );
    }
  }

  @override
  void initState() {
    _voiceInputs = List<VoiceInputPage>.empty(growable: true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _inputPage = VoiceInputPage(questionPageData: widget._pageDatas[_index]);
    try {
      _voiceInputs![_index] = _inputPage!;
    } catch (e) {
      _voiceInputs!.add(_inputPage!);
    }
    _listSize = widget._pageDatas.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _forward,
              child: Icon(Icons.arrow_left),
              style: gFullExaminationNavButtonStyle,
            ),
            const Text(
              '全面测试',
              style: gFullExaminationTitleStyle,
            ),
            ElevatedButton(
              onPressed: _next,
              child: Icon(Icons.arrow_right),
              style: gFullExaminationNavButtonStyle,
            ),
          ],
        ),
      ),
      body: _inputPage,
      bottomNavigationBar: _buildBottomWidget(),
    );
  }
}

class _FullExaminationBody extends StatefulWidget {
  List<QuestionPageData> _pageDatas;
  String _examId;
  _FullExaminationBody(this._examId, this._pageDatas);
  @override
  State<StatefulWidget> createState() => _FullExaminationBodyState();
}

class FullExamination extends StatelessWidget {
  FullExamination({super.key});
  static const String routeName = 'fullExam';
  String examId = '';
  @override
  Widget build(BuildContext context) {
    String examId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder<List<QuestionPageData>>(
      future: fetchWordMap(http.Client(), examId),
      builder: (context, snapshot) {
        // if (snapshot.hasError) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // } else
        if (snapshot.hasData) {
          return _FullExaminationBody(examId, snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
