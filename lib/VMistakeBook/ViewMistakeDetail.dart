import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VMistakeBook/DataMistakeBook.dart';
import 'package:project_soe/VExam/ViewExamResults.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/VMistakeBook/ViewMistakeCard.dart';
import 'package:project_soe/s_o_e_icons_icons.dart';
import 'package:http/http.dart' as http;

import 'package:element_ui/animations.dart';
import 'package:element_ui/widgets.dart';

List<DataQuestionPageMain> dataQuestionPageList = [];

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

    var dataQuestion = new DataQuestion(
      wordWeight: data['wordWeight'],
      id: data['id'],
      label: data['refText'],
      cpsgrpId: data['cpsgrpId'],
      topicId: data['topicId'],
      evalMode: data['evalMode'],);

    var dataQuestionPage = new DataQuestionPageMain(
      evalMode: data['evalMode'],
      id: data['id'],
      dataQuestion: dataQuestion,
      cnum: data['cNum'],
      tnum: 1,
      cpsgrpId: data['cpsgrpId'],
      weight: data['wordWeight'] == null? 0: data['wordWeight'],
      title: '字词训练', // 题目上面标题
      desc: '字词训练', // 题目里面标题
      audioUri: data['audioUrl'],
    );

    dataQuestionPageList.add(dataQuestionPage);
  }


  Widget _buildImpl(BuildContext context, DataMistakeDetail mistakeDetail) {

    final itemBuilder = (context, index) {
      // null, return 
      if(dataQuestionPageList.length == 0) return Container();
      return _buildItem(dataQuestionPageList[index]);
    };


    return EPageView(
      itemBuilder: itemBuilder,
      itemCount: mistakeDetail.listMistakeDetail.length,
    );
  }

  Widget _buildItem(DataQuestionPageMain dataQuestionPageMain) {
    return ViewMistakeCard(dataQuestionPageMain: dataQuestionPageMain);
  }

  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<int>;
    int oneWeekKey = args[0];
    int mistakeTypeCode = args[1];
    return FutureBuilder<DataMistakeDetail>(
      future: postGetDataMistakeDetail(mistakeTypeCode, oneWeekKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for(var index = 0; index < snapshot.data!.listMistakeDetail.length; ++ index) {
            getGetCpsrcdDetail(snapshot.data!.listMistakeDetail[index].cpsrcdId, index);
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
