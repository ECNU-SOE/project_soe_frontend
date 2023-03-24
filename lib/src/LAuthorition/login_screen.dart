import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:project_soe/src/VAppHome/app_home.dart';

import 'package:project_soe/src/data/login_data.dart';
import 'package:project_soe/src/LAuthorition/authorition.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => Duration(milliseconds: 2000);
  Future<String?> _authUser(LoginData data) async {
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

  Future<String?> _signupUser(SignupData data) async {
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

  // TODO 22.11.16 目前不支持找回密码.
  Future<String?> _recoverPassword(String name) async {
    return '暂不支持';
  }

  String? _userValidator(String? name) {
    if (name!.length != 11) {
      return '手机号长度不正确';
    }
    if (int.tryParse(name) == null) {
      return '无效的手机号';
    }
    return null;
  }

  String? _passwordValidator(String? password) {
    if (password!.length > 16) {
      return '密码过长';
    }
    if (password.length < 8) {
      return '密码过短';
    }
    return null;
  }

  static const String routeName = 'Login';
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '登录',
      loginAfterSignUp: false,
      onLogin: _authUser,
      onSignup: _signupUser,
      userType: LoginUserType.phone,
      userValidator: _userValidator,
      passwordValidator: _passwordValidator,
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacementNamed(context, ApplicationHome.routeName);
      },
      onRecoverPassword: _recoverPassword,
      theme: sLoginTheme,
      messages: sLoginMessages,
    );
  }
}
