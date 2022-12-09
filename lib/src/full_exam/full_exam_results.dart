import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_soe/src/app_home/app_home.dart';

import 'package:project_soe/src/data/styles.dart';
import 'package:project_soe/src/data/exam_data.dart';
import 'package:project_soe/src/components/voice_input.dart';
import 'package:project_soe/src/login/authorition.dart';

Future<Map<String, dynamic>> parseExamResults(http.Response response) async {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final retMap = decoded['data'];
  return retMap;
}

Future<Map<String, dynamic>> submitAndGetResults(
    List<VoiceInputPage> inputPages, String id) async {
  List<Map<String, dynamic>> dataList = [];
  int index = 0;
  for (VoiceInputPage inputPage in inputPages) {
    if (inputPage.questionPageData.resultData == null) {
      continue;
    }
    dataList.add(inputPage.questionPageData.resultData!.getJsonMap(index));
    index++;
  }
  if (dataList.isEmpty) {
    return {};
  }
  final bodyMap = {
    'cpsgrpId': id,
    'scores': dataList,
  };
  final client = http.Client();
  final token = AuthritionState.get().hasToken()
      ? AuthritionState.get().getToken()!
      : await AuthritionState.get().getTempToken();
  final response = await client.post(
    Uri.parse('http://47.101.58.72:8002/api/cpsgrp/v1/transcript'),
    body: jsonEncode(bodyMap).toString(),
    headers: {
      "Content-Type": "application/json",
      // FIXME 22.11.19 这里用的是临时Token
      'token': token,
    },
    encoding: Encoding.getByName('utf-8'),
  );
  return compute(parseExamResults, response);
}

class FullExaminationResult extends StatelessWidget {
  static const String routeName = 'fullExamResult';
  const FullExaminationResult({super.key});

  Widget _textWrap(String text, TextStyle textStyle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
        child: Text(text, style: textStyle),
      ),
    );
  }

  Widget? _generateScaffoldBody(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    if (data.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            '您没有进行测试，不生成报告。',
            style: gExaminationResultSubtitleStyle,
          ),
        ),
      );
    }
    final score = data['suggestedScore'];
    final completion = data['pronCompletion'];
    final accuracy = data['pronAccuracy'];
    final fluency = data['pronFluency'];
    final scoreLabel = '建议得分: $score/100';
    final completionLabel = '完整度: $completion/10.0';
    final accuracyLabel = '准确度: $accuracy/10.0';
    final fluencyLabel = '流畅度: $fluency/10.0';
    final listView = ListView(
      children: [
        _textWrap(scoreLabel, gExaminationResultSubtitleStyle),
        _textWrap(completionLabel, gExaminationResultTextStyle),
        _textWrap(accuracyLabel, gExaminationResultTextStyle),
        _textWrap(fluencyLabel, gExaminationResultTextStyle),
      ],
    );
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as FullExamResultScreenArguments;
    return FutureBuilder<Map<String, dynamic>>(
      future: submitAndGetResults(args.inputPages, args.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return Scaffold(
            body: _generateScaffoldBody(snapshot.data),
            bottomNavigationBar: Container(
              child: ElevatedButton(
                child: const Text("进入APP"),
                onPressed: () {
                  Navigator.pushNamed(context, ApplicationHome.routeName);
                },
              ),
            ),
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
