import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/VShowAllQuestion/ViewAllQuestion.dart';
import 'package:http/http.dart' as http;

TextEditingController _textController = TextEditingController();

class ViewAllQuestionHome extends StatefulWidget {
  const ViewAllQuestionHome({super.key});
  static String routeName = 'allQuestionHome';
  @override
  State<ViewAllQuestionHome> createState() => _allQuestionHomeState();
}

class _allQuestionHomeState extends State<ViewAllQuestionHome> {
  String type = "";
  String refText = "";
  List<int> tagIds = [];
  bool showQuestions = false;
  List<Widget> questionWidgetList = [];
  int questionNum= 0;

  void initState() {
    super.initState();
    type = "";
    refText = "";
    tagIds = [];
    showQuestions = false;
    questionWidgetList = [];
  }

  getAllQuestionsWidgetList(String refText) async {
    final token = AuthritionState.instance.getToken();
    final uri = Uri.parse(
        'http://47.101.58.72:8888/corpus-server/api/cpsrcd/v1/list?');
    final response = await http.Client().post(
      uri,
      headers: {"token": token, "Content-Type": "application/json"},
      body: jsonEncode({
        "type": null,
        "difficultyBegin": null,
        "difficultyEnd": null,
        "refText": refText,
        "tagIds": null
      }),
    );
    final u8decoded = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(u8decoded);
    final code = decoded['code'];
    final data = decoded['data'];
    final msg = decoded['msg'];
    print("is running");
    if (code != 0) throw ('wrong return code');
    questionWidgetList.clear();
    var records = data['records'];
    setState(() {
      questionNum = records.length;
      int idx = 0;
          for (var record in records) {
            idx ++;
      SubCpsrcds tmp = SubCpsrcds.fromJson(record);
      questionWidgetList.add(Container(
          height: 80,
          child: Column(children: [

          Expanded(
                child: 
                GestureDetector(
          child: Row(children: [
                  Text(
                    "题目文本: ",
                    style: gSubtitleStyle1,
                  ),
                  Text(
                    (tmp.refText ?? "").substring(0, min((tmp.refText ?? "").length, 20)),
                    style: gInfoTextStyle1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,                    
                  )
                ]),
          onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewAllQuestion(
                        type: type,
                        refText: refText,
                        tagIds: tagIds,
                        idx: idx
                          )
                      ));
                              
          },
        )
                ),
            Expanded(
                child: Row(children: [
                  Text("修改时间: ", style: gSubtitleStyle1),
                  Text(
                    tmp.gmtModified ?? "",
                    style: gInfoTextStyle1,
                    softWrap: true,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ]))
          ])));
    }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: gColorE3EDF7RGBA,
        appBar: ComponentAppBar(
          title: ComponentTitle(label: "预览题目", style: gTitleStyle),
          hasBackButton: true,
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Row(children: [
                      Container(
                          width: 120,
                          child: Text(
                            "题目关键词：",
                            style: gSubtitleStyle,
                          )),
                      Container(
                        width: 200,
                        child: TextField(
                            controller: _textController,
                            maxLength: 20,
                            onChanged: (value) {
                              refText = value;
                            },
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                    child: Text("开始预览"),
                    onPressed: () {
                      setState(() {
                        showQuestions = true;
                        questionWidgetList.clear();
                      });
                        getAllQuestionsWidgetList(refText);
                      /*
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAllQuestion(
                                type: type,
                                refText: refText,
                                tagIds: tagIds,
                                  )
                              ));
                              */
                    },
                  )
                    ])),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Text("共查询到 ${questionNum} 道题目！")
                ),
                Container(
                  height: 400,
                  width: 350,
                    child: showQuestions
                        ? 
                        ListView(children: questionWidgetList)
                        : Container())
              ],
            )));
  }
}
