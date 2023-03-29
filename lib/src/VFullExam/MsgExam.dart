import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:project_soe/src/VFullExam/DataExam.dart';
import 'package:project_soe/src/VAuthorition/LogicAuthorition.dart';

class MsgMgrExam {
  Future<void> postResultToServer(ParsedResultsXf parsedResultsXf) async {
    final client = http.Client();
    final bodyMap = {'resJson': parsedResultsXf.toJson()};
    final token = await AuthritionState.get().getTempToken();
    final response = client.post(
      Uri.parse(
          'http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/save_transcript'),
      body: jsonEncode(bodyMap),
      headers: {
        "Content-Type": "application/json",
        // FIXME 23.3.29 暂时使用TempToken
        'token': token,
      },
      encoding: Encoding.getByName('utf-8'),
    );
  }
}
