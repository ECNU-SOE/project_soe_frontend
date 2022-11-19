import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_soe/src/app_home/app_home.dart';

import 'package:project_soe/src/data/exam_data.dart';
import 'package:project_soe/src/components/voice_input.dart';
import 'package:project_soe/src/login/authorition.dart';

Future<String> parseExamResults(http.Response response) async {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final retStr = decoded['data'].toString();
  // TODO 22.11.13 实现解析数据
  return retStr;
}

Future<String> submitAndGetResults(
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
  final bodyMap = {
    'cpsgrpId': id,
    'scores': dataList,
  };
  final client = http.Client();
  final response = await client.post(
    Uri.parse('http://47.101.58.72:8002/api/cpsgrp/v1/transcript'),
    body: jsonEncode(bodyMap).toString(),
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
    return FutureBuilder<String>(
      future: submitAndGetResults(args.inputPages, args.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return Scaffold(
            body: Text(snapshot.data!),
            bottomNavigationBar: Container(
              child: ElevatedButton(
                child: Text("进入APP"),
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
