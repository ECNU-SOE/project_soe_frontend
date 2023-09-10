import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentShadowedContainer.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';

import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/VClassPage/DataClass.dart';
import 'package:project_soe/VClassPage/ViewClassDetail.dart';
import 'package:project_soe/VClassPage/ViewMyClass.dart';
import 'package:project_soe/VMistakeBook/ViewMistakeBook.dart';
import 'package:project_soe/VPracticePage/ViewPractice.dart';
import 'package:project_soe/VPracticePage/ViewPracticeRandom.dart';
import 'package:project_soe/VUnImplemented/ViewUnimplemented.dart';
import 'package:project_soe/s_o_e_icons_icons.dart';

class ClassRecData {
  String label;
  IconData icon;
  String routeName;
  ClassRecData(this.label, this.icon, this.routeName);
}

List<ClassRecData> ListClassRecData = [
  ClassRecData('我的课程', SOEIcons.my_class, ViewMyClass.routeName),
  ClassRecData('训练题库', SOEIcons.public_lib, ViewPractice.routeName),
  ClassRecData('个人题库', SOEIcons.personal_lib, ViewUnimplemented.routeName),
  ClassRecData('错题本', SOEIcons.practice_history, ViewMistakeBook.routeName),
  ClassRecData('随机一题', SOEIcons.practice_history, ViewPracticeRandom.routeName),
];

class ViewClass extends StatelessWidget {
  const ViewClass({super.key});
  static const String routeName = 'class';

  Widget _buildRectWidget(int retId, BuildContext context) {
    return ComponentRoundButton(
      func: () {
        Navigator.of(context).pushNamed(ListClassRecData[retId].routeName);
      },
      color: gColorE3EDF7RGBA,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ListClassRecData[retId].icon,
                color: Color.fromARGB(255, 155, 185, 211),
              ),
              ComponentTitle(
                  label: ListClassRecData[retId].label, style: gInfoTextStyle)
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
        title: ComponentTitle(
          label: '课程',
          style: gTitleStyle,
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 30)),
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
          Padding(padding: EdgeInsets.only(top: 30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRectWidget(
                2,
                context,
              ),
              _buildRectWidget(
                3,
                context,
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRectWidget(
                4,
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
