import 'package:flutter/material.dart';

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
}

// FIXME 22.11.19 这只是用来测试的临时Token
String gTempToken =
    'soe-token-eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzbWFydC1vcmFsLWV2YWx1YXRpb24iLCJsb2dpblVzZXIiOnsiYWNjb3VudE5vIjoidXNlcl8xNTkzODU4NjQ0MzMwNTQ5MjQ4IiwiaWRlbnRpZnlJZCI6bnVsbCwicm9sZUlkIjpudWxsLCJuaWNrTmFtZSI6IjEzMDAwMDAwMDAwIiwicmVhbE5hbWUiOm51bGwsImZpcnN0TGFuZ3VhZ2UiOm51bGwsInBob25lIjoiMTMwMDAwMDAwMDAiLCJtYWlsIjpudWxsfSwiaWF0IjoxNjY4ODQwNTE5LCJleHAiOjE2Njk0NDUzMTl9.UUJA0oZT6cXW77j8AgXhOC-SWKkksVjpOzAfoNXfrD4';
