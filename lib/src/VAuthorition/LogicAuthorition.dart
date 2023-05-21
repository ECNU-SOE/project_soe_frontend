import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  void setlogIn(DataCredentials data, String token) {
    _authoritionToken = token;
    if (!data.saveCredentials) {
      // 23.5.20 TODO : 实现存取
      return;
    }
  }

  void clearCredentials() {}

  static AuthritionState get instance => _instance;
}
