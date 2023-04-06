import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:project_soe/src/VAppHome/ViewAppHome.dart';
import 'package:project_soe/src/VAuthorition/DataAuthorition.dart';
import 'package:project_soe/src/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/src/VAuthorition/MsgAuthorition.dart';

class ViewLogin extends StatelessWidget {
  const ViewLogin({super.key});

  Duration get loginTime => Duration(milliseconds: 2000);
  // 这里用的LoginData & SignupData不是soe项目定义的, 而是package:flutter_login里定义的
  Future<String?> _authUser(LoginData data) async {
    return MsgAuthorition().postUserAuthorition(data);
  }

  Future<String?> _signupUser(SignupData data) async {
    return MsgAuthorition().postSignupUser(data);
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
