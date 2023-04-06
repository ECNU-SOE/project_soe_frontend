import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:project_soe/src/VAuthorition/DataAuthorition.dart';

// String gAuthorithionToken = '';

class AuthritionState {
  static AuthritionState? _instance;
  String? _authoritionToken;
  DataUserInfo? _personalData;
  AuthritionState();

  bool hasToken() {
    if (kDebugMode) {
      return true;
    }
    if (_authoritionToken == null) return false;
    if (_authoritionToken == '') return false;
    return true;
  }

  String getToken() {
    if (kDebugMode) {
      return "soe-token-eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzbWFydC1vcmFsLWV2YWx1YXRpb24iLCJsb2dpblVzZXIiOnsiYWNjb3VudE5vIjoidXNlcl8xNTkzODU4NjQ0MzMwNTQ5MjQ4IiwiaWRlbnRpZnlJZCI6bnVsbCwicm9sZUlkIjpudWxsLCJuaWNrTmFtZSI6IjEzMDAwMDAwMDAwIiwicmVhbE5hbWUiOm51bGwsImZpcnN0TGFuZ3VhZ2UiOm51bGwsInBob25lIjoiMTMwMDAwMDAwMDAiLCJtYWlsIjpudWxsfSwiaWF0IjoxNjgwNzQ5NTEzLCJleHAiOjE2ODEzNTQzMTN9.QE6iMfWTxwBDJtTwERWOWtrf9Py1LoWBbdonAFtuVgY";
    }
    if (_authoritionToken == null) {
      return "soe-token-eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzbWFydC1vcmFsLWV2YWx1YXRpb24iLCJsb2dpblVzZXIiOnsiYWNjb3VudE5vIjoidXNlcl8xNTkzODU4NjQ0MzMwNTQ5MjQ4IiwiaWRlbnRpZnlJZCI6bnVsbCwicm9sZUlkIjpudWxsLCJuaWNrTmFtZSI6IjEzMDAwMDAwMDAwIiwicmVhbE5hbWUiOm51bGwsImZpcnN0TGFuZ3VhZ2UiOm51bGwsInBob25lIjoiMTMwMDAwMDAwMDAiLCJtYWlsIjpudWxsfSwiaWF0IjoxNjgwNzQ5NTEzLCJleHAiOjE2ODEzNTQzMTN9.QE6iMfWTxwBDJtTwERWOWtrf9Py1LoWBbdonAFtuVgY";
    }
    return _authoritionToken!;
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
}
