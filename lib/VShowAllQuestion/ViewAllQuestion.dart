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
  const ViewAllQuestion({super.key});
  static String routeName = 'allQuestion';
  @override
  State<ViewAllQuestion> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ViewAllQuestion> {
  @override
  void initState() {
    super.initState();
  }
/*
  getGetCpsrcdDetail(String cpsrcdId, int index) async {
    var url = Uri.parse('http://47.101.58.72:8888/corpus-server/api/cpsrcd/v1/getCpsrcdDetail?cpsrcdId=' + cpsrcdId);
    final token = await AuthritionState.instance.getToken();
    var response = await http.get(
      url,
      headers: {"token": token},
    );
    var data = jsonDecode(Utf8Codec().decode(response.bodyBytes))['data']; 

    List<Tags> tags = List.empty(growable: true);
    data['tags'].forEach((v) {
      tags!.add(new Tags.fromJson(v));
    });
    SubCpsrcds subCpsrcd = new SubCpsrcds(
      id: data['id'] ?? "",
      type: data['type'] ?? "",
      evalMode: data['evalMode'] ?? -1,
      difficulty: data['difficulty'] ?? -1,
      pinyin: data['pinyin'] ?? "",
      refText: data['refText'] ?? "",
      audioUrl: data['audioUrl'] ?? "",
      tags: tags ?? [],
      gmtCreate: data['gmtCreate'] ?? "",
      gmtModified: data['gmtModified'] ?? "",
      enablePinyin: data['enablePinyin'] ?? false,
    );

    dataQuestionPageList.add(subCpsrcd);
  }
*/
  Widget _buildImpl(BuildContext context, List<SubCpsrcds> listSubCpsrcds) {
    final itemBuilder = (context, index) {
      print(index);
      if(dataQuestionPageList.length == 0) return Container();
      return _buildItem(dataQuestionPageList[index]);
    };


    return EPageView(
      itemBuilder: itemBuilder,
      itemCount: listSubCpsrcds.length,
    );
  }

  Widget _buildItem(SubCpsrcds dataQuestionPageMain) {
    return ComponentVoiceInput(dataPage: dataQuestionPageMain, recordShow: false);
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<SubCpsrcds>>(
      future: getAllQuestions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for(var index = 0; index < snapshot.data!.length; ++ index) {
            dataQuestionPageList.add(snapshot.data![index]);
          }
          print("getAllQuestions succeeded");
          return Scaffold(
            backgroundColor: gColorE3EDF7RGBA,
            appBar: ComponentAppBar(
              title: ComponentTitle(label: "预览题目", style: gTitleStyle),
              hasBackButton: true,
            ),
            body: _buildImpl(context, snapshot.data!),
          );
        } else {
          print("getAllQuestions failed");
          return CircularProgressIndicator();
        }
      },
    );
  }
}
