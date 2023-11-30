import 'dart:async';

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VExam/DataExamResult.dart';
import 'package:project_soe/VExam/DataQuestion.dart';

class DataPractice {
  String id;
  String title;
  String description;
  DataPractice({
    required this.id,
    required this.title,
    required this.description,
  });
  factory DataPractice.fromJson(Map<String, dynamic> json) {
    return DataPractice(
        id: json['id'], title: json['title'], description: json['description']);
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
  final token = AuthritionState.instance.getToken();
  final client = http.Client();
  final uri =
      Uri.parse('http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/list?cur=1&size=10');
  final response = await client.post(
    uri,
    body: jsonEncode({
        "classId": "class_1645342954912616448",
        "title": null,
        "description": null,
        "isPrivate": 0,
        "modStatus": null,
        "difficulty": null,
        "startTime": null,
        "endTime": null,
        "status":null  //null:全部，1：未开始，2：进行中，3：已结束
    }),
    headers: {"token": token, "Content-Type": "application/json"},
    encoding: Encoding.getByName('utf-8'),
  );
  var jsonDecoded = await jsonDecode(utf8.decode(response.bodyBytes));
  // print(token);
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
    title = json['cpsgrpName'];
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

Future<List<DataExamResult>> postGetDataTranscriptPage() async {
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
    // print(token);
  if (code != 0) throw ("wrong return code");
  List<DataExamResult> listDataTranscript = List.empty(growable: true);
  for(var _data in data) {

    DataExamResult tmp = new DataExamResult();
    tmp.tid = _data['id'];
    tmp.gid = _data['cpsgrpId'];
    tmp.name = _data['cpsgrpName'];
    tmp.uid = _data['respondent'];
    tmp.gmtCreate = _data['gmtCreate'];
    tmp.gmtModified = _data['gmtModified'];
    
    var json = jsonDecode(_data['resJson']);
    tmp.suggestedScore = json['suggestedScore'] ?? 0.0;
    tmp.allTotalScore = json['allTotalScore'] ?? 0.0;
    tmp.allPhoneScore = json['allPhoneScore'] ?? 0.0;
    tmp.allToneScore = json['allToneScore'] ?? 0.0;
    tmp.allFluencyScore = json['allFluencyScore'] ?? 0.0;
    tmp.allLess = json['allLess'] ?? 0;
    tmp.allMore = json['allMore'] ?? 0;
    tmp.allRepl = json['allRepl'] ?? 0;
    tmp.allRetro = json['allRetro'] ?? 0;
    
    if (json['totPhoneScore'] != null) {
      tmp.totPhoneScore = <NameScore>[];
      json['totPhoneScore'].forEach((v) {
        tmp.totPhoneScore!.add(new NameScore.fromJson(v));
      });
    }
    if (json['totToneScore'] != null) {
      tmp.totToneScore = <NameScore>[];
      json['totToneScore'].forEach((v) {
        tmp.totToneScore!.add(new NameScore.fromJson(v));
      });
    }
    if (json['totFluencyScore'] != null) {
      tmp.totFluencyScore = <NameScore>[];
      json['totFluencyScore'].forEach((v) {
        tmp.totFluencyScore!.add(new NameScore.fromJson(v));
      });
    }
    if (json['totTotalScore'] != null) {
      tmp.totTotalScore = <NameScore>[];
      json['totTotalScore'].forEach((v) {
        tmp.totTotalScore!.add(new NameScore.fromJson(v));
      });
    }
    if (json['totLess'] != null) {
      tmp.totLess = <NameNum>[];
      json['totLess'].forEach((v) {
        tmp.totLess!.add(new NameNum.fromJson(v));
      });
    }
    if (json['totMore'] != null) {
      tmp.totMore = <NameNum>[];
      json['totMore'].forEach((v) {
        tmp.totMore!.add(new NameNum.fromJson(v));
      });
    }
    if (json['totRepl'] != null) {
      tmp.totRepl = <NameNum>[];
      json['totRepl'].forEach((v) {
        tmp.totRepl!.add(new NameNum.fromJson(v));
      });
    }
    if (json['totRetro'] != null) {
      tmp.totRetro = <NameNum>[];
      json['totRetro'].forEach((v) {
        tmp.totRetro!.add(new NameNum.fromJson(v));
      });
    }
    if (json['wrongShengMu'] != null) {
      tmp.wrongShengMu = <NameNum>[];
      json['wrongShengMu'].forEach((v) {
        tmp.wrongShengMu!.add(new NameNum.fromJson(v));
      });
    }
    if (json['wrongYunMu'] != null) {
      tmp.wrongYunMu = <NameNum>[];
      json['wrongYunMu'].forEach((v) {
        tmp.wrongYunMu!.add(new NameNum.fromJson(v));
      });
    }
    listDataTranscript.add(tmp);
  }
  return listDataTranscript;
}