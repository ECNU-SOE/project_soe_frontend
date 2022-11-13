import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:project_soe/src/data/exam_data.dart';
import 'package:project_soe/src/components/voice_input.dart';

List<String> parseExamResults(dio.Response response) {
  // final u8decoded = utf8.decode(response.bodyBytes);
  // final decoded = jsonDecode(u8decoded);
  // TODO 22.11.13 实现解析数据
  List<String> list = List<String>.empty(growable: true);
  return list;
}

Future<List<String>> submitAndGetResults(
    List<VoiceInputPage> inputPages) async {
  final uri =
      Uri.parse("http://47.101.58.72:8888/corpus-server/api/test/v1/upload");
  var dioClient = dio.Dio();
  for (VoiceInputPage inputPage in inputPages) {
    var multipartFile = dio.MultipartFile.fromFile(inputPage.recordPath);
  }
  // TODO 11.13 实现数据
  final response = await dioClient.post(
      "http://47.101.58.72:8888/corpus-server/api/test/v1/upload",
      data: {});
  return compute(parseExamResults, response);
}

class FullExaminationResult extends StatelessWidget {
  static const String routeName = 'fullExamResult';
  const FullExaminationResult({super.key});
  @override
  Widget build(BuildContext context) {
    final voiceInputs =
        ModalRoute.of(context)!.settings.arguments as List<VoiceInputPage>;
    return Scaffold();
  }
}
