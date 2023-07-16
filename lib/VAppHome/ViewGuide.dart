import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentShadowedContainer.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';

const String s_intro =
    '    “汉语正音”是基于 AI＋定制训练为主的汉语标准音学习 APP，由中国国际中文教育一流专业院校专家基于丰富的教学经验与科研成果加以设计，旨在帮助汉语学习者培养汉语标准音意识，有效提高汉语语音水平。\n      在“汉语正音”，你可以：\n    （1）根据“课前测评”结果，在“我的课程”中进行适合的 AI 课程训练。\n    （2）根据所推送的组合训练模式，循序渐进地参加每日训练与测评。\n    （3）可以报名参加 1 对 1、1 对 2、1 对 3 或者 1 对 4 的在线直播课程的学习。\n    （4）可以加入“汉语正音社区”，与其他学习者一起进行训练。';

class ViewGuide extends StatelessWidget {
  static String routeName = 'guide';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(
        hasBackButton: true,
      ),
      backgroundColor: Color(0xffe3edf7),
      body: ComponentShadowedContainer(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 50)),
            ComponentTitle(label: '训练指南', style: gTitleStyle),
            Padding(padding: EdgeInsets.only(top: 22.0)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 9),
              child: Text(
                s_intro,
                style: gInfoTextStyle,
              ),
            ),
          ],
        ),
        color: Color(0xffffffff),
        shadowColor: Color(0x3f3f3f3f),
        edgesHorizon: 33,
        edgesVertical: 25,
      ),
      bottomNavigationBar:
          ComponentBottomNavigator(curRouteName: ViewGuide.routeName),
    );
  }
}
