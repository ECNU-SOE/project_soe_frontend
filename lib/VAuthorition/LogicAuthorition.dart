import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_soe/GGlobalParams/Keywords.dart';
import 'package:project_soe/VAuthorition/DataAuthorition.dart';

// String gAuthorithionToken = '';

class AuthritionState {
  AuthritionState._constructor();

  static AuthritionState _instance = AuthritionState._constructor();

  String? _authoritionToken;
  DataUserInfo? _personalData;
  bool _userInfoDirty = false;

  bool hasToken() {
    if (_authoritionToken == null) return false;
    if (_authoritionToken == '') return false;
    return true;
  }

  String getToken() {
    if (_authoritionToken == null) {
      throw ('null token');
    }
    return _authoritionToken!;
  }

  Future<void> clearCredentials() async {
    final storage = new FlutterSecureStorage();
    storage.delete(key: sPasswordKey);
    storage.delete(key: sUserNameKey);
  }

  Future<void> setlogIn(DataCredentials data, String token) async {
    _authoritionToken = token;
    if (data.saveCredentials) {
      final storage = new FlutterSecureStorage();
      storage.write(key: sPasswordKey, value: data.userName);
      storage.write(key: sUserNameKey, value: data.password);
    }
    getUserInfo();
    _postUserSign();
  }

  Future<void> setLogout() async {
    _authoritionToken = null;
    final storage = new FlutterSecureStorage();
    storage.delete(key: sPasswordKey);
    storage.delete(key: sUserNameKey);
  }

  void setUserInfoDirty() {
    _userInfoDirty = true;
  }

  Future<void> _postUserSign() async {
    final client = http.Client();
    final response = await client.get(
      Uri.parse('http://47.101.58.72:8888/user-server/api/user/v1/sign'),
      headers: {
        'token': _authoritionToken!,
      },
    );
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<DataUserInfo> getUserInfo() async {
    if (null == _personalData || _userInfoDirty) {
      _userInfoDirty = false;
      _personalData = await _getDataUserInfo(_authoritionToken!);
    }
    return _personalData!;
  }

  Future<DataUserInfo> _getDataUserInfo(String token) async {
    final client = http.Client();
    final response = await client.get(
      Uri.parse('http://47.101.58.72:8888/user-server/api/user/v1/info'),
      headers: {
        'token': token,
      },
    );
    final u8decoded = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(u8decoded);
    var userInfo = DataUserInfo.fromJson(decoded['data']);
    return userInfo;
  }

  static AuthritionState get instance => _instance;
}
