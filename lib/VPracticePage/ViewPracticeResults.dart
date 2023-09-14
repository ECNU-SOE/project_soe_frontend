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
import 'package:project_soe/VPracticePage/ViewPracticeResultsCard.dart';

class ViewPracticeResults extends StatelessWidget {
  static const String routeName = 'practiceResults';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ViewPracticeResults(),
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

class _ViewPracticeResults extends StatelessWidget {
  Widget _buildItem(BuildContext context, ResJson dataTranscript) {
    // getGetCpsrcdDetail(dataTranscript.cpsgrpId.toString());
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Container(
          decoration: new BoxDecoration(
            color: gColorE3EDF7RGBA,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 75,
                        child: Text("名称："),
                      ),
                      ComponentSubtitle(label: dataTranscript.title.toString(), style: gSubtitleStyle0)
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 75,
                        child: Text("得分："),
                      ),
                      ComponentSubtitle(
                          label: dataTranscript.suggestedScore.toString(),
                          style: gInfoTextStyle1)
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 75,
                        child: Text("作答时间："),
                      ),
                      ComponentSubtitle(
                          label: dataTranscript.gmtCreate.toString(),
                          style: gInfoTextStyle1)
                    ],
                  )
                ],
              ),
              ComponentRoundButton(
                  func: () => {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewPracticeResultsCard(dataTranscript)))
                      },
                  color: gColorE8F3FBRGBA,
                  child: Text("查看"),
                  height: 25,
                  width: 70,
                  radius: 0)
            ],
          )),
    );
  }

  Widget _buildViewPracticeResultsImpl(
      BuildContext context, List<ResJson> resultsXf) {
    List<Widget> listDataResultXf = List.empty(growable: true);
    for (ResJson dataTranscript in resultsXf) {
      listDataResultXf.add(_buildItem(context, dataTranscript));
      print(dataTranscript.itemResult);
    }

    final listViewAll = ListView(
      children: listDataResultXf,
    );

    return listViewAll;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ResJson>>(
      future: postGetDataTranscriptPage(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("postGetDataTranscriptPage failed !!!");
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          print("postGetDataTranscriptPage succeeded !!!");
          return Scaffold(
            body: _buildViewPracticeResultsImpl(context, snapshot.data!),
          );
        } else {
          print("postGetDataTranscriptPage failed !!!");
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
