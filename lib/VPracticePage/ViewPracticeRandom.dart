import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VCommon/ViewQuestion.dart';
import 'package:project_soe/VCommon/ViewQuestion_1.dart';
import 'package:project_soe/VMistakeBook/DataMistakeBook.dart';
import 'package:project_soe/VExam/ViewExamResults.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/s_o_e_icons_icons.dart';
import 'package:http/http.dart' as http;
import 'package:element_ui/animations.dart';
import 'package:element_ui/widgets.dart';

dynamic test, aList, tagList;

class ViewPracticeRandom extends StatefulWidget {
  static String routeName = 'practiceRandom';
  ViewPracticeRandom({super.key});

  @override
  State<ViewPracticeRandom> createState() => _ViewPracticeRandomState();
}


class _ViewPracticeRandomState extends State<ViewPracticeRandom> {
  ViewQuestion_1? _inputPage;

  Widget _buildBodyImpl(BuildContext context, DataMistakeDetailListItem dataMistakeDetailListItem) {
    DataMistakeDetailListItem data = dataMistakeDetailListItem;
    var dataQuestion = new DataQuestion(
      wordWeight: data.wordWeight,
      id: "",
      label: data.refText,
      cpsgrpId: data.cpsgrpId,
      topicId: data.topicId,
      evalMode: data.evalMode,
      tags: data.tags);

    var dataQuestionPage = new DataQuestionPageMain(
      evalMode: data.evalMode,
      id: "",
      dataQuestion: dataQuestion,
      cnum: data.cNum,
      tnum: 1,
      cpsgrpId: data.cpsgrpId,
      weight: data.wordWeight == null? 0: data.wordWeight,
      title: '字词训练', // 题目上面标题
      desc: '字词训练', // 题目里面标题
      audioUri: data.audioUrl,
      pinyin: data.pinyin
    );

    _inputPage = ViewQuestion_1(dataPage: dataQuestionPage, titleShow: false);

    return Scaffold(
      appBar: ComponentAppBar(
        title: ComponentTitle(
          label: '随机练习',
          style: gTitleStyle,
        ),
        hasBackButton: true,
      ),
      backgroundColor: gColorE3EDF7RGBA,
      body: _inputPage,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.of(context).pushReplacementNamed(ViewPracticeRandom.routeName);
          },
          child: Text("下一题"),
          foregroundColor: Colors.black,
          backgroundColor: gColorE8F3FBRGBA,
      ),    
      bottomNavigationBar:
          ComponentBottomNavigator(curRouteName: ViewPracticeRandom.routeName),
    );
  }

  @override
  Widget build(BuildContext buildContext) => FutureBuilder<DataMistakeDetailListItem>(
        future: getGetRandomDataMistakeDetail(),// 获取随机一题接口,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("getGetRandomDataMistakeDetail succeeded !!!");
            return _buildBodyImpl(context, snapshot.data!);
          } else {
            print("getGetRandomDataMistakeDetail failed !!!");
            return CircularProgressIndicator();
          }
        },
      );

}