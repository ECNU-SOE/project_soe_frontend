import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

class DataMistakeBook {
  final int mistakeTotalNumber;
  final int stubbornMistakeNumber;
  final List<DataMistakeBookListItem> listMistakeBook;
  DataMistakeBook({
    required this.mistakeTotalNumber,
    required this.stubbornMistakeNumber,
    required this.listMistakeBook,
  });
}

class DataMistakeBookListItem {
  final int mistakeNum;
  final String mistakeTypeName;
  final int mistakeTypeCode;
  DataMistakeBookListItem({
    required this.mistakeNum,
    required this.mistakeTypeName,
    required this.mistakeTypeCode,
  });

  factory DataMistakeBookListItem.fromJson(Map<String, dynamic> json) {
    return DataMistakeBookListItem(
      mistakeNum: json['mistakeNum'],
      mistakeTypeCode: json['mistakeTypeCode'],
      mistakeTypeName: json['mistakeTypeName'],
    );
  }
}

Future<DataMistakeBook> getGetDataMistakeBook() async {
  final token = AuthritionState.instance.getToken();
  // final token = 'soe-token-eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzbWFydC1vcmFsLWV2YWx1YXRpb24iLCJsb2dpblVzZXIiOnsiYWNjb3VudE5vIjoidXNlcl8xNjAxODQ0ODU0Nzk3NzY2NjU2IiwiaWRlbnRpZnlJZCI6bnVsbCwicm9sZUlkIjpudWxsLCJuaWNrTmFtZSI6Ikpvc2h1YSIsInJlYWxOYW1lIjoi5p2D6ZmQ6K6k6K-B5rWL6K-V6LSm5Y-3IiwiZmlyc3RMYW5ndWFnZSI6bnVsbCwicGhvbmUiOiIxMzU3Njg0NTM1NCIsIm1haWwiOiIxNzY1OTQ3NDI0QHFxLmNvbSJ9LCJpYXQiOjE2OTA5ODUwNjcsImV4cCI6MTY5MTU4OTg2N30.GH1K5fSRB8237XzQoNJiXgqtCUZrjB4fddpxHOAn7DE';
  final uri = Uri.parse(
      "http://47.101.58.72:8888/corpus-server/api/mistake/v1/getDetail?oneWeekKey=0");
  final response = await http.Client().get(
    uri,
    headers: {
      'token': token,
    },
  );
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final code = decoded['code'];
  if (code != 0) throw ("wrong return code");
  final mistakeBookListItem = decoded['data']['eachMistakeTypeNumber'];
  List<DataMistakeBookListItem> listMistakeBook = List.empty(growable: true);
  for (final mistake in mistakeBookListItem)
    listMistakeBook.add(DataMistakeBookListItem.fromJson(mistake));
  return DataMistakeBook(
      mistakeTotalNumber: decoded['data']['mistakeTotalNumber'],
      stubbornMistakeNumber: decoded['data']['stubbornMistakeNumber'],
      listMistakeBook: listMistakeBook);
}

class DataMistakeDetail {
  List<DataMistakeDetailListItem> listMistakeDetail;
  DataMistakeDetail({required this.listMistakeDetail});
}

class DataMistakeDetailListItem {
  String? cpsrcdId; //题目的快照id，为了识别用户答的是哪道题，答题时给后端传答题结果时需要带上它
  String? corpusId;
  String? cpsgrpId;
  String? topicId;
  int? evalMode;
  int? difficulty;
  int? wordWeight;
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

Future<DataMistakeDetail> postGetDataMistakeDetail(int mistakeTypeCode, int oneWeekKey) async {
  final token = AuthritionState.instance.getToken();
  final uri = Uri.parse('http://47.101.58.72:8888/corpus-server/api/mistake/v1/getMistakes');
  final response = await http.Client().post(
    uri,
    body: jsonEncode({
      "mistakeTypeCode": mistakeTypeCode,
      "oneWeekKey": oneWeekKey,
    }),
    headers: {
      "Content-Type": "application/json",
      "token": token,
    },
    encoding: Encoding.getByName(
      'utf-8',
    ),
  );
  final parsedJson = jsonDecode(
      '{    "code": 0,    "data": [        {            "cpsrcdId": "cpsrcd_1667734326118322176",            "corpusId": null,            "cpsgrpId": "cpsgrp_1666820615325224960",            "topicId": "topic_1667733584137555968",            "evalMode": null,            "difficulty": -1,            "wordWeight": 0,            "pinyin": "di4 san1 sheng1    di4 er4 sheng1  ",            "refText": "第三声 第二声",            "audioUrl": "https://soe-oss.oss-cn-shanghai.aliyuncs.com/corpus/2023/06/14/5c1a801c02c740718616df3fa28918ab.MP3",            "tags": null,            "cNum": 8         },        {            "cpsrcdId": "cpsrcd_1667734692889235456",            "corpusId": null,            "cpsgrpId": "cpsgrp_1666820615325224960",            "topicId": "topic_1667734588706918400",            "evalMode": null,            "difficulty": -1,            "wordWeight": 0,            "pinyin": "di4 yi1 sheng1 + di4 yi1 sheng1     di4 yi1 sheng1 + di4 si4 sheng1   ",            "refText": "第一声+第一声  第一声+第四声 ",            "audioUrl": "https://soe-oss.oss-cn-shanghai.aliyuncs.com/corpus/2023/06/14/905990689126453a93bde760bdd4506a.MP3",            "tags": null,            "cNum": 1        },        {            "cpsrcdId": "cpsrcd_1667734773675724800",            "corpusId": null,            "cpsgrpId": "cpsgrp_1666820615325224960",            "topicId": "topic_1667734588706918400",            "evalMode": null,            "difficulty": -1,            "wordWeight": 0,            "pinyin": "di4 yi1 sheng1 + di4 er4 sheng1  di4 er4 sheng1 + di4 er4 sheng1 ",            "refText": "第一声+第二声第二声+第二声",            "audioUrl": "https://soe-oss.oss-cn-shanghai.aliyuncs.com/corpus/2023/06/14/aa8b1f982c234fd1b8fc634f23b8368e.MP3",            "tags": null,            "cNum": 2        }    ],    "msg": null}        ');
  final code = parsedJson['code'];
  if (code != 0) throw ('wrong return code');
  final data = parsedJson['data'];
  List<DataMistakeDetailListItem> listMistakeDetail = List.empty(growable: true);
  for (final item in data) 
    listMistakeDetail.add(DataMistakeDetailListItem.fromJson(item));
  return DataMistakeDetail(listMistakeDetail: listMistakeDetail);
}