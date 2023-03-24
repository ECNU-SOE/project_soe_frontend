import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project_soe/src/VAuthorition/DataAuthorition.dart';

// String gAuthorithionToken = '';

class AuthritionState {
  static AuthritionState? _instance;
  String? _authoritionToken;
  AuthritionState();

  bool hasToken() {
    if (_authoritionToken == null) return false;
    if (_authoritionToken == '') return false;
    return true;
  }

  String? getToken() {
    return _authoritionToken;
  }

  void setToken(String token) {
    _authoritionToken = token;
  }

  static AuthritionState get() {
    if (_instance == null) {
      _instance = new AuthritionState();
    }
    return _instance!;
  }

  Future<String> getTempToken() async {
    final client = http.Client();
    final tempAccount = Credentials.getTempAccount();
    final bodyMap = {
      'phone': tempAccount.userName,
      'pwd': tempAccount.password,
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
      return decoded['data'];
    } else {
      throw ('');
    }
  }
}
