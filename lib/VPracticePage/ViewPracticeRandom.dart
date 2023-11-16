import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VCommon/DataAllResultsCard.dart';
import 'package:project_soe/VCommon/ViewQuestion.dart';
import 'package:project_soe/VCommon/ViewQuestion_1.dart';
import 'package:project_soe/VMistakeBook/DataMistakeBook.dart';
import 'package:project_soe/VExam/ViewExamResults.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/s_o_e_icons_icons.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:element_ui/animations.dart';
import 'package:element_ui/widgets.dart';

List<int> selectedTagIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

class ViewPracticeRandomCard extends StatefulWidget {
  List<int> tagIds;
  ViewPracticeRandomCard({super.key, required this.tagIds});

  @override
  State<ViewPracticeRandomCard> createState() => _ViewPracticeRandomCardState();
}

class _ViewPracticeRandomCardState extends State<ViewPracticeRandomCard> {
  ComponentVoiceInput? _inputPage;

  Widget _buildBodyImpl(BuildContext context, SubCpsrcds subCpsrcds) {
    _inputPage = ComponentVoiceInput(
        dataPage: subCpsrcds,
        wrongsShow: false,
        add2Mis: true,
        subButShow: true);

    return Scaffold(
      backgroundColor: gColorE3EDF7RGBA,
      appBar: ComponentAppBar(
        title: ComponentTitle(label: "随机练习", style: gTitleStyle),
        hasBackButton: true,
      ),
      body: _inputPage,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPracticeRandomCard(
                        tagIds: selectedTagIds,
                      )
                  ));
        },
        child: Text("下一题"),
        foregroundColor: Colors.black,
        backgroundColor: gColorE8F3FBRGBA,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      bottomNavigationBar:
          ComponentBottomNavigator(curRouteName: ViewPracticeRandom.routeName),
    );
  }

  @override
  Widget build(BuildContext buildContext) => FutureBuilder<SubCpsrcds>(
        future: getGetRandomDataMistakeDetail(widget.tagIds), // 获取随机一题接口,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("getGetRandomDataMistakeDetail succeeded !!!");
            return _buildBodyImpl(context, snapshot.data!);
          } else {
            print("getGetRandomDataMistakeDetail failed !!!");
            return Scaffold(
                      backgroundColor: gColorE3EDF7RGBA,
              appBar: ComponentAppBar(
                title: ComponentTitle(label: "随机练习", style: gTitleStyle),
                hasBackButton: true,
              ),
              body: Container(
                child: const Center(
              child: CircularProgressIndicator(),
            )
                
                // Column(
                //   children: [
                //     Padding(
                //         padding: EdgeInsets.only(top: 20),
                //         child: Center(
                //           child: Text(
                //             "无该标签的题目或未添加标签",
                //             style: TextStyle(fontSize: 20),
                //             softWrap: true,
                //           ),
                //         ))
                //   ],
                // ),
              ),
            );
          }
        },
      );
}

class ViewPracticeRandom extends StatefulWidget {
  static String routeName = 'practiceRandom';
  ViewPracticeRandom({super.key});

  @override
  State<ViewPracticeRandom> createState() => _ViewPracticeRandomState();
}

class _ViewPracticeRandomState extends State<ViewPracticeRandom> {
  Widget _buildBodyImpl(BuildContext context, TagList tagList) {
      List<int> tagIds = [2, 5];
      // for (var tag in tagList.records) {
      //   tagIds.add(tag.id ?? 0);
      // }
      return ViewPracticeRandomCard(tagIds: tagIds);
  }

  @override
  Widget build(BuildContext buildContext) => FutureBuilder<TagList>(
        future: getAllTagList(), // taglist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("getAllTagList succeeded !!!");
            return _buildBodyImpl(context, snapshot.data!);
          } else {
            print("getAllTagList failed !!!");
            return CircularProgressIndicator();
          }
        },
      );
}
