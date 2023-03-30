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

  Future<QuestionPageResultDataXf> postAndGetResultXf(
      DataQuestionPage data) async {
    // 指定URI
    final uri = Uri.parse(
        'http://47.101.58.72:8888/corpus-server/api/evaluate/v1/eval_xf');
    // 指定Request类型
    var request = http.MultipartRequest('POST', uri);
    // 添加文件
    request.files.add(await data.getMultiPartFileAudio());
    // 添加Fields
    request.fields['refText'] = data.toSingleString();
    request.fields['category'] = getXfCategoryStringByInt(data.evalMode);
    // 设置Headers
    request.headers['Content-Type'] = 'multipart/form-data';
    // 发送 并等待返回
    final response = await request.send();
    // 将返回转换为字节流, 并解码
    final decoded = jsonDecode(utf8.decode(await response.stream.toBytes()));
    // 处理解码后的数据
    final resultDataXf =
        QuestionPageResultDataXf(evalMode: data.evalMode, weight: data.weight);
    resultDataXf.parseJson(decoded['data']);
    return resultDataXf;
  }
}
