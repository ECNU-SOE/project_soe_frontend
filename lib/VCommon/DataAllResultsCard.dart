// ignore_for_file: slash_for_doc_comments

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

/*
{
  "id": "",
  "cpsgrpId": "",
  "respondent": "",
  "totalSuggestedScore": 9.9,
  "totalManualScore": 9.9,
  "totalFullScore": 99.9,
  "OneResultCard": [],
  "gmtCreate": "2023-03-28T12:54:54.000+00:00",
  "gmtModified": "2023-03-28T12:54:54.000+00:00"
} */
class DataAllResultCard {
  String? id;
  String? cpsgrpId;
  String? respondent;
  double? totalSuggestedScore;
  double? totalManualScore;
  double? totalFullScore;
  List<DataOneResultCard>? dataOneResultCard;
  String? gmtCreate;
  String? gmtModified;

  DataAllResultCard(
      {this.id,
      this.cpsgrpId,
      this.respondent,
      this.totalSuggestedScore,
      this.totalManualScore,
      this.totalFullScore,
      this.dataOneResultCard,
      this.gmtCreate,
      this.gmtModified});

  DataAllResultCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cpsgrpId = json['cpsgrpId'];
    respondent = json['respondent'];
    totalSuggestedScore = json['totalSuggestedScore'];
    totalManualScore = json['totalManualScore'];
    totalFullScore = json['totalFullScore'];
    if (json['OneResultCard'] != null) {
      dataOneResultCard = <DataOneResultCard>[];
      json['OneResultCard'].forEach((v) {
        dataOneResultCard!.add(new DataOneResultCard.fromJson(v));
      });
    }
    gmtCreate = json['gmtCreate'];
    gmtModified = json['gmtModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cpsgrpId'] = this.cpsgrpId;
    data['respondent'] = this.respondent;
    data['totalSuggestedScore'] = this.totalSuggestedScore;
    data['totalManualScore'] = this.totalManualScore;
    data['totalFullScore'] = this.totalFullScore;
    if (this.dataOneResultCard != null) {
      data['OneResultCard'] =
          this.dataOneResultCard!.map((v) => v.toJson()).toList();
    }
    data['gmtCreate'] = this.gmtCreate;
    data['gmtModified'] = this.gmtModified;
    return data;
  }
}

/*
{
    "cpsrcdId": "",
    "tNum": 0,
    "cNum": 0,
    "suggestedScore": 9.9,
    "manualScore": 9.9,
    "fullScore": 99.9,
    "more": 0,
    "less": 0,
    "retro": 0,
    "repl": 0,
    "OneWordCard": []
} */
class DataOneResultCard {
  String? cpsrcdId;
  int? evalMode;
  double? weight;
  int? tNum;
  int? cNum;
  double? totalScore;
  double? phoneScore;
  double? toneScore;
  double? fluencyScore;
  int? more;
  int? less;
  int? retro;
  int? repl;
  List<DataOneWordCard>? dataOneWordCard;
  List<Tags>? tags;

  DataOneResultCard(
      {this.cpsrcdId,
      this.tNum,
      this.cNum,
      this.totalScore,
      this.toneScore,
      this.phoneScore,
      this.more,
      this.less,
      this.retro,
      this.repl,
      this.dataOneWordCard,
      this.tags});

  DataOneResultCard.fromJson(Map<String, dynamic> json) {
    cpsrcdId = json['cpsrcdId'];
    evalMode = json['evalMode'];
    weight = json['weight'];
    tNum = json['tNum'];
    cNum = json['cNum'];
    totalScore = json['totalScore'];
    toneScore = json['toneScore'];
    phoneScore = json['phoneScore'];
    fluencyScore = json['fluencyScore'];
    more = json['more'];
    less = json['less'];
    retro = json['retro'];
    repl = json['repl'];
    if (json['OneWordCard'] != null) {
      dataOneWordCard = <DataOneWordCard>[];
      json['OneWordCard'].forEach((v) {
        dataOneWordCard!.add(new DataOneWordCard.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cpsrcdId'] = this.cpsrcdId;
    data['evalMode'] = this.evalMode;
    data['weight'] = this.weight;
    data['tNum'] = this.tNum;
    data['cNum'] = this.cNum;
    data['totalScore'] = this.totalScore;
    data['phoneScore'] = this.phoneScore;
    data['toneScore'] = this.toneScore;
    data['fluencyScore'] = this.fluencyScore;
    data['more'] = this.more;
    data['less'] = this.less;
    data['retro'] = this.retro;
    data['repl'] = this.repl;
    if (this.dataOneWordCard != null) {
      data['OneWordCard'] = this.dataOneWordCard!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

/*
{
  "word": "",
  "pinyin": "",
  "shengMu": "",
  "isWrong": false,
  "yunMu": "",
  "shengDiao": "",
  "wrongShengMu": false,
  "wrongYunMu": false,
  "wrongShengDiao": false
} */
class DataOneWordCard {
  String? word;
  String? pinyin;
  bool? isWrong;
  String? shengMu;
  String? yunMu;
  String? shengDiao;
  bool? wrongShengMu;
  bool? wrongYunMu;
  bool? wrongShengDiao;

  DataOneWordCard(
      {this.word,
      this.pinyin,
      this.shengMu,
      this.yunMu,
      this.shengDiao,
      this.wrongShengMu,
      this.wrongYunMu,
      this.wrongShengDiao,
      this.isWrong});

  DataOneWordCard.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    pinyin = json['pinyin'];
    isWrong = json['isWrong'];
    shengMu = json['shengMu'];
    yunMu = json['yunMu'];
    shengDiao = json['shengDiao'];
    wrongShengMu = json['wrongShengMu'];
    wrongYunMu = json['wrongYunMu'];
    wrongShengDiao = json['wrongShengDiao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['pinyin'] = this.pinyin;
    data['isWrong'] = this.isWrong;
    data['shengMu'] = this.shengMu;
    data['yunMu'] = this.yunMu;
    data['shengDiao'] = this.shengDiao;
    data['wrongShengMu'] = this.wrongShengMu;
    data['wrongYunMu'] = this.wrongYunMu;
    data['wrongShengDiao'] = this.wrongShengDiao;
    return data;
  }
}

/*
{
  "id": 2,
  "name": "ch",
  "weight": 0.2,
  "category": 2
} */
class Tags {
  int? id;
  String? name;
  double? weight;
  int? category;

  Tags({this.id, this.name, this.weight, this.category});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    weight = json['weight'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['weight'] = this.weight;
    data['category'] = this.category;
    return data;
  }
}
