import 'dart:async';

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VExam/DataQuestion.dart';

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

class DataTranscript {
  String? id;
  String? cpsgrpId;
  String? respondent;
  double? pronCompletion;
  double? pronAccuracy;
  double? pronFluency;
  double? suggestedScore;
  double? manualScore;
  ResJson? resJson;
  String? gmtCreate;
  String? gmtModified;

  DataTranscript(
      {this.id,
      this.cpsgrpId,
      this.respondent,
      this.pronCompletion,
      this.pronAccuracy,
      this.pronFluency,
      this.suggestedScore,
      this.manualScore,
      this.resJson,
      this.gmtCreate,
      this.gmtModified});

  DataTranscript.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cpsgrpId = json['cpsgrpId'];
    respondent = json['respondent'];
    pronCompletion = json['pronCompletion'];
    pronAccuracy = json['pronAccuracy'];
    pronFluency = json['pronFluency'];
    suggestedScore = json['suggestedScore'];
    manualScore = json['manualScore'];
    resJson =
        json['resJson'] != null ? new ResJson.fromJson(json['resJson']) : null;
    gmtCreate = json['gmtCreate'];
    gmtModified = json['gmtModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cpsgrpId'] = this.cpsgrpId;
    data['respondent'] = this.respondent;
    data['pronCompletion'] = this.pronCompletion;
    data['pronAccuracy'] = this.pronAccuracy;
    data['pronFluency'] = this.pronFluency;
    data['suggestedScore'] = this.suggestedScore;
    data['manualScore'] = this.manualScore;
    if (this.resJson != null) {
      data['resJson'] = this.resJson!.toJson();
    }
    data['gmtCreate'] = this.gmtCreate;
    data['gmtModified'] = this.gmtModified;
    return data;
  }
}

class ResJson {
  String? cpsgrpId;
  String? pronCompletion;
  double? pronAccuracy;
  double? pronFluency;
  double? suggestedScore;
  double? manualScore;
  String? gmtCreate;
  String? gmtModified;
  String? title;

  List<DataResultXfTranscript>? dataResultXf;
  List<ItemResultTranscript>? itemResult;

  // Map<String, dynamic>? wrongSheng;
  // Map<String, dynamic>? wrongYun;
  // Map<String, dynamic>? wrongMono;

  ResJson({this.cpsgrpId, this.dataResultXf, this.itemResult, this.pronAccuracy, this.pronCompletion, this.pronFluency, this.manualScore, this.suggestedScore, this.gmtCreate, this.gmtModified, this.title,}); // this.wrongSheng, this.wrongMono, this.wrongYun});

  ResJson.fromJson(Map<String, dynamic> json) {
    cpsgrpId = json['cpsgrpId'];
    pronCompletion = json['pronCompletion'];
    pronAccuracy = json['pronAccuracy'];
    pronFluency = json['pronFluency'];
    suggestedScore = json['suggestedScore'];
    manualScore = json['manualScore'];
    gmtCreate = json['gmtCreate'];
    gmtModified = json['gmtModified'];
    title = json['title'];
    // print(json['cpsgrpId']);
    // print(json['resJson']);
    if (json['dataResultXf'] != null) {
      // print(1111111);
      dataResultXf = <DataResultXfTranscript>[];
      json['dataResultXf'].forEach((v) {
        dataResultXf!.add(new DataResultXfTranscript.fromJson(v));
      });
    }
    if (json['itemResult'] != null) {
      itemResult = <ItemResultTranscript>[];
      json['itemResult'].forEach((v) {
        itemResult!.add(new ItemResultTranscript.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cpsgrpId'] = this.cpsgrpId;
    data['pronCompletion'] = this.pronCompletion;
    data['pronAccuracy'] = this.pronAccuracy;
    data['pronFluency'] = this.pronFluency;
    data['suggestedScore'] = this.suggestedScore;
    data['manualScore'] = this.manualScore;
    data['gmtCreate'] = this.gmtCreate;
    data['gmtModified'] = this.gmtModified;
    data['title'] = this.title;
    if (this.dataResultXf != null) {
      data['dataResultXf'] = this.dataResultXf!.map((v) => v.toJson()).toList();
    }
    if (this.itemResult != null) {
      data['itemResult'] = this.itemResult!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataResultXfTranscript {
  double? totalScore;
  double? fluencyScore;
  double? phoneScore;
  double? toneScore;
  int? more;
  int? less;
  int? retro;
  int? repl;

  DataResultXfTranscript(
      {this.totalScore,
      this.fluencyScore,
      this.phoneScore,
      this.toneScore,
      this.more,
      this.less,
      this.retro,
      this.repl});

  DataResultXfTranscript.fromJson(Map<String, dynamic> json) {
    totalScore = json['totalScore'];
    fluencyScore = json['fluencyScore'];
    phoneScore = json['phoneScore'];
    toneScore = json['toneScore'];
    more = json['more'];
    less = json['less'];
    retro = json['retro'];
    repl = json['repl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalScore'] = this.totalScore;
    data['fluencyScore'] = this.fluencyScore;
    data['phoneScore'] = this.phoneScore;
    data['toneScore'] = this.toneScore;
    data['more'] = this.more;
    data['less'] = this.less;
    data['retro'] = this.retro;
    data['repl'] = this.repl;
    return data;
  }
}

class ItemResultTranscript {
  double? gotScore;
  double? fullScore;
  int? tNum;
  int? cNum;

  ItemResultTranscript({this.gotScore, this.fullScore, this.tNum, this.cNum});

  ItemResultTranscript.fromJson(Map<String, dynamic> json) {
    gotScore = json['gotScore'];
    fullScore = json['fullScore'];
    tNum = json['tNum'];
    cNum = json['cNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gotScore'] = this.gotScore;
    data['fullScore'] = this.fullScore;
    data['tNum'] = this.tNum;
    data['cNum'] = this.cNum;
    return data;
  }
}

class WrongSheng {
  String? word;
  String? shengmu;
  String? yunmu;
  bool? isShengWrong;
  String? pinyinString;

  WrongSheng(
      {this.word,
      this.shengmu,
      this.yunmu,
      this.isShengWrong,
      this.pinyinString});

  WrongSheng.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    shengmu = json['shengmu'];
    yunmu = json['yunmu'];
    isShengWrong = json['isShengWrong'];
    pinyinString = json['pinyinString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['shengmu'] = this.shengmu;
    data['yunmu'] = this.yunmu;
    data['isShengWrong'] = this.isShengWrong;
    data['pinyinString'] = this.pinyinString;
    return data;
  }
}

Future<List<ResJson>> postGetDataTranscriptPage() async {
  final token = AuthritionState.instance.getToken();
  final uri = Uri.parse(
      "http://47.101.58.72:8888/corpus-server/api/transcript/v1/list");
  final response = await http.Client().post(
    uri,
    body: jsonEncode({}),
    headers: {
      "Content-Type": "application/json",
      'token': token,
    },
  );
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final code = decoded['code'];
  final data = decoded['data'];
  if (code != 0) throw ("wrong return code");

  List<ResJson> listDataTranscript = List.empty(growable: true);

  for(var _data in data) {
      _data['title'] = "";
      // final response2 = await http.Client().get(
      //   Uri.parse('http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/detail?cpsgrpId=' + _data['cpsgrpId']),
      //   headers: {'token': token},
      // );
      // final u8decoded2 = utf8.decode(response2.bodyBytes);
      // final decoded2 = jsonDecode(u8decoded2);
      // final code2 = decoded2['code'];
      // final data2 = decoded2['data'];
      // if (code2 != 0) throw ("wrong return code");
      // else _data['title'] = data2['title'];

    listDataTranscript.add(
      ResJson.fromJson(_data)
    );

    break;

  }

  print(listDataTranscript.length);
  print(listDataTranscript[0].dataResultXf);
  return listDataTranscript;
}