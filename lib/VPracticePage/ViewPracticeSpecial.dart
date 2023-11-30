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

dynamic test, aList, tagList;
List<String> tagNames = [];
List<int> selectedTagIds = [];
Map vis = {};
Map tagMap = {};
List<String> showTagList = List.empty(growable: true);

class ViewPracticeSpecialCard extends StatefulWidget {
  List<int> tagIds;
  ViewPracticeSpecialCard({super.key, required this.tagIds});

  @override
  State<ViewPracticeSpecialCard> createState() => _ViewPracticeSpecialCardState();
}

class _ViewPracticeSpecialCardState extends State<ViewPracticeSpecialCard> {
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
        title: ComponentTitle(label: "专项训练", style: gTitleStyle),
        hasBackButton: true,
      ),
      body: _inputPage,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPracticeSpecialCard(
                        tagIds: selectedTagIds,
                      )
                  ));
        },
        child: Text("下一题"),
        foregroundColor: Colors.black,
        backgroundColor: gColorE8F3FBRGBA,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
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
              body: Container(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(
                            "无该标签的题目或未添加标签",
                            style: TextStyle(fontSize: 20),
                            softWrap: true,
                          ),
                        ))
                  ],
                ),
              ),
            );
          }
        },
      );
}

class ViewPracticeSpecial extends StatefulWidget {
  static String routeName = 'practiceSpecial';
  ViewPracticeSpecial({super.key});

  @override
  State<ViewPracticeSpecial> createState() => _ViewPracticeSpecialState();
}

class _ViewPracticeSpecialState extends State<ViewPracticeSpecial> {
  Widget _buildBodyImpl(BuildContext context, TagList tagList) {
    tagNames.clear();
    List<Tags> tagslist = tagList.records;
    // tagNames.clear(); vis.clear(); tagMap.clear();
    for (var tag in tagslist) {
      tagMap[tag.id] = tag.name;
      tagMap[tag.name] = tag.id;
      if ((tag.name ?? "") != "") {
        tagNames.add(tag.name!);
      }
    }
    double screenWidth = 500;
    return Scaffold(
        backgroundColor: gColorE3EDF7RGBA,
        appBar: ComponentAppBar(
          title: ComponentTitle(label: "专项训练", style: gTitleStyle),
          hasBackButton: true,
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0),
            child: Column(children: [
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                screenWidth = constraints.maxWidth;
                return Container();
              }),
              Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: AutoSizeText(
                      "已选中 " + showTagList.length.toString() + " 个标签：",
                      style: gSubtitleStyle,
                      maxLines: 2)),
              Container(
                height: 100,
                width: screenWidth - 50,
                child: GridView.builder(
                    itemCount: showTagList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //横轴元素个数
                        crossAxisCount: 5, //纵轴间距
                        mainAxisSpacing: 20.0, //横轴间距
                        crossAxisSpacing: 10, //子组件宽高长度比例
                        childAspectRatio: 1.0),
                    itemBuilder: (BuildContext context, int index) {
                      return TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 161, 193, 219))),
                          onPressed: () {
                            setState(() {
                              vis[tagMap[showTagList[index]]] = 0;
                              showTagList.clear();
                              selectedTagIds.clear();
                              for (var id in vis.keys) {
                                if (vis[id] == 1) {
                                  showTagList.add(tagMap[id]);
                                  selectedTagIds.add(id);
                                }
                              }
                            });
                          },
                          child: AutoSizeText(showTagList[index],
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SourceSans',
                                fontSize: 12.0,
                              ),
                              maxLines: 2));
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        vis.clear();
                        showTagList.clear();
                        selectedTagIds.clear();
                      });
                    },
                    child: Text(
                      "清除标签",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              Container(
                  color: Colors.white,
                  width: screenWidth,
                  height: 300,
                  child: GridView.builder(
                      itemCount: tagNames.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //横轴元素个数
                          crossAxisCount: 5, //纵轴间距
                          mainAxisSpacing: 20.0, //横轴间距
                          crossAxisSpacing: 10.0, //子组件宽高长度比例
                          childAspectRatio: 1.0),
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                            onPressed: () {
                              setState(() {
                                if (vis[tagMap[tagNames[index]]] == 1)
                                  vis[tagMap[tagNames[index]]] = 0;
                                else
                                  vis[tagMap[tagNames[index]]] = 1;
                                print(tagMap[tagNames[index]]);
                                print(tagNames[index]);
                                showTagList.clear();
                                selectedTagIds.clear();
                                for (var id in vis.keys) {
                                  if (vis[id] == 1) {
                                    showTagList.add(tagMap[id]);

                                    selectedTagIds.add(id);
                                  }
                                }
                              });
                            },
                            child: vis[tagMap[tagNames[index]]] != 1
                                ? AutoSizeText(tagNames[index],
                                    style: gSubtitleStyle,
                                    maxLines: 2,
                                    softWrap: true)
                                : AutoSizeText(
                                    tagNames[index] + "(已选择)",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'SourceSerif',
                                      fontSize: 18.0,
                                    ),
                                    maxLines: 2,
                                    softWrap: true,
                                  ));
                      })),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // 参数：pageTitle
                          builder: (context) => ViewPracticeSpecialCard(
                                tagIds: selectedTagIds,
                              )
                          // 调用 then 等待接收 SecondPage 返回的数据
                          ));
                },
                child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "开始专项训练",
                      style: TextStyle(fontSize: 18),
                    )),
              )
            ])));
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
