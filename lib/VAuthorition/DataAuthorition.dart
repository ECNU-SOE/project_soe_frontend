import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:project_soe/VNativeLanguageChoice/DataNativeLanguage.dart';

String sDefaultAvatarUri =
    'https://d2w9rnfcy7mm78.cloudfront.net/8040974/original_ff4f1f43d7b72cc31d2eb5b0827ff1ac.png';

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
  String avatarUri;
  String identifyId;
  String nickName;
  String realName;
  String nativeLanguage;
  int sex;
  DateTime birth;
  String sign;
  String phone;
  String email;
  DataUserInfo({
    required this.accountId,
    required this.avatarUri,
    required this.identifyId,
    required this.nickName,
    required this.realName,
    required this.nativeLanguage,
    required this.sex,
    required this.birth,
    required this.sign,
    required this.phone,
    required this.email,
  });

  static String sexToString(int sex) {
    if (sex == 0) return '暂无';
    if (sex == 1) return '男';
    if (sex == 2) return '女';
    return '其他';
  }

  static String birthToString(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  factory DataUserInfo.fromJson(Map<String, dynamic> json) {
    return DataUserInfo(
      accountId: (null == json['accountNo']) ? '' : json['accountNo'] as String,
      avatarUri:
          (null == json['avatarUrl']) ? sDefaultAvatarUri : sDefaultAvatarUri,
      // json['avatarUrl'] as String,
      identifyId:
          (null == json['identifyId']) ? '' : json['identifyId'] as String,
      nickName:
          (json['nickName'] != null) ? json['nickName'] as String : '暂无昵称',
      realName: (json['realName'] != null) ? json['realName'] as String : '暂无',
      nativeLanguage: '暂无',
      sex: (json['sex'] != null) ? json['sex'] as int : 0,
      birth: (json['birth'] != null)
          ? DateTime.parse(json['birth'])
          : DateTime.utc(1900),
      sign: (json['sign'] != null) ? json['sign'] as String : '暂无',
      phone: (json['phone'] != null) ? json['phone'] as String : '暂无',
      email: (json['mail'] != null) ? json['mail'] as String : '暂无',
    );
  }
}
