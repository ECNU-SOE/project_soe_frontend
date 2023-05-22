import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<DataPracticePage> postGetDataPracticePage() async {
  final client = http.Client();
  final uri =
      Uri.parse('http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/list');
  final response = await client.post(
    uri,
    body: jsonEncode({
      'isPrivate': 0,
    }),
    headers: {"Content-Type": "application/json"},
    encoding: Encoding.getByName('utf-8'),
  );
  var jsonDecoded = await jsonDecode(utf8.decode(response.bodyBytes));
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
