import 'package:flutter/material.dart';

import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/CComponents/Componentsubtitle.dart';
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
        child: Subtitle(
          label: homeWorkInfo.title,
        ),
      ),
      Container(
        child: Text(
          homeWorkInfo.desc,
          style: gClassPageTextStyle,
        ),
      ),
      Container(
        child: Text(
          '开始时间${homeWorkInfo.startTime.toString()}',
          style: gClassPageTextStyle,
        ),
      ),
      Container(
        child: Text(
          '结束时间${homeWorkInfo.endTime.toString()}',
          style: gClassPageTextStyle,
        ),
      ),
      TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, ViewExam.routeName,
                arguments: ArgsViewExam(
                    homeWorkInfo.cpsgrpId, '作业', ViewClassDetail.routeName));
          },
          child: Text(
            '进入作业',
            style: gClassPageTextStyle,
          )),
    ];
  }

  Widget _buildViewClassDetailImpl(
      BuildContext context, List<DataHomeworkInfo> homeworkList) {
    List<Widget> children = List.empty(growable: true);
    children.add(Subtitle(label: '作业列表'));
    for (DataHomeworkInfo homeworkInfo in homeworkList) {
      children.addAll(_buildHomeworkBlock(context, homeworkInfo));
    }
    return Scaffold(body: ListView(children: children));
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
