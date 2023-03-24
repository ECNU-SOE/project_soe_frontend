import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:project_soe/src/VNativeLanguageChoice/DataNativeLanguage.dart';

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
    nativeLanguage = (json['firstLanguage'] != null)
        ? await getStringbyNLId(json['firstLanguage'] as int)
        : '暂无';
    sex = (json['sex'] != null) ? json['sex'] as int : 0;
    birth = (json['birth'] != null)
        ? json['birth'] as DateTime
        : DateTime.utc(1900);
    sign = (json['sign'] != null) ? json['sign'] as String : '暂无';
    phone = (json['phone'] != null) ? json['phone'] as String : '暂无';
    email = (json['mail'] != null) ? json['mail'] as String : '暂无';
  }
}

Future<PersonalData?> fetchPersonalData(String? token) async {
  final client = http.Client();
  try {
    final response = await client.get(
      Uri.parse('http://47.101.58.72:8001/api/user/v1/info2'),
      headers: {
        'token': token!,
      },
    );
    final u8decoded = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(u8decoded);
    final accountId = decoded['data']['accountNo'];
    var personalData = PersonalData(token, accountId);
    personalData.parseJson(decoded['data']);
    return personalData;
  } catch (_) {
    return null;
  }
}
