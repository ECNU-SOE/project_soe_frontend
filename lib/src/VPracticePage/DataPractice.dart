import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<DataPracticePage> postGetDataPracticePage() async {
  // if (kDebugMode) {
  //   DataPracticePage pageData = DataPracticePage();
  //   pageData.parseJson(jsonDecode(
  //           '{  "code": 0,  "data": {    "total": 2,    "size": 10,    "current": 1,    "records": [      {        "id": "cpsgrp_1588871928125460480",        "courseId": "1",        "title": "入门测试",        "description": "用户入门测试试卷",        "type": 2,        "difficulty": -1,        "isPublic": 0,        "startTime": null,        "endTime": null,        "creator": "user_1587422999043248128",        "gmtCreate": "2022-11-05T12:32:42.000+00:00",        "gmtModified": "2023-03-19T14:23:15.000+00:00",        "topics": null      },      {        "id": "cpsgrp_1637713951192125440",        "courseId": null,        "title": "第二套试卷",        "description": "国汉学院第二套试卷，（生，生态）",        "type": 1,        "difficulty": -1,        "isPublic": 0,        "startTime": "2022-11-04T16:00:00.000+00:00",        "endTime": "2022-11-05T04:00:00.000+00:00",        "creator": "user_1587422999043248128",        "gmtCreate": "2023-03-20T07:13:27.000+00:00",        "gmtModified": "2023-03-20T07:13:27.000+00:00",        "topics": null      }    ]  },  "msg": null}')[
  //       'data']);
  //   return pageData;
  // }
  final client = http.Client();
  final uri =
      Uri.parse('http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/list');
  final response = await client.post(
    uri,
    body: jsonEncode({}),
    headers: {"Content-Type": "application/json"},
    encoding: Encoding.getByName('utf-8'),
  );
  final jsonDecoded = await jsonDecode(utf8.decode(response.bodyBytes));
  DataPracticePage pageData = DataPracticePage();
  pageData.parseJson(jsonDecoded['data']);
  return pageData;
}

class DataPracticePage {
  int size = 0;
  int total = 0;
  int current = 0;
  List<DataPractice> dataList = List.empty(growable: true);
  DataPracticePage();
  void parseJson(Map<String, dynamic> json) {
    size = json['size'] as int;
    total = json['total'] as int;
    current = json['current'] as int;
    for (var item in json['records']) {
      dataList.add(DataPractice.fromJson(item));
    }
  }
}

class DataPractice {
  String id;
  String title;
  String desc;
  DataPractice({
    required this.id,
    required this.title,
    required this.desc,
  });
  factory DataPractice.fromJson(Map<String, dynamic> json) {
    return DataPractice(
        id: json['id'], title: json['title'], desc: json['description']);
  }
}
