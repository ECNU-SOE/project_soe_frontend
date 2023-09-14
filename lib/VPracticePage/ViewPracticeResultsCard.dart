import 'dart:convert';

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
import 'package:project_soe/VExam/DataQuestion.dart';

import 'package:http/http.dart' as http;

class ViewPracticeResultsCard extends StatelessWidget {
  static const String routeName = 'practiceResultsCard';
  // ViewPracticeResultsCard(ResJson dataTranscript);
  ViewPracticeResultsCard(this.dataTranscript);
  final ResJson? dataTranscript;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ViewPracticeResultsCard(dataTranscript),
      backgroundColor: gColorE8F3FBRGBA,
      bottomNavigationBar: ComponentBottomNavigator(
        curRouteName: routeName,
      ),
      appBar: ComponentAppBar(
        hasBackButton: true,
        title: ComponentTitle(
          label: '答题报告',
          style: gTitleStyle,
        ),
      ),
    );
  }
}

class _ViewPracticeResultsCard extends StatelessWidget {
  // const _ViewPracticeResultsCard({super.key});
  _ViewPracticeResultsCard(this.dataTranscript);
  var dataTranscript;

  Widget _generateScaffoldBodyXf(ResJson dataTranscript) {
    print(dataTranscript.itemResult![0].cNum);
    return Text('data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _generateScaffoldBodyXf(dataTranscript),
        bottomSheet: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                ComponentRoundButton(
                  func: () => Navigator.pop(context),
                  color: gColorE3EDF7RGBA,
                  child: ComponentTitle(label: '结束', style: gTitleStyle),
                  height: 64,
                  width: 200,
                  radius: 6,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )),
      );
  }
}
