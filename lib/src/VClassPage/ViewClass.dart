import 'package:flutter/material.dart';

import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/CComponents/Componentsubtitle.dart';

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

// FIXME 22.12.7 temp
List<ClassRecData> classRecDatasFirst = [
  ClassRecData('面板1', Icons.book, null),
  ClassRecData('面板2', Icons.book, null),
  ClassRecData('面板3', Icons.book, null),
];
List<ClassRecData> classRecDatasSecond = [
  ClassRecData('面板4', Icons.book, null),
  ClassRecData('面板5', Icons.book, null),
  ClassRecData('面板6', Icons.book, null),
];

class ClassPage extends StatelessWidget {
  const ClassPage({super.key});
  static const String routeName = 'class';

  // List<Widget> _buildHorizontalScrollWidgetList() {
  //   return horizontalScrollDatas
  //       .map(
  //         (data) => Container(
  //           width: 240.0,
  //           color: data.color,
  //           child: Center(
  //             child: Text(data.label, style: gClassPageAdsStyle),
  //           ),
  //         ),
  //       )
  //       .toList();
  // }

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

  // FIXME
  Widget _buildMyClassWidget() {
    return Row();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          // const Subtitle(label: '(.*)'),
          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 10.0),
          //   height: 160.0,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: _buildHorizontalScrollWidgetList(),
          //   ),
          // ),
          const Subtitle(label: '快速入口'),
          _buildClassRecWidget(classRecDatasFirst),
          _buildClassRecWidget(classRecDatasSecond),
          const Subtitle(label: '我的课堂'),
          _buildMyClassWidget(),
        ],
      ),
    );
  }
}
