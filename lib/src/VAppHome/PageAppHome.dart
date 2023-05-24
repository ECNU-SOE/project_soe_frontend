import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_soe/src/CComponents/ComponentRoundButton.dart';

import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/VAppHome/ViewGuide.dart';
import 'package:project_soe/src/s_o_e_icons_icons.dart';
import 'package:project_soe/src/CComponents/ComponentShadowedContainer.dart';
import 'package:project_soe/src/CComponents/ComponentTitle.dart';
import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/src/LNavigation/LogicNavigation.dart';
import 'package:project_soe/src/VNativeLanguageChoice/ViewNativeLanguageChoice.dart';
import 'package:project_soe/src/VPracticePage/ViewPracticeFollow.dart';
import 'package:project_soe/src/VUnImplemented/ViewUnimplemented.dart';
import 'package:project_soe/src/VAppHome/ViewGuide.dart';

class HomeRecData {
  String label;
  IconData icon;
  String routeName;
  HomeRecData(this.label, this.icon, this.routeName);
}

List<HomeRecData> ListHomeRecData = [
  HomeRecData('课前评测', SOEIcons.practice, ViewUnimplemented.routeName),
  HomeRecData('如何上课', SOEIcons.practice, ViewGuide.routeName),
  HomeRecData('邀请好友', SOEIcons.person, ViewUnimplemented.routeName),
  HomeRecData('加入社群', SOEIcons.add_group, ViewUnimplemented.routeName),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routeName = 'home';

  Widget _buildRectWidget(int retId, BuildContext context, Function() func) {
    return ComponentRoundButton(
        func: func,
        color: gColorE3EDF7RGBA,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  ListHomeRecData[retId].icon,
                  color: Color.fromARGB(255, 155, 185, 211),
                ),
                ComponentTitle(
                    label: ListHomeRecData[retId].label, style: gInfoTextStyle)
              ],
            ),
          ),
        ),
        height: 137,
        width: 137,
        radius: 32);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gColorE3EDF7RGBA,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          // const ComponentSubtitle(label: '初次使用，体验全面评测。'),
          // _buildFullExamEntranceWidget(context),
          // _buildSubtitle('推荐内容'),
          ComponentShadowedContainer(
              color: gColorE3EDF7RGBA,
              shadowColor: Color(0x9797977f),
              edgesHorizon: 32,
              edgesVertical: 32,
              child: ComponentTitle(
                label: '今天是你学习的第0天',
                style: gInfoTextStyle0,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ComponentShadowedContainer(
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: ComponentTitle(
                      label: 'MON\n  27', style: gSubtitleStyle0),
                ),
                color: gColorE8F3FBRGBA,
                shadowColor: Color(0x9797977f),
                edgesHorizon: 0,
                edgesVertical: 20,
              ),
              ComponentShadowedContainer(
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: ComponentTitle(
                      label: 'MON\n  27', style: gSubtitleStyle0),
                ),
                color: gColorE8F3FBRGBA,
                shadowColor: Color(0x9797977f),
                edgesHorizon: 0,
                edgesVertical: 20,
              ),
              ComponentShadowedContainer(
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: ComponentTitle(
                      label: 'MON\n  27', style: gSubtitleStyle0),
                ),
                color: gColorE8F3FBRGBA,
                shadowColor: Color(0x9797977f),
                edgesHorizon: 0,
                edgesVertical: 20,
              ),
              ComponentShadowedContainer(
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: ComponentTitle(
                      label: 'MON\n  27', style: gSubtitleStyle0),
                ),
                color: gColorE8F3FBRGBA,
                shadowColor: Color(0x9797977f),
                edgesHorizon: 0,
                edgesVertical: 20,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRectWidget(
                  0,
                  context,
                  () => Navigator.of(context)
                      .pushNamed(ViewUnimplemented.routeName)),
              _buildRectWidget(1, context,
                  () => Navigator.of(context).pushNamed(ViewGuide.routeName)),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRectWidget(
                  2,
                  context,
                  () => Navigator.of(context)
                      .pushNamed(ViewUnimplemented.routeName)),
              _buildRectWidget(
                  3,
                  context,
                  () => Navigator.of(context)
                      .pushNamed(ViewUnimplemented.routeName)),
            ],
          ),
        ],
      ),
    );
  }
}
