import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VExam/DataQuestion.dart';

Future<List<SubCpsrcds>> getAllQuestions(String type, String refText, List<int> tagIds) async {
  final token = AuthritionState.instance.getToken();
  final uri = Uri.parse(
      'http://47.101.58.72:8888/corpus-server/api/cpsrcd/v1/list?cur=1&size=10');
  final response = await http.Client().post(
    uri,
    headers: {"token": token, "Content-Type": "application/json"},
    body: jsonEncode({
      //语料类型
      "type": null,
      //语料起始难度 
      "difficultyBegin": null,
      //语料截止难度
      "difficultyEnd": null,
      //语料文本内容
      "refText": refText,
      //语料标签，查询逻辑是输入多个标签时，显示的结果中会包含其中至少一个标签
      "tagIds": null
    }),
  );
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final code = decoded['code'];
  final data = decoded['data'];
  final msg = decoded['msg'];
  if (code != 0) throw ('wrong return code');
  List<SubCpsrcds> questionList = List.empty(growable: true);
  var records = data['records'];
  for(var record in records) {
    questionList.add(SubCpsrcds.fromJson(record));
  }
  return questionList;
}
