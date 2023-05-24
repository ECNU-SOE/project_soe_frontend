import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:project_soe/VNativeLanguageChoice/DataNativeLanguage.dart';

class DataCheckBoxInfo {
  String label;
  bool checked = false;
  DataCheckBoxInfo(this.label);
}

class DataProtoco {
  final String title;
  final String text;
  List<DataCheckBoxInfo> checkBoxs = List.empty(growable: true);
  DataProtoco(this.title, this.text);
}

class DataCredentials {
  String userName;
  String password;
  bool saveCredentials = false;
  DataCredentials(this.userName, this.password);
}

class DataSignup {
  String userName;
  String password;
  String nickName;
  DataSignup(this.userName, this.password, this.nickName);
}

class DataUserInfo {
  // String authToken;
  String accountId;
  String? identifyId;
  String? nickName;
  String? realName;
  String? nativeLanguage;
  int? sex;
  DateTime? birth;
  String? sign;
  String? phone;
  String? email;
  DataUserInfo(this.accountId);

  static String sexToString(int sex) {
    if (sex == 0) return '暂无';
    if (sex == 1) return '男';
    if (sex == 2) return '女';
    return '其他';
  }

  static String birthToString(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  Future<void> parseJson(Map<String, dynamic> json) async {
    if (json['identifyId'] != null) {
      identifyId = json['identifyId'] as String;
    }
    nickName = (json['nickName'] != null) ? json['nickName'] as String : '暂无昵称';
    realName = (json['realName'] != null) ? json['realName'] as String : '暂无';

    nativeLanguage = '暂无';
    sex = (json['sex'] != null) ? json['sex'] as int : 0;
    birth = (json['birth'] != null)
        ? DateTime.parse(json['birth'])
        : DateTime.utc(1900);
    sign = (json['sign'] != null) ? json['sign'] as String : '暂无';
    phone = (json['phone'] != null) ? json['phone'] as String : '暂无';
    email = (json['mail'] != null) ? json['mail'] as String : '暂无';
  }
}
