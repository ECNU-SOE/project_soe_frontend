import 'package:flutter/material.dart';

import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/src/VClassPage/DataClass.dart';
import 'package:project_soe/src/VExam/DataQuestion.dart';
import 'package:project_soe/src/VExam/ViewExam.dart';

class ViewClassDetail extends StatelessWidget {
  ViewClassDetail({super.key});
  static const String routeName = 'classDetail';

  List<Widget> _buildHomeworkBlock(
      BuildContext context, DataHomeworkInfo homeWorkInfo) {
    return [
      Container(
        child: ComponentSubtitle(
          label: homeWorkInfo.title,
          style: gSubtitleStyle,
        ),
      ),
      Container(
        child: Text(
          homeWorkInfo.desc,
          style: gInfoTextStyle,
        ),
      ),
      Container(
        child: Text(
          '开始时间${homeWorkInfo.startTime.toString()}',
          style: gInfoTextStyle,
        ),
      ),
      Container(
        child: Text(
          '结束时间${homeWorkInfo.endTime.toString()}',
          style: gInfoTextStyle,
        ),
      ),
      TextButton(
          onPressed: () {
            Navigator.pushNamed(context, ViewExam.routeName,
                arguments: ArgsViewExam(
                    homeWorkInfo.cpsgrpId, '作业', ViewClassDetail.routeName));
          },
          child: Text(
            '进入作业',
            style: gInfoTextStyle,
          )),
    ];
  }

  Widget _buildViewClassDetailImpl(
      BuildContext context, List<DataHomeworkInfo> homeworkList) {
    List<Widget> children = List.empty(growable: true);
    children.add(ComponentSubtitle(
      label: '作业列表',
      style: gSubtitleStyle,
    ));
    if (homeworkList.isEmpty) {
      return Scaffold(
        body: ListView(
          children: [
            ComponentSubtitle(
              label: '暂无作业',
              style: gSubtitleStyle,
            )
          ],
        ),
      );
    }
    for (DataHomeworkInfo homeworkInfo in homeworkList) {
      children.addAll(_buildHomeworkBlock(context, homeworkInfo));
    }
    return Scaffold(
      body: ListView(children: children),
      backgroundColor: gColorE3EDF7RGBA,
    );
  }

  @override
  Widget build(BuildContext context) {
    String classId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder<List<DataHomeworkInfo>>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildViewClassDetailImpl(context, snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: postGetHomeworkInfoList(classId),
    );
  }
}
