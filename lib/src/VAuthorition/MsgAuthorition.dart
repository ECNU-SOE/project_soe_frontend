import 'dart:async';
import 'dart:convert';

import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;

import 'package:project_soe/src/VAuthorition/DataAuthorition.dart';
import 'package:project_soe/src/VAuthorition/LogicAuthorition.dart';

// 这里用的LoginData & SignupData不是soe项目定义的, 而是package:flutter_login里定义的
class MsgAuthorition {
  Future<String?> postUserAuthorition(LoginData data) async {
    final client = http.Client();
    final bodyMap = {
      'phone': data.name,
      'pwd': data.password,
    };
    final response = await client.post(
      Uri.parse('http://47.101.58.72:8888/user-server/api/user/v1/login'),
      body: jsonEncode(bodyMap),
      headers: {"Content-Type": "application/json"},
      encoding: Encoding.getByName('utf-8'),
    );
    final u8decoded = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(u8decoded);
    if (decoded['code'] == 0) {
      AuthritionState.get().setToken(decoded['data']);
      return null;
    } else {
      return decoded['msg'];
    }
  }

  Future<String?> postSignupUser(SignupData data) async {
    final client = http.Client();
    final bodyMap = {
      'phone': data.name,
      'pwd': data.password,
      // TODO 22.11.17 目前不实现验证码
      'code': 'TODO',
    };
    final response = await client.post(
      Uri.parse('http://47.101.58.72:8888/user-server/api/user/v1/register'),
      body: jsonEncode(bodyMap),
      headers: {"Content-Type": "application/json"},
      encoding: Encoding.getByName('utf-8'),
    );
    final u8decoded = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(u8decoded);
    if (decoded['code'] == '0') {
      return null;
    } else {
      return decoded['msg'];
    }
  }

  Future<DataUserInfo?> getDataUserInfo(String token) async {
    final client = http.Client();
    final response = await client.get(
      Uri.parse('http://47.101.58.72:8001/api/user/v1/info2'),
      headers: {
        'token': token,
      },
    );
    final u8decoded = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(u8decoded);
    final accountId = decoded['data']['accountNo'];
    var userInfo = DataUserInfo(token, accountId);
    userInfo.parseJson(decoded['data']);
    return userInfo;
  }
}
