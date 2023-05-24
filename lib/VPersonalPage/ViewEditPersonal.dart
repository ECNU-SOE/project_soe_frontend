import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentEditBox.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/VAuthorition/DataAuthorition.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

class ViewEditPersonal extends StatefulWidget {
  static const String routeName = 'personalEdit';
  DataUserInfo? userInfo;
  @override
  State<StatefulWidget> createState() {
    userInfo = AuthritionState.instance.getUserInfo()!;
    return _ViewEditPersonalState();
  }
}

class _ViewEditPersonalState extends State<ViewEditPersonal> {
  List<Widget> _buildRow(DataUserInfo info, String title, String field) {
    return [
      ComponentSubtitle(label: title, style: gSubtitleStyle0),
      ComponentEditBox(hintInfo: field, height: 50, width: 237),
    ];
  }

  void _onSubmitEdit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            child: Text(
              "确定",
              style: gInfoTextStyle,
            ),
            onPressed: () {
              // TODO 23.5.22 修改个人信息
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              '取消',
              style: gInfoTextStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: Container(
          height: 52.0,
          child: Text(
            "确定修改个人信息?",
            style: gInfoTextStyle,
          ),
        ),
      ),
    );
    return;
  }

  Widget _buildEditPersonalDataImpl(BuildContext context) {
    final info = widget.userInfo!;
    List<Widget> children = List.empty(growable: true);
    // children.addAll(_buildRow(info, '用户id', info.identifyId!));
    children.addAll(_buildRow(info, '昵称', info.nickName!));
    children.addAll(_buildRow(info, '真实姓名', info.realName!));
    children.addAll(_buildRow(info, '性别', DataUserInfo.sexToString(info.sex!)));
    children
        .addAll(_buildRow(info, '生日', DataUserInfo.birthToString(info.birth!)));
    children.addAll(_buildRow(info, '个性签名', info.sign!));
    children.addAll(_buildRow(info, '电话号码', info.phone!));
    children.add(
      Padding(
        padding: EdgeInsets.only(top: 23, bottom: 23),
        child: ComponentRoundButton(
          func: () {
            _onSubmitEdit(context);
          },
          color: Color(0xff7BCBE6),
          child: Text(
            '修改',
            style: gSubtitleStyle1,
          ),
          height: 45,
          width: 289,
          radius: 14,
        ),
      ),
    );
    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ComponentTitle(label: '编辑个人信息  ', style: gTitleStyle),
        automaticallyImplyLeading: true,
        foregroundColor: Color(0xff6E81A0),
        backgroundColor: Color(0xffE4F0FA),
        // foregroundColor: Color(0xE4F0FAFF),
        shadowColor: Color(0x00ffffff),
      ),
      backgroundColor: Color(0xffE4F0FA),
      body: _buildEditPersonalDataImpl(context),
      bottomNavigationBar:
          ComponentBottomNavigator(curRouteName: ViewEditPersonal.routeName),
    );
  }
}
