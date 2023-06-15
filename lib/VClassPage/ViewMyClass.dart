import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VPracticePage/ViewPractice.dart';
import 'package:project_soe/VUnImplemented/ViewUnimplemented.dart';

import 'package:project_soe/s_o_e_icons_icons.dart';

class MyClassRecData {
  String label;
  IconData icon;
  String routeName;
  MyClassRecData(this.label, this.icon, this.routeName);
}

List<MyClassRecData> ListMyClassRecData = [
  MyClassRecData(
    '已选课程',
    SOEIcons.practice,
    ViewUnimplemented.routeName,
  ),
  MyClassRecData(
    '选课',
    SOEIcons.practice,
    ViewUnimplemented.routeName,
  ),
];

class ViewMyClass extends StatelessWidget {
  static const String routeName = 'myclass';
  Widget _buildRectWidget(int retId, BuildContext context) {
    return ComponentRoundButton(
      func: () {
        Navigator.of(context).pushNamed(ListMyClassRecData[retId].routeName);
      },
      color: gColorE3EDF7RGBA,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ListMyClassRecData[retId].icon,
                color: Color.fromARGB(255, 155, 185, 211),
              ),
              ComponentTitle(
                label: ListMyClassRecData[retId].label,
                style: gInfoTextStyle,
              ),
            ],
          ),
        ),
      ),
      height: 137,
      width: 137,
      radius: 32,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(
        hasBackButton: true,
        title: ComponentTitle(
          label: '我的课程',
          style: gTitleStyle,
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRectWidget(
                0,
                context,
              ),
              _buildRectWidget(
                1,
                context,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: ComponentBottomNavigator(curRouteName: routeName),
      backgroundColor: gColorE3EDF7RGBA,
    );
  }
}
