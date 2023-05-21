import 'package:flutter/material.dart';

import 'package:project_soe/src/CComponents/ComponentEditBox.dart';
import 'package:project_soe/src/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/src/CComponents/ComponentTitle.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';

import 'package:project_soe/src/VAuthorition/DataAuthorition.dart';
import 'package:project_soe/src/VAuthorition/MsgAuthorition.dart';
import 'package:project_soe/src/VAuthorition/ViewSignupSuccess.dart';

class ViewSignup extends StatefulWidget {
  DataSignup _dataSignup = DataSignup('', '', '');
  static String routeName = 'Signup';
  @override
  State<ViewSignup> createState() => _ViewSignupState();
}

class _ViewSignupState extends State<ViewSignup> {
  ComponentEditBox _userName = ComponentEditBox(
    hintInfo: '请输入手机号或账号',
    height: 50,
    width: 327,
    hideWord: false,
  );
  ComponentEditBox _nickName = ComponentEditBox(
    hintInfo: '请输入昵称',
    height: 50,
    width: 327,
    hideWord: false,
  );
  ComponentEditBox _password =
      ComponentEditBox(hintInfo: '请输入密码', height: 50, width: 327);
  Future<void> _onSignupClick(BuildContext context) async {
    setState(() {
      widget._dataSignup.nickName = _nickName.getValue();
      widget._dataSignup.userName = _userName.getValue();
      widget._dataSignup.password = _password.getValue();
    });
    String? msg = await MsgAuthorition().postSignupUser(widget._dataSignup);
    if (null == msg) {
      Navigator.of(context).pushReplacementNamed(ViewSignupSuccess.routeName);
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
        title: ComponentTitle(label: '注册          ', style: gTitleStyle),
        automaticallyImplyLeading: true,
        foregroundColor: Color(0xff6E81A0),
        backgroundColor: Color(0xffE4F0FA),
        // foregroundColor: Color(0xE4F0FAFF),
        shadowColor: Color(0x00ffffff),
      ),
      backgroundColor: Color(0xffE4F0FA),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 11, bottom: 0, left: 24),
          child: ComponentSubtitle(label: '手机号', style: gSubtitleStyle1),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Center(
            child: _userName,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 22, bottom: 0, left: 24),
          child: ComponentSubtitle(label: '昵称', style: gSubtitleStyle1),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Center(
            child: _nickName,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 22, bottom: 0, left: 24),
          child: ComponentSubtitle(label: '密码', style: gSubtitleStyle1),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Center(
            child: _password,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 0),
          child: ComponentRoundButton(
            func: () {
              _onSignupClick(context);
            },
            color: Color(0xff7BCBE6),
            child: Text(
              '注册',
              style: gSubtitleStyle1,
            ),
            height: 45,
            width: 289,
            radius: 14,
          ),
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
