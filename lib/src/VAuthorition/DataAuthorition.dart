import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:project_soe/src/VNativeLanguageChoice/DataNativeLanguage.dart';

class DataCheckBoxInfo {
  String label;
  bool checked = false;
  DataCheckBoxInfo(this.label);
}

class DataProtoco {
  final String title;
  final String text;
  List<DataCheckBoxInfo> checkBoxs = List.empty(growable: true);
  DataProtoco(this.title, this.text);
}

class DataCredentials {
  String userName;
  String password;
  bool saveCredentials = false;
  DataCredentials(this.userName, this.password);
}

class DataSignup {
  String userName;
  String password;
  String nickName;
  DataSignup(this.userName, this.password, this.nickName);
}

// final sLoginMessages = LoginMessages(
//   userHint: "手机号",
//   passwordHint: "密码",
//   confirmPasswordHint: "确认密码",
//   forgotPasswordButton: "忘记密码",
//   loginButton: "登录",
//   signupButton: "注册",
//   recoverPasswordButton: "找回密码",
//   recoverPasswordIntro: "输入手机号以修改密码",
//   recoverPasswordDescription: "你将收到短信验证码",
//   goBackButton: "返回",
//   confirmPasswordError: "两次输入的密码不一致",
//   recoverPasswordSuccess: "找回密码成功",
//   flushbarTitleError: "登陆失败",
//   flushbarTitleSuccess: "登陆成功",
//   signUpSuccess: "注册成功",
//   // providersTitleFirst :,
//   // providersTitleSecond :,
//   // additionalSignUpSubmitButton :,
//   // additionalSignUpFormDescription :,
//   confirmSignupIntro: "#confirmSignupIntro",
//   confirmationCodeHint: "#confirmationCodeHint",
//   confirmationCodeValidationError: "#confirmationCodeValidationError",
//   resendCodeButton: "#resendCodeButton",
//   resendCodeSuccess: "#resendCodeSuccess",
//   confirmSignupButton: "#confirmSignupButton",
//   confirmSignupSuccess: "#confirmSignupSuccess",
//   confirmRecoverIntro: "#confirmRecoverIntro",
//   recoveryCodeHint: "#recoveryCodeHint",
//   recoveryCodeValidationError: "#recoveryCodeValidationError",
//   setPasswordButton: "重设密码",
//   confirmRecoverSuccess: "#confirmRecoverSuccess",
//   recoverCodePasswordDescription: "#recoverCodePasswordDescription",
// );

// final inputBorder = BorderRadius.vertical(
//   bottom: Radius.circular(10.0),
//   top: Radius.circular(20.0),
// );

// final sLoginTheme = LoginTheme(
//   primaryColor: Colors.blue[50],
//   accentColor: Colors.white60,
//   errorColor: Colors.deepOrange,
//   titleStyle: TextStyle(
//     color: Colors.black87,
//     fontFamily: 'Quicksand',
//     letterSpacing: 4,
//   ),
//   bodyStyle: TextStyle(
//     // fontStyle: FontStyle.italic,
//     decoration: TextDecoration.underline,
//   ),
//   textFieldStyle: TextStyle(
//     color: Colors.orange,
//     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
//   ),
//   buttonStyle: TextStyle(
//     fontWeight: FontWeight.w800,
//     color: Colors.yellow,
//   ),
//   cardTheme: CardTheme(
//     color: Colors.yellow.shade100,
//     elevation: 5,
//     margin: EdgeInsets.only(top: 15),
//     shape:
//         ContinuousRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
//   ),
//   inputTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: Colors.purple.withOpacity(.1),
//     contentPadding: EdgeInsets.zero,
//     errorStyle: TextStyle(
//       backgroundColor: Colors.orange,
//       color: Colors.white,
//     ),
//     labelStyle: TextStyle(fontSize: 12),
//     enabledBorder: UnderlineInputBorder(
//       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
//       borderRadius: inputBorder,
//     ),
//     focusedBorder: UnderlineInputBorder(
//       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
//       borderRadius: inputBorder,
//     ),
//     errorBorder: UnderlineInputBorder(
//       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
//       borderRadius: inputBorder,
//     ),
//     focusedErrorBorder: UnderlineInputBorder(
//       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
//       borderRadius: inputBorder,
//     ),
//     disabledBorder: UnderlineInputBorder(
//       borderSide: BorderSide(color: Colors.grey, width: 5),
//       borderRadius: inputBorder,
//     ),
//   ),
//   buttonTheme: LoginButtonTheme(
//     splashColor: Colors.purple,
//     backgroundColor: Colors.pinkAccent,
//     highlightColor: Colors.lightGreen,
//     elevation: 9.0,
//     highlightElevation: 6.0,
//     shape: BeveledRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
//     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
//   ),
// );

class DataUserInfo {
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
  DataUserInfo(this.authToken, this.accountId);

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
    // nativeLanguage = (json['firstLanguage'] != null) ?
    // ? await getStringbyNLId(json['firstLanguage'] as int)
    // : '暂无';
    nativeLanguage = '暂无';
    sex = (json['sex'] != null) ? json['sex'] as int : 0;
    birth = (json['birth'] != null)
        ? DateTime.parse(json['birth'])
        : DateTime.utc(1900);
    sign = (json['sign'] != null) ? json['sign'] as String : '暂无';
    phone = (json['phone'] != null) ? json['phone'] as String : '暂无';
    email = (json['mail'] != null) ? json['mail'] as String : '暂无';
  }
}
