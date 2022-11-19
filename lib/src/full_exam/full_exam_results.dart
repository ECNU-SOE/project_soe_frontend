import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:project_soe/src/data/exam_data.dart';
import 'package:project_soe/src/components/voice_input.dart';
import 'package:project_soe/src/login/authorition.dart';

List<String> parseExamResults(http.Response response) {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  // TODO 22.11.13 实现解析数据
  List<String> list = List<String>.empty(growable: true);
  return list;
}

Future<List<String>> submitAndGetResults(
    List<VoiceInputPage> inputPages, String id) async {
  List<String> dataList = [];
  int index = 0;
  for (VoiceInputPage inputPage in inputPages) {
    if (inputPage.questionPageData.resultData == null) {
      continue;
    }
    dataList.add(inputPage.questionPageData.resultData!.getJsonString(index));
    index++;
  }
  final client = http.Client();
  final response = await client.post(
    Uri.parse('http://47.101.58.72:8888/corpus-server/api/test/v1/upload'),
    body: {
      'cpsgrpId': id,
      'scores': jsonEncode(dataList).toString(),
    },
    headers: {
      "Content-Type": "application/json",
      // FIXME 22.11.19 这里用的是临时Token
      HttpHeaders.authorizationHeader: gTempToken,
    },
    encoding: Encoding.getByName('utf-8'),
  );
  return compute(parseExamResults, response);
}

class FullExaminationResult extends StatelessWidget {
  static const String routeName = 'fullExamResult';
  const FullExaminationResult({super.key});
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as FullExamResultScreenArguments;
    return FutureBuilder<List<String>>(
      future: submitAndGetResults(args.inputPages, args.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return Scaffold();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
