import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VCommon/DataAllResultsCard.dart';
import 'package:project_soe/VMistakeBook/DataMistakeBook.dart';
import 'package:project_soe/VExam/ViewExamResults.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/VMistakeBook/ViewMistakeCard.dart';
import 'package:project_soe/s_o_e_icons_icons.dart';
import 'package:http/http.dart' as http;

import 'package:element_ui/animations.dart';
import 'package:element_ui/widgets.dart';

List<SubCpsrcds> dataQuestionPageList = [];

class ViewMistakeDetail extends StatefulWidget {
  const ViewMistakeDetail({super.key});
  static String routeName = 'mistakeDetail';
  @override
  State<ViewMistakeDetail> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ViewMistakeDetail> {
  @override
  void initState() {
    super.initState();
  }

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

  Widget _buildImpl(BuildContext context, List<SubCpsrcds> listSubCpsrcds) {

    final itemBuilder = (context, index) {
      // null, return 
      if(dataQuestionPageList.length == 0) return Container();
      return _buildItem(dataQuestionPageList[index]);
    };


    return EPageView(
      itemBuilder: itemBuilder,
      itemCount: listSubCpsrcds.length,
    );
  }

  Widget _buildItem(SubCpsrcds dataQuestionPageMain) {
    return ViewMistakeCard(dataQuestionPageMain: dataQuestionPageMain);
  }

  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<int>;
    int oneWeekKey = args[0];
    int mistakeTypeCode = args[1];
    return FutureBuilder<List<SubCpsrcds>>(
      future: postGetDataMistakeDetail(mistakeTypeCode, oneWeekKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for(var index = 0; index < snapshot.data!.length; ++ index) {
            dataQuestionPageList.add(snapshot.data![index]);
          }
          print("postGetDataMistakeDetail succeeded");
          return Scaffold(
            backgroundColor: gColorE3EDF7RGBA,
            appBar: ComponentAppBar(
              title: ComponentTitle(label: "错题详情", style: gTitleStyle),
              hasBackButton: true,
            ),
            body: _buildImpl(context, snapshot.data!),
            // bottomNavigationBar: ComponentBottomNavigator(
            //     curRouteName: ViewMistakeDetail.routeName),
          );
        } else {
          print("postGetDataMistakeDetail failed");
          return Scaffold(
            backgroundColor: gColorE3EDF7RGBA,
            appBar: ComponentAppBar(
              title: ComponentTitle(label: "错题详情", style: gTitleStyle),
              hasBackButton: true,
            ),
            body: CircularProgressIndicator(),
            bottomNavigationBar: ComponentBottomNavigator(
                curRouteName: ViewMistakeDetail.routeName),
          );
        }
      },
    );
  }
}
