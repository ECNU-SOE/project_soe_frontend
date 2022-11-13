import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:project_soe/src/app_home/app_home.dart';
import 'package:project_soe/src/full_exam/full_exam_results.dart';
import 'package:project_soe/src/nl_choice/nl_choice.dart';
import 'package:project_soe/src/components/voice_input.dart';
import 'package:project_soe/src/data/params.dart';
import 'package:project_soe/src/data/styles.dart';
import 'package:project_soe/src/data/exam_data.dart';

List<QuestionPageData> parseWordMap(http.Response response) {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final parsed = decoded['cpsrcdList'].cast<Map<String, dynamic>>();
  List<QuestionPageData> list = List<QuestionPageData>.empty(growable: true);
  for (var item in parsed) {
    int type = item['type'] as int;
    List<QuestionData> questionList = item['corpus_list']
        .map<QuestionData>((json) => QuestionData.fromJson(json))
        .toList();
    list.add(QuestionPageData(
        type: questionTypeFromInt(type), questionList: questionList));
  }
  return list;
}

Future<List<QuestionPageData>> fetchWordMap(
    http.Client client, String id) async {
  final response = await client.get(
    Uri.parse(
        "http://47.101.58.72:8888/corpus-server/api/test/v1/details?cpsgrpId=$id"),
  );
  return compute(parseWordMap, response);
}

class _FullExaminationState extends State<FullExamination> {
  _FullExaminationState();
  int _index = 0;
  int _listSize = 0;
  VoiceInputPage? _inputPage;
  List<VoiceInputPage>? _voiceInputs;
  List<String>? _recordList;
  final ValueNotifier<double> _process = ValueNotifier<double>(0.0);

  void _forward() {
    if (_index <= 0) {
      return;
    } else {
      _recordList![_index] = _inputPage!.recordPath;
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
      _recordList![_index] = _inputPage!.recordPath;
      setState(() {
        _index = _index + 1;
        _process.value = _index.toDouble() / _listSize.toDouble();
      });
    }
  }

  void onSubmitButtonPressed() {
    Navigator.pushNamed(context, FullExaminationResult.routeName,
        arguments: (_voiceInputs));
    return;
  }

  Widget _buildBottomWidget() {
    if (_index == (_listSize - 1)) {
      return ElevatedButton(
        child: Text(
          "提交",
          style: gFullExaminationSubTitleStyle,
        ),
        onPressed: onSubmitButtonPressed,
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
    final examId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder<List<QuestionPageData>>(
      future: fetchWordMap(http.Client(), examId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          _inputPage = VoiceInputPage(questionPageData: snapshot.data![_index]);
          try {
            _voiceInputs![_index] = _inputPage!;
          } catch (e) {
            _voiceInputs!.add(_inputPage!);
          }
          _listSize = snapshot.data!.length;
          _recordList = List<String>.generate(_listSize, (index) => '');
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
            ),
            body: _inputPage,
            bottomNavigationBar: _buildBottomWidget(),
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
