import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VShowAllQuestion/ViewAllQuestion.dart';

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

  void initState() {
    super.initState();
    type = "";
    refText = "";
    tagIds = [];
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
                      )
                    ])),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: TextButton(
                    child: Text("开始预览"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAllQuestion(
                                type: type,
                                refText: refText,
                                tagIds: tagIds,
                                  )
                              ));
                    },
                  ),
                )
              ],
            )));
  }
}
