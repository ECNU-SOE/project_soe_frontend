import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class PersonalData {
  String authToken;
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
  PersonalData(this.authToken, this.accountId);
  void parseJson(Map<String, dynamic> json) {
    if (json['identifyId'] != null) {
      identifyId = json['identifyId'] as String;
    }
    if (json['nickName'] != null) {
      nickName = json['nickName'] as String;
    }
    if (json['realName'] != null) {
      realName = json['realName'] as String;
    }
    if (json['firstLanguage'] != null) {
      nativeLanguage = json['firstLanguage'] as String;
    }
    if (json['sex'] != null) {
      sex = json['sex'] as int;
    }
    if (json['birth'] != null) {
      birth = json['birth'] as DateTime;
    }
    if (json['sign'] != null) {
      sign = json['sign'] as String;
    }
    if (json['phone'] != null) {
      phone = json['phone'] as String;
    }
    if (json['mail'] != null) {
      email = json['mail'] as String;
    }
  }
}

Future<PersonalData?> fetchPersonalData(String token) async {
  final client = http.Client();
  try {
    final response = await client.post(
      Uri.parse('http://47.101.58.72:8888/user-server/api/user/v1/info'),
      body: jsonEncode(
        {'token': token},
      ),
      headers: {
        'Content-Type': 'application/json',
        'token': token,
      },
    );
    final u8decoded = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(u8decoded);
    final accountId = decoded['accountNo'];
    var personalData = PersonalData(token, accountId);
    personalData.parseJson(decoded);
    return personalData;
  } catch (_) {
    return null;
  }
}
