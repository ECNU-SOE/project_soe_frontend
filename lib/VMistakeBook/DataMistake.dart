import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

// 错题本页面的数据
class DataMistakeBook {
  final List<DataMistakeItem> mistakeItemList;
  DataMistakeBook({required this.mistakeItemList});
}

// 错题本页面一项选单的数据
class DataMistakeItem {
  final int mistakeTypeCode;
  final String mistakeTypeName;
  DataMistakeItem({
    required this.mistakeTypeCode,
    required this.mistakeTypeName,
  });
  factory DataMistakeItem.fromJson(Map<String, dynamic> json) {
    return DataMistakeItem(
      mistakeTypeCode: json['mistakeTypeCode'],
      mistakeTypeName: json['mistakeTypeName'],
    );
  }
}

Future<DataMistakeBook> getGetDataMistakeBook() async {
  final token = AuthritionState.instance.getToken();
  final uri = Uri.parse(
      "http://47.101.58.72:8888/corpus-server/api/mistake/v1/getDetail?oneWeekKey=0");
  final response = await http.Client().get(
    uri,
    headers: {
      'token': AuthritionState.instance.getToken(),
    },
  );
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final code = decoded['code'];
  if (code != 0) {
    throw ("wrong return code");
  }
  final mistakeItemList = decoded['data']['eachMistakeTypeNumber'];
  List<DataMistakeItem> listMistake = List.empty(growable: true);
  for (final mistake in mistakeItemList) {
    listMistake.add(DataMistakeItem.fromJson(mistake));
  }
  return DataMistakeBook(mistakeItemList: listMistake);
}

class DataMistakeDetailListItem {
  String? cpsrcdId; //题目的快照id，为了识别用户答的是哪道题，答题时给后端传答题结果时需要带上它
  String? corpusId;
  String? cpsgrpId;
  String? topicId;
  int evalMode;
  int difficulty;
  int wordWeight;
  String pinyin;
  String refText;
  String audioUrl;
  DataMistakeDetailListItem({
    required this.cpsrcdId,
    required this.corpusId,
    required this.cpsgrpId,
    required this.topicId,
    required this.evalMode,
    required this.difficulty,
    required this.wordWeight,
    required this.pinyin,
    required this.refText,
    required this.audioUrl,
  });
  factory DataMistakeDetailListItem.fromJson(Map<String, dynamic> json) {
    return DataMistakeDetailListItem(
      cpsrcdId: json['cpsrcdId'],
      corpusId: json['corpusId'],
      cpsgrpId: json['cpsgrpId'],
      topicId: json['topicId'],
      evalMode: json['evalMode'],
      difficulty: json['difficulty'],
      wordWeight: json['wordWeight'],
      pinyin: json['pinyin'],
      refText: json['refText'],
      audioUrl: json['audioUrl'],
    );
  }
}

class DataMistakeDetail {
  List<DataMistakeDetailListItem> list;
  DataMistakeDetail({required this.list});
}

// "mistakeTypeCode":0, 题目类型，0-语音评测
// "oneWeekKey":0 是否获取近一周的错题数据，0-查全部，1-查一周
Future<DataMistakeDetail> postGetDataMistakeDetail(
    int mistakeTypeCode, int oneWeekKey) async {
  List<DataMistakeDetailListItem> list = List.empty(growable: true);
  final token = AuthritionState.instance.getToken();
  final response = await http.Client().post(
    Uri.parse(
        'http://47.101.58.72:8888/corpus-server/api/mistake/v1/getMistakes'),
    body: {
      "mistakeTypeCode": mistakeTypeCode,
      "oneWeekKey": oneWeekKey,
    },
    headers: {"token": token},
    encoding: Encoding.getByName(
      'utf-8',
    ),
  );
  final parsedJson = jsonDecode(utf8.decode(response.bodyBytes));
  final code = parsedJson['code'];
  if (0 != code) {
    throw ('wrong return code');
  }
  final data = parsedJson['data'];
  for (final item in data) {
    list.add(DataMistakeDetailListItem.fromJson(item));
  }
  return DataMistakeDetail(list: list);
}
