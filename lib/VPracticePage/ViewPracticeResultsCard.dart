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
import 'package:project_soe/VExam/DataExamResult.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/VPracticePage/DataPractice.dart';
import 'package:project_soe/VExam/ViewExam.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VExam/DataQuestion.dart';

import 'package:http/http.dart' as http;

class ViewPracticeResultsCard extends StatelessWidget {
  static const String routeName = 'practiceResultsCard';
  ViewPracticeResultsCard(this.dataTranscript);
  final DataExamResult? dataTranscript;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ViewPracticeResultsCard(dataTranscript),
      backgroundColor: gColorE8F3FBRGBA,
      appBar: ComponentAppBar(
        hasBackButton: true,
        title: ComponentTitle(
          label: '答题报告',
          style: gTitleStyle,
        ),
      ),
      bottomNavigationBar: ComponentBottomNavigator(
        curRouteName: routeName,
      ),
    );
  }
}

class _ViewPracticeResultsCard extends StatelessWidget {
  // const _ViewPracticeResultsCard({super.key});
  _ViewPracticeResultsCard(this.dataTranscript);
  var dataTranscript;

  Widget _generateScaffoldBodyXf(DataExamResult dataTranscript) {
    List<DataRow> scores = List.empty(growable: true);
    List<DataRow> mlpp = List.empty(growable: true);
    scores.add(DataRow(cells: [
      DataCell(Center(
          child: Text(
              style: TextStyle(fontSize: 12),
              maxLines: 5,
              "总成绩(${dataTranscript.allTotalScore!.toStringAsFixed(2)})"))),
      DataCell(Text("${dataTranscript.allTotalScore!.toStringAsFixed(2)}")),
      DataCell(Text("${dataTranscript.allToneScore!.toStringAsFixed(2)}")),
      DataCell(Text("${dataTranscript.allPhoneScore!.toStringAsFixed(2)}")),
      DataCell(Text("${dataTranscript.allFluencyScore!.toStringAsFixed(2)}")),
    ]));
    mlpp.add(DataRow(cells: [
      DataCell(Text("总")),
      DataCell(Text("${dataTranscript.allMore}")),
      DataCell(Text("${dataTranscript.allLess}")),
      DataCell(Text("${dataTranscript.allRetro}")),
      DataCell(Text("${dataTranscript.allRepl}"))
    ]));

    

    for (int i = 0; i < dataTranscript.totTotalScore!.length; ++i) {
      scores.add(DataRow(cells: [
      DataCell(Center(
          child: Text(
              style: TextStyle(fontSize: 12),
              maxLines: 5,
              "${i + 1}.${dataTranscript.totTotalScore![i].name}(${dataTranscript.totTotalScore![i].score!.toStringAsFixed(2)})"))),
      DataCell(Text("${dataTranscript.totTotalScore![i].score!.toStringAsFixed(2)}")),
      DataCell(Text("${dataTranscript.totToneScore![i].score!.toStringAsFixed(2)}")),
      DataCell(Text("${dataTranscript.totPhoneScore![i].score!.toStringAsFixed(2)}")),
      DataCell(Text("${dataTranscript.totFluencyScore![i].score!.toStringAsFixed(2)}")),
    ]));
    }

for (int i = 0; i < dataTranscript.totTotalScore!.length; ++i) {
      mlpp.add(DataRow(cells: [
      DataCell(Center(
          child: Text(
              style: TextStyle(fontSize: 12),
              maxLines: 5,
              "${i + 1}.${dataTranscript.totTotalScore![i].name}"))),
      DataCell(Text("${dataTranscript.totMore![i].num!}")),
      DataCell(Text("${dataTranscript.totLess![i].num!}")),
      DataCell(Text("${dataTranscript.totRetro![i].num!}")),
      DataCell(Text("${dataTranscript.totRepl![i].num!}")),
    ]));
    }
    
    List<DataRow> shengMuList = List.empty(growable: true);
    for (var x in dataTranscript.wrongShengMu!) {
      shengMuList.add(DataRow(
          cells: [DataCell(Text(x.name!)), DataCell(Text(x.num.toString()))]));
    }
    List<DataRow> yunMuList = List.empty(growable: true);
    for (var x in dataTranscript.wrongYunMu!) {
      yunMuList.add(DataRow(
          cells: [DataCell(Text(x.name!)), DataCell(Text(x.num.toString()))]));
    }
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: ListView(
        children: [
          ComponentSubtitle(label: '全面测试结果', style: gTitleStyle),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Center(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey.shade300),
                        border: TableBorder.all(),
                        columns: [
                          DataColumn(label: Text("题型", style: gInfoTextStyle2)),
                          DataColumn(label: Text("总分", style: gInfoTextStyle2)),
                          DataColumn(
                              label: Text("声调得分", style: gInfoTextStyle2)),
                          DataColumn(
                              label: Text("发音得分", style: gInfoTextStyle2)),
                          DataColumn(
                              label: Text("流畅得分", style: gInfoTextStyle2)),
                        ],
                        rows: scores)),
              )),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.shade300),
                      border: TableBorder.all(),
                      columns: [
                        DataColumn(label: Text("题型", style: gInfoTextStyle2)),
                        DataColumn(label: Text("增读", style: gInfoTextStyle2)),
                        DataColumn(label: Text("漏读", style: gInfoTextStyle2)),
                        DataColumn(label: Text("回读", style: gInfoTextStyle2)),
                        DataColumn(label: Text("替换", style: gInfoTextStyle2)),
                      ],
                      rows: mlpp),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Container(
                height: 150,
                child: ListView(
                  children: [
                    DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey.shade300),
                        border: TableBorder.all(),
                        columns: [
                          DataColumn(
                              label: Text("声母错误", style: gInfoTextStyle2)),
                          DataColumn(label: Text("次数", style: gInfoTextStyle2))
                        ],
                        rows: shengMuList)
                  ],
                ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Container(
                height: 150,
                child: ListView(
                  children: [
                    DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey.shade300),
                        border: TableBorder.all(),
                        columns: [
                          DataColumn(
                              label: Text("韵母错误", style: gInfoTextStyle2)),
                          DataColumn(label: Text("次数", style: gInfoTextStyle2))
                        ],
                        rows: yunMuList)
                  ],
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _generateScaffoldBodyXf(dataTranscript),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: ComponentRoundButton(
          func: () {
            Navigator.pop(context);
          },
          color: gColorE3EDF7RGBA,
          child: ComponentTitle(label: '结束', style: gTitleStyle),
          height: 64,
          width: 200,
          radius: 6,
        ),
      ),
    );
  }
}
