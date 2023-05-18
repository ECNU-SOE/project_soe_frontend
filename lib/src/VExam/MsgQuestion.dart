import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:project_soe/src/VExam/DataQuestion.dart';
import 'package:project_soe/src/VAuthorition/LogicAuthorition.dart';

// 此文件只应被DataQuestion包含
class MsgMgrQuestion {
  Future<List<DataQuestionPageMain>> getQuestionPageMainList(
      String examId) async {
    final response = await http.Client().get(
      Uri.parse(
          "http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/detail?cpsgrpId=$examId"),
    );
    final u8decoded = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(u8decoded);
    final parsed = decoded['data']['topics'];
    List<DataQuestionPageMain> retList = List.empty(growable: true);
    for (var topicMap in parsed) {
      int tnum = topicMap['tNum'];
      double score = topicMap['score'];
      List<dynamic> subCpsrcds = topicMap['subCpsrcds'];
      if (!subCpsrcds.isEmpty) {
        score = score / subCpsrcds.length;
      }
      for (var json in subCpsrcds) {
        DataQuestion dataQuestion = DataQuestion.fromJson(json);
        DataQuestionPageMain dataPage = DataQuestionPageMain(
          audioUri: (json['audioUrl'] == null) ? '' : json['audioUrl'],
          dataQuestion: dataQuestion,
          evalMode: dataQuestion.evalMode,
          cnum: json['cNum'],
          tnum: tnum,
          cpsgrpId: topicMap['cpsgrpId'],
          id: topicMap['id'],
          weight: score,
          desc: topicMap['description'],
          title: topicMap['title'],
        );
        retList.add(dataPage);
      }
    }
    return retList;
  }

  // 客户端解析后的数据上传至服务器
  Future<void> postResultToServer(ParsedResultsXf parsedResultsXf) async {
    final client = http.Client();
    final bodyMap = {
      'resJson': parsedResultsXf.toJson(),
      'cpsgrpId': parsedResultsXf.cpsgrpId,
      'suggestedScore': parsedResultsXf.weightedScore
    };
    final token = await AuthritionState.get().getToken();
    final response = client.post(
      Uri.parse(
          'http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/save_transcript'),
      body: jsonEncode(bodyMap),
      headers: {
        "Content-Type": "application/json",
        'token': AuthritionState.get().getToken(),
      },
      encoding: Encoding.getByName('utf-8'),
    );
    // final responseBytes = utf8.decode((await response).bodyBytes);
  }

  // 将语音数据发往服务器并评测
  // 此函数只应被Data调用
  Future<DataResultXf> postAndGetResultXf(DataQuestionEval data) async {
    // 指定URI
    final uri = Uri.parse(
        'http://47.101.58.72:8888/corpus-server/api/evaluate/v1/eval_xf');
    // 指定Request类型
    var request = http.MultipartRequest('POST', uri);
    // 添加文件
    request.files.add(await data.getMultiPartFileAudio());
    // 添加Fields
    request.fields['refText'] = data.toSingleString();
    //data.toSingleString();
    request.fields['category'] = getXfCategoryStringByInt(data.evalMode);
    // 设置Headers
    request.headers['Content-Type'] = 'multipart/form-data';
    // 发送 并等待返回
    final response = await request.send();
    // 将返回转换为字节流, 并解码
    final decoded = jsonDecode(utf8.decode(await response.stream.toBytes()));
    // 处理解码后的数据
    final resultDataXf =
        DataResultXf(evalMode: data.evalMode, weight: data.getWeight());
    resultDataXf.parseJson(decoded['data']);
    return resultDataXf;
  }
}
