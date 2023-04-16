import 'package:flutter/material.dart';

import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/CComponents/Componentsubtitle.dart';
import 'package:project_soe/src/VClassPage/DataClass.dart';
import 'package:project_soe/src/VClassPage/ViewClassDetail.dart';

// FIXME 22.12.7 temp
class HorizontalScrollData {
  String label;
  Color color;
  HorizontalScrollData(
    this.label,
    this.color,
  );
}

// FIXME 22.12.7 temp
List<HorizontalScrollData> horizontalScrollDatas = [
  HorizontalScrollData(
    '推荐内容1',
    Colors.red,
  ),
  HorizontalScrollData(
    '推荐内容2',
    Colors.blue,
  ),
  HorizontalScrollData(
    '推荐内容3',
    Colors.yellow,
  ),
];

// FIXME 22.12.7 temp
class ClassRecData {
  String label;
  IconData icon;
  Function()? onPressed;
  ClassRecData(this.label, this.icon, this.onPressed);
}

class ClassPage extends StatelessWidget {
  const ClassPage({super.key});
  static const String routeName = 'class';

  Widget _buildClassRecWidget(List<ClassRecData> datalist) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: datalist
          .map(
            (data) => Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(18.0),
                    child: IconButton(
                      icon: Icon(
                        data.icon,
                        color: Colors.black87,
                      ),
                      onPressed: data.onPressed,
                    )),
                Text(
                  data.label,
                  style: gClassPageListitemStyle,
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  // FIXME 23.4.13 哪个是Id?
  TextButton _buildCourseTextButton(
      BuildContext context, DataCourseInfo courseInfo) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, ViewClassDetail.routeName,
              arguments: (courseInfo.classId));
        },
        child: Text(courseInfo.classId, style: gClassPageTextStyle));
  }

  List<Widget> _buildMyClassWidget(
      BuildContext context, DataClassPageInfo classPageInfo) {
    if (classPageInfo.pickedCourses.isEmpty) {
      return [
        Subtitle(label: '你没有选择的课堂'),
      ];
    }
    List<TextButton> buttons = List.empty(growable: true);
    for (final courseInfo in classPageInfo.pickedCourses) {
      buttons.add(_buildCourseTextButton(context, courseInfo));
    }
    return buttons;
  }

  Widget _buildViewClassPageBody(
      BuildContext context, DataClassPageInfo classPageInfo) {
    List<Widget> children = List.empty(growable: true);
    children.addAll([
      const Subtitle(label: '快速入口'),
      const Subtitle(label: '我的课堂'),
    ]);
    children.addAll(_buildMyClassWidget(context, classPageInfo));
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataClassPageInfo>(
      future: postGetDataClassInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildViewClassPageBody(context, snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
