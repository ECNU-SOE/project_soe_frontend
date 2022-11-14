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

List<String> parseExamResults(http.Response response) {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  // TODO 22.11.13 实现解析数据
  List<String> list = List<String>.empty(growable: true);
  return list;
}

Future<List<String>> submitAndGetResults(
    List<VoiceInputPage> inputPages) async {
  var dataList = <Map<String, dynamic>>[];
  var fileList = <http.MultipartFile>[];
  for (VoiceInputPage inputPage in inputPages) {
    dataList.add(await inputPage.questionPageData.toDynamicMap());
    if (inputPage.questionPageData.filePath != '') {
      fileList.add(await inputPage.questionPageData.getMultiPartFileAudio());
    }
  }
  var json = jsonEncode(dataList).toString();
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://47.101.58.72:8888/corpus-server/api/test/v1/upload'),
  )
    ..fields.addAll({'data': json})
    ..files.addAll(fileList);
  var streamResponse = await request.send();
  var response = await http.Response.fromStream(streamResponse);
  return compute(parseExamResults, response);
}

class FullExaminationResult extends StatelessWidget {
  static const String routeName = 'fullExamResult';
  const FullExaminationResult({super.key});
  @override
  Widget build(BuildContext context) {
    final inputPages =
        ModalRoute.of(context)!.settings.arguments as List<VoiceInputPage>;
    return FutureBuilder<List<String>>(
      future: submitAndGetResults(inputPages),
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
