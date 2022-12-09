import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/material.dart';

class Credentials {
  final String userName;
  final String password;
  Credentials(this.userName, this.password);
  static Credentials getTempAccount() {
    return Credentials('13000000000', '00000000');
  }
}

final sLoginMessages = LoginMessages(
  userHint: "手机号",
  passwordHint: "密码",
  confirmPasswordHint: "确认密码",
  forgotPasswordButton: "忘记密码",
  loginButton: "登录",
  signupButton: "注册",
  recoverPasswordButton: "找回密码",
  recoverPasswordIntro: "输入手机号以修改密码",
  recoverPasswordDescription: "你将收到短信验证码",
  goBackButton: "返回",
  confirmPasswordError: "两次输入的密码不一致",
  recoverPasswordSuccess: "找回密码成功",
  flushbarTitleError: "#flushbarTitleError",
  flushbarTitleSuccess: "#flushbarTitleSuccess",
  signUpSuccess: "注册成功",
  // providersTitleFirst :,
  // providersTitleSecond :,
  // additionalSignUpSubmitButton :,
  // additionalSignUpFormDescription :,
  confirmSignupIntro: "#confirmSignupIntro",
  confirmationCodeHint: "#confirmationCodeHint",
  confirmationCodeValidationError: "#confirmationCodeValidationError",
  resendCodeButton: "#resendCodeButton",
  resendCodeSuccess: "#resendCodeSuccess",
  confirmSignupButton: "#confirmSignupButton",
  confirmSignupSuccess: "#confirmSignupSuccess",
  confirmRecoverIntro: "#confirmRecoverIntro",
  recoveryCodeHint: "#recoveryCodeHint",
  recoveryCodeValidationError: "#recoveryCodeValidationError",
  setPasswordButton: "重设密码",
  confirmRecoverSuccess: "#confirmRecoverSuccess",
  recoverCodePasswordDescription: "#recoverCodePasswordDescription",
);

final inputBorder = BorderRadius.vertical(
  bottom: Radius.circular(10.0),
  top: Radius.circular(20.0),
);

final sLoginTheme = LoginTheme(
  primaryColor: Colors.blue[50],
  accentColor: Colors.white60,
  errorColor: Colors.deepOrange,
  titleStyle: TextStyle(
    color: Colors.black87,
    fontFamily: 'Quicksand',
    letterSpacing: 4,
  ),
  bodyStyle: TextStyle(
    // fontStyle: FontStyle.italic,
    decoration: TextDecoration.underline,
  ),
  textFieldStyle: TextStyle(
    color: Colors.orange,
    shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
  ),
  buttonStyle: TextStyle(
    fontWeight: FontWeight.w800,
    color: Colors.yellow,
  ),
  cardTheme: CardTheme(
    color: Colors.yellow.shade100,
    elevation: 5,
    margin: EdgeInsets.only(top: 15),
    shape:
        ContinuousRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
  ),
  inputTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.purple.withOpacity(.1),
    contentPadding: EdgeInsets.zero,
    errorStyle: TextStyle(
      backgroundColor: Colors.orange,
      color: Colors.white,
    ),
    labelStyle: TextStyle(fontSize: 12),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
      borderRadius: inputBorder,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
      borderRadius: inputBorder,
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade700, width: 7),
      borderRadius: inputBorder,
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade400, width: 8),
      borderRadius: inputBorder,
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 5),
      borderRadius: inputBorder,
    ),
  ),
  buttonTheme: LoginButtonTheme(
    splashColor: Colors.purple,
    backgroundColor: Colors.pinkAccent,
    highlightColor: Colors.lightGreen,
    elevation: 9.0,
    highlightElevation: 6.0,
    shape: BeveledRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    // shape: CircleBorder(side: BorderSide(color: Colors.green)),
    // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
  ),
);
