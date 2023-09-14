import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VMistakeBook/DataMistakeBook.dart';
import 'package:project_soe/VExam/ViewExamResults.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/s_o_e_icons_icons.dart';

import 'package:element_ui/animations.dart';
import 'package:element_ui/widgets.dart';

// ------------------------------------------------
// final Map<> map evalMode: 0,1,2,3 -> 字 词 句子 段落
// ------------------------------------------------

class ViewPracticeRandom extends StatefulWidget {
  static String routeName = 'practiceRandom';
  // DataQuestionPageMain dataQuestionPageMain;
  ViewPracticeRandom({super.key});

  @override
  State<ViewPracticeRandom> createState() => _ViewPracticeRandomState();
}

class _ViewPracticeRandomState extends State<ViewPracticeRandom> {
  ComponentVoiceInput? _inputPage;

  Widget _buildBodyImpl(BuildContext context, DataMistakeDetailListItem dataMistakeDetailListItem) {
    DataMistakeDetailListItem data = dataMistakeDetailListItem;
    var dataQuestion = new DataQuestion(
      wordWeight: data.wordWeight,
      id: "",
      label: data.refText,
      cpsgrpId: data.cpsgrpId,
      topicId: data.topicId,
      evalMode: data.evalMode,);

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
    );

    _inputPage = ComponentVoiceInput(dataPage: dataQuestionPage, titleShow: false);

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