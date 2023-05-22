import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_soe/src/GGlobalParams/Keywords.dart';

import 'package:project_soe/src/VAuthorition/DataAuthorition.dart';

// String gAuthorithionToken = '';

class AuthritionState {
  AuthritionState._constructor();

  static AuthritionState _instance = AuthritionState._constructor();

  String? _authoritionToken;
  DataUserInfo? _personalData;

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
    storage.delete(key: s_passwordKey);
    storage.delete(key: s_userNameKey);
  }

  Future<void> setlogIn(DataCredentials data, String token) async {
    _authoritionToken = token;
    if (data.saveCredentials) {
      final storage = new FlutterSecureStorage();
      storage.write(key: s_passwordKey, value: data.userName);
      storage.write(key: s_userNameKey, value: data.password);
    }
  }

  Future<void> setLogout() async {
    _authoritionToken = null;
    final storage = new FlutterSecureStorage();
    storage.delete(key: s_passwordKey);
    storage.delete(key: s_userNameKey);
  }

  void setUserInfo(DataUserInfo info) {
    _personalData = info;
  }

  DataUserInfo? getUserInfo() => _personalData;

  static AuthritionState get instance => _instance;
}
