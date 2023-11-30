import 'dart:async';
import 'dart:convert';

import 'package:element_ui/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VExam/DataQuestion.dart';

import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/VShowAllQuestion/DataAllQuestion.dart';

List<SubCpsrcds> dataQuestionPageList = [];

class ViewAllQuestion extends StatefulWidget {
  String type = "";
  String refText = "";
  List<int> tagIds = [];
  int idx = 1;
  ViewAllQuestion({required this.type, required this.refText, required this.tagIds, required this.idx});
  @override
  State<ViewAllQuestion> createState() => _ViewAllQuestionState();
}

class _ViewAllQuestionState extends State<ViewAllQuestion> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildImpl(BuildContext context, List<SubCpsrcds> listSubCpsrcds, int idx) {
    final itemBuilder = (context, index) {
      print(index);
      if(dataQuestionPageList.length == 0) return Container();
      return _buildItem(dataQuestionPageList[index]);
    };


    return EPageView(
      initialPage: idx,
      itemBuilder: itemBuilder,
      itemCount: listSubCpsrcds.length,
    );
  }

  Widget _buildItem(SubCpsrcds dataQuestionPageMain) {
    return ComponentVoiceInput(dataPage: dataQuestionPageMain, recordShow: false, subButShow: true);
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<SubCpsrcds>>(
      future: getAllQuestions(widget.type, widget.refText, widget.tagIds),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dataQuestionPageList.clear();
          for(var index = 0; index < snapshot.data!.length; ++ index) {
            dataQuestionPageList.add(snapshot.data![index]);
          }
          print("getAllQuestions succeeded");
          print(widget.idx);
          print("---------");
          // todo
          return Scaffold(
            backgroundColor: gColorE3EDF7RGBA,
            appBar: ComponentAppBar(
              title: ComponentTitle(label: "预览题目", style: gTitleStyle),
              hasBackButton: true,
            ),
            body: _buildImpl(context, snapshot.data!, widget.idx),
          );
        } else {
          print("getAllQuestions failed");
          return CircularProgressIndicator();
        }
      },
    );
  }
}
