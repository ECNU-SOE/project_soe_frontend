// TODO 11.2 实现此类.
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_soe/src/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/src/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/src/GGlobalParams/Keywords.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';

import 'package:project_soe/src/VAuthorition/ViewLogin.dart';
import 'package:project_soe/src/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/src/VAuthorition/DataAuthorition.dart';
import 'package:project_soe/src/VAuthorition/MsgAuthorition.dart';
import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/src/VPersonalPage/ViewEditPersonal.dart';

class ViewPersonal extends StatelessWidget {
  const ViewPersonal({super.key});
  static const String routeName = 'personal';

  bool _hasToken() => AuthritionState.instance.hasToken();

  Widget _buildDetailLine(List<String> details, List<String> labels) {
    List<Widget> chi = [];
    int len = details.length;
    for (int i = 0; i < len; ++i) {
      chi.add(Padding(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        child: Text(
          details[i],
          style: gInfoTextStyle,
        ),
      ));
      chi.add(Padding(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        child: Text(
          labels[i],
          style: gInfoTextStyle,
        ),
      ));
    }
    return Container(
      height: 32.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: chi,
      ),
    );
  }

  Widget _buildDetailsPanel(DataUserInfo personalData) {
    return Column(
      children: [
        Container(
          height: 120.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // FIXME 临时头像
              Icon(
                Icons.person,
                size: 64.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(personalData.nickName!, style: gInfoTextStyle),
                  Text(
                    '个性签名:${personalData.sign!}',
                    style: gInfoTextStyle,
                  )
                ],
              ),
            ],
          ),
        ),
        const ComponentSubtitle(
          label: '详细信息',
          style: gSubtitleStyle0,
        ),
        _buildDetailLine(['电话号码'], [personalData.phone!]),
        _buildDetailLine(['邮箱'], [personalData.email!]),
        _buildDetailLine([
          '实名',
          '性别',
        ], [
          personalData.realName!,
          DataUserInfo.sexToString(personalData.sex!),
        ]),
        _buildDetailLine([
          '母语',
          '生日',
        ], [
          personalData.nativeLanguage!,
          DataUserInfo.birthToString(personalData.birth!),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _hasToken()
        ? _buildLoggedinPage(context)
        : _buildUnloggedinPage(context);
  }

  Widget _buildUnloggedinPage(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Container(
            height: 64.0,
            alignment: Alignment.topCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.person,
                  size: 32.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!AuthritionState.instance.hasToken()) {
                      Navigator.pushNamed(context, ViewLogin.routeName);
                    }
                  },
                  style: gPersonalPageLoginButtonStyle,
                  child: Text(
                    '尚未登录, 点击登录',
                    style: gSubtitleStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              Icons.lock,
              size: 240.0,
              color: Colors.grey,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '登录解锁更多内容',
              style: gSubtitleStyle,
            )
          ],
        ),
      ],
    );
  }

  void _onEditPersonal(BuildContext context) {
    Navigator.of(context).pushNamed(ViewEditPersonal.routeName);
  }

  void _onSignout(BuildContext context) {
    AuthritionState.instance.setLogout();
    Navigator.of(context).pushReplacementNamed(ViewLogin.routeName);
  }

  Widget _buildLoggedinPage(BuildContext context) {
    return FutureBuilder<DataUserInfo?>(
      future:
          MsgAuthorition().getDataUserInfo(AuthritionState.instance.getToken()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xffE4F0FA),
            body: Column(
              children: <Widget>[
                _buildDetailsPanel(snapshot.data!),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 23),
                  child: ComponentRoundButton(
                    func: () {
                      _onEditPersonal(context);
                    },
                    color: Color(0xffE4F0FA),
                    child: Text(
                      '修改个人信息',
                      style: gSubtitleStyle1,
                    ),
                    height: 45,
                    width: 289,
                    radius: 14,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0, bottom: 23),
                  child: ComponentRoundButton(
                    func: () {
                      _onSignout(context);
                    },
                    color: Color(0xff7BCBE6),
                    child: Text(
                      '登出',
                      style: gSubtitleStyle1,
                    ),
                    height: 45,
                    width: 289,
                    radius: 14,
                  ),
                ),
              ],
            ),
            bottomNavigationBar:
                ComponentBottomNavigator(curRouteName: ViewPersonal.routeName),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
