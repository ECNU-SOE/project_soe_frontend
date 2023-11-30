import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

class DataExamResult {
  String? tid;
  String? gid;
  String? name;
  String? uid;
  double? suggestedScore;
  double? allTotalScore;
  double? allPhoneScore;
  double? allToneScore;
  double? allFluencyScore;
  int? allLess;
  int? allMore;
  int? allRepl;
  int? allRetro;
  List<NameScore>? totPhoneScore;
  List<NameScore>? totToneScore;
  List<NameScore>? totFluencyScore;
  List<NameScore>? totTotalScore;
  List<NameNum>? totLess;
  List<NameNum>? totMore;
  List<NameNum>? totRepl;
  List<NameNum>? totRetro;
  List<NameNum>? wrongShengMu;
  List<NameNum>? wrongYunMu;

  String? gmtCreate;
  String? gmtModified;

  DataExamResult(
      {this.suggestedScore,
      this.allTotalScore,
      this.allPhoneScore,
      this.allToneScore,
      this.allFluencyScore,
      this.allLess,
      this.allMore,
      this.allRepl,
      this.allRetro,
      this.totPhoneScore,
      this.totToneScore,
      this.totFluencyScore,
      this.totTotalScore,
      this.totLess,
      this.totMore,
      this.totRepl,
      this.totRetro,
      this.wrongShengMu,
      this.wrongYunMu});

  DataExamResult.fromJson(Map<String, dynamic> json) {
    suggestedScore = json['suggestedScore'];
    allTotalScore = json['allTotalScore'];
    allPhoneScore = json['allPhoneScore'];
    allToneScore = json['allToneScore'];
    allFluencyScore = json['allFluencyScore'];
    allLess = json['allLess'];
    allMore = json['allMore'];
    allRepl = json['allRepl'];
    allRetro = json['allRetro'];
    if (json['totPhoneScore'] != null) {
      totPhoneScore = <NameScore>[];
      json['totPhoneScore'].forEach((v) {
        totPhoneScore!.add(new NameScore.fromJson(v));
      });
    }
    if (json['totToneScore'] != null) {
      totToneScore = <NameScore>[];
      json['totToneScore'].forEach((v) {
        totToneScore!.add(new NameScore.fromJson(v));
      });
    }
    if (json['totFluencyScore'] != null) {
      totFluencyScore = <NameScore>[];
      json['totFluencyScore'].forEach((v) {
        totFluencyScore!.add(new NameScore.fromJson(v));
      });
    }
    if (json['totTotalScore'] != null) {
      totTotalScore = <NameScore>[];
      json['totTotalScore'].forEach((v) {
        totTotalScore!.add(new NameScore.fromJson(v));
      });
    }
    if (json['totLess'] != null) {
      totLess = <NameNum>[];
      json['totLess'].forEach((v) {
        totLess!.add(new NameNum.fromJson(v));
      });
    }
    if (json['totMore'] != null) {
      totMore = <NameNum>[];
      json['totMore'].forEach((v) {
        totMore!.add(new NameNum.fromJson(v));
      });
    }
    if (json['totRepl'] != null) {
      totRepl = <NameNum>[];
      json['totRepl'].forEach((v) {
        totRepl!.add(new NameNum.fromJson(v));
      });
    }
    if (json['totRetro'] != null) {
      totRetro = <NameNum>[];
      json['totRetro'].forEach((v) {
        totRetro!.add(new NameNum.fromJson(v));
      });
    }
    if (json['wrongShengMu'] != null) {
      wrongShengMu = <NameNum>[];
      json['wrongShengMu'].forEach((v) {
        wrongShengMu!.add(new NameNum.fromJson(v));
      });
    }
    if (json['wrongYunMu'] != null) {
      wrongYunMu = <NameNum>[];
      json['wrongYunMu'].forEach((v) {
        wrongYunMu!.add(new NameNum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suggestedScore'] = this.suggestedScore;
    data['allTotalScore'] = this.allTotalScore;
    data['allPhoneScore'] = this.allPhoneScore;
    data['allToneScore'] = this.allToneScore;
    data['allFluencyScore'] = this.allFluencyScore;
    data['allLess'] = this.allLess;
    data['allMore'] = this.allMore;
    data['allRepl'] = this.allRepl;
    data['allRetro'] = this.allRetro;
    if (this.totPhoneScore != null) {
      data['totPhoneScore'] =
          this.totPhoneScore!.map((v) => v.toJson()).toList();
    }
    if (this.totToneScore != null) {
      data['totToneScore'] = this.totToneScore!.map((v) => v.toJson()).toList();
    }
    if (this.totFluencyScore != null) {
      data['totFluencyScore'] =
          this.totFluencyScore!.map((v) => v.toJson()).toList();
    }
    if (this.totTotalScore != null) {
      data['totTotalScore'] =
          this.totTotalScore!.map((v) => v.toJson()).toList();
    }
    if (this.totLess != null) {
      data['totLess'] = this.totLess!.map((v) => v.toJson()).toList();
    }
    if (this.totMore != null) {
      data['totMore'] = this.totMore!.map((v) => v.toJson()).toList();
    }
    if (this.totRepl != null) {
      data['totRepl'] = this.totRepl!.map((v) => v.toJson()).toList();
    }
    if (this.totRetro != null) {
      data['totRetro'] = this.totRetro!.map((v) => v.toJson()).toList();
    }
    if (this.wrongShengMu != null) {
      data['wrongShengMu'] = this.wrongShengMu!.map((v) => v.toJson()).toList();
    }
    if (this.wrongYunMu != null) {
      data['wrongYunMu'] = this.wrongYunMu!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NameScore {
  String? name;
  double? score;

  NameScore({this.name, this.score});

  NameScore.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['score'] = this.score;
    return data;
  }
}


class NameNum {
  String? name;
  int? num;

  NameNum({this.name, this.num});

  NameNum.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    num = json['num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['num'] = this.num;
    return data;
  }
}
