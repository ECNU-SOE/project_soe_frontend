import 'package:flutter/material.dart';
import 'package:project_soe/src/CComponents/ComponentRoundButton.dart';

import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/src/CComponents/ComponentTitle.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/VAppHome/ViewAppHome.dart';
import 'package:project_soe/src/VAuthorition/ViewLogin.dart';
import 'package:project_soe/src/VExam/DataQuestion.dart';
import 'package:project_soe/src/VPracticePage/DataPractice.dart';
import 'package:project_soe/src/VExam/ViewExam.dart';
import 'package:project_soe/src/VAuthorition/LogicAuthorition.dart';

// FIXME 22.12.4 Temp
List<String> tempTitles = [
  '文章标题1',
  '文章标题2',
  '文章标题3',
  '文章标题4',
  '文章标题5',
  '文章标题6',
];
// FIXME 22.12.4 Temp
List<String> tempTitles1 = [
  '看图说话1',
  '看图说话2',
  '看图说话3',
  '看图说话4',
  '看图说话5',
  '看图说话6',
];
// FIXME 22.12.4 Temp
List<int> tempCount2 = [212, 39, 4];
List<String> tempTitles2 = [
  '声母练习',
  '韵母练习',
  '声调练习',
];
// FIXME 22.12.4 Temp
List<String> tempTitle3 = [
  '专项练习1',
  '专项练习2',
  '专项练习3',
];

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});
  static const String routeName = 'practice';

  List<Widget> _buildPracticeButton(BuildContext context, DataPractice data,
      {bool loggedIn = true}) {
    return [
      Container(
        child: ComponentSubtitle(
          label: data.title,
          style: gSubtitleStyle0,
        ),
      ),
      Container(
        child: Text(
          data.desc,
          style: gSubtitleStyle,
        ),
      ),
      TextButton(
          onPressed: loggedIn
              ? () => Navigator.pushNamed(
                    context,
                    ViewExam.routeName,
                    arguments:
                        ArgsViewExam(data.id, '作业', ViewAppHome.routeName),
                  )
              : () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Container(
                        height: 64.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // CircularProgressIndicator(),
                            Column(
                              children: [
                                ComponentTitle(
                                  label: "登录账号以解锁更多内容.",
                                  style: gInfoTextStyle,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: ComponentRoundButton(
                                    func: () => Navigator.of(context)
                                        .pushReplacementNamed(
                                            ViewLogin.routeName),
                                    color: gColorE1EBF5RGBA,
                                    child: ComponentTitle(
                                      label: '点击登录',
                                      style: gInfoTextStyle,
                                    ),
                                    height: 32.0,
                                    width: 64.0,
                                    radius: 5.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          child: Text(
            '进入作业',
            style: gInfoTextStyle,
          )),
    ];
  }

  Widget _buildViewPracticePageImpl(
      BuildContext context, DataPracticePage dataPage) {
    List<Widget> children = List.empty(growable: true);

    if (!dataPage.dataList.isEmpty) {
      final loggedIn = AuthritionState.instance.hasToken();
      // if (loggedIn) {
      for (final item in dataPage.dataList) {
        children.addAll(_buildPracticeButton(context, item));
      }
      // }
      // else {
      //   children.addAll(_buildPracticeButton(context, dataPage.dataList[0]));
      //   for (int iter = 1; iter < dataPage.dataList.length; ++iter) {
      //     children.addAll(
      //       _buildPracticeButton(
      //         context,
      //         dataPage.dataList[iter],
      //         loggedIn: false,
      //       ),
      //     );
      //   }
      // }
    }
    var _listView = ListView(children: children);
    return Scaffold(
      backgroundColor: gColorE3EDF7RGBA,
      body: _listView,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataPracticePage>(
        future: postGetDataPracticePage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildViewPracticePageImpl(context, snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
