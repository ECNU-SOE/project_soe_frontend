import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_soe/src/CComponents/ComponentEditBox.dart';
import 'package:project_soe/src/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/src/CComponents/ComponentTitle.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';

import 'package:project_soe/src/VAppHome/ViewAppHome.dart';
import 'package:project_soe/src/VAuthorition/DataAuthorition.dart';
import 'package:project_soe/src/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/src/VAuthorition/MsgAuthorition.dart';
import 'package:project_soe/src/VAuthorition/ViewSignup.dart';

// 在自动登录的情况下, 是不会进入登录界面的, 直接发协议登录即可.
// 故如果进入了登录界面, 那肯定没有自动登录. 所以登录数据不从db取, 而是直接用空的
class ViewLogin extends StatefulWidget {
  static const String routeName = 'Login';
  DataCredentials _dataCredentials = DataCredentials('', '');
  @override
  State<ViewLogin> createState() => _ViewLoginState();
}

class _ViewLoginState extends State<ViewLogin> {
  ComponentEditBox _password =
      ComponentEditBox(hintInfo: '请输入密码', height: 50, width: 327);
  ComponentEditBox _userName = ComponentEditBox(
    hintInfo: '请输入手机号或账号',
    height: 50,
    width: 327,
    hideWord: false,
  );

  void onSigninClick(BuildContext context) async {
    setState(() {
      widget._dataCredentials.userName = _userName.getValue();
      widget._dataCredentials.password = _password.getValue();
    });
    String? msg =
        await MsgAuthorition().postUserAuthorition(widget._dataCredentials);
    if (null == msg) {
      Navigator.pushReplacementNamed(context, ViewAppHome.routeName);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 48.0,
            child: Column(
              children: [
                Text(
                  msg,
                  style: gInfoTextStyle,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ComponentTitle(label: '登录', style: gTitleStyle),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffE4F0FA),
        // foregroundColor: Color(0xE4F0FAFF),
        shadowColor: Color(0x00ffffff),
      ),
      backgroundColor: Color(0xffE4F0FA),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Center(
            child: _userName,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: _password,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 40),
              child: Checkbox(
                value: widget._dataCredentials.saveCredentials,
                onChanged: (_) => setState(() =>
                    widget._dataCredentials.saveCredentials =
                        !widget._dataCredentials.saveCredentials),
              ),
            ),
            Text(
              '保持登录状态',
              style: gInfoTextStyle1,
            ),
            Padding(
              padding: EdgeInsets.only(left: 80, right: 33),
              child: Text(
                '忘记密码？',
                style: gInfoTextStyle1,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 23),
          child: ComponentRoundButton(
            func: () {
              onSigninClick(context);
            },
            color: Color(0xff7BCBE6),
            child: Text(
              '登录',
              style: gSubtitleStyle1,
            ),
            height: 45,
            width: 289,
            radius: 14,
          ),
        ),
        ComponentRoundButton(
          func: () {
            Navigator.of(context).pushNamed(ViewSignup.routeName);
          },
          color: Color(0xffE4F0FA),
          child: Text(
            '注册',
            style: gSubtitleStyle1,
          ),
          height: 45,
          width: 289,
          radius: 14,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Checkbox(value: false, onChanged: (_) {}),
              ),
              Text(
                '暂无用户协议, 此空预留',
                style: gInfoTextStyle,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        )
      ]),
    );
  }
}
