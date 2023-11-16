import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VAppHome/ViewAppHome.dart';
import 'package:project_soe/VAuthorition/ViewLogin.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/VPracticePage/DataPractice.dart';
import 'package:project_soe/VExam/ViewExam.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VPracticePage/ViewPracticeResults.dart';

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

class ViewPractice extends StatelessWidget {
  const ViewPractice({super.key});
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
          data.description,
          style: gSubtitleStyle,
        ),
      ),
      TextButton(
          onPressed: loggedIn
              ? () => Navigator.pushNamed(
                    context,
                    ViewExam.routeName,
                    arguments:
                        ArgsViewExam(data.id, data.description, ViewAppHome.routeName, 0.0),
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

  Widget _buildViewPracticeImpl(
      BuildContext context, DataPracticePage dataPage) {
    List<Widget> children = List.empty(growable: true);

    if (!dataPage.dataList.isEmpty) {
      final loggedIn = AuthritionState.instance.hasToken();
      // if (loggedIn) {
      for (final item in dataPage.dataList) {
        children.addAll(_buildPracticeButton(context, item));
      }
    }

    var _listView = ListView(children: children);

    return Scaffold(
      appBar: ComponentAppBar(
        title: ComponentTitle(
          label: '公共练习',
          style: gTitleStyle,
        ),
        hasBackButton: true,
      ),
      backgroundColor: gColorE3EDF7RGBA,
      body: _listView,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(context, new MaterialPageRoute(builder: (
              BuildContext context,
            ) {
              return new ViewPracticeResults();
            }));
          },
          child: Text("查看报告"),
          foregroundColor: Colors.black,
          backgroundColor: gColorE8F3FBRGBA,
      ),    
      bottomNavigationBar:
          ComponentBottomNavigator(curRouteName: ViewPractice.routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataPracticePage>(
        future: postGetDataPracticePage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("postGetDataPracticePage succeeded!!!");
            return _buildViewPracticeImpl(context, snapshot.data!);
          } else {
            print("postGetDataPracticePage failed!!!");
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
