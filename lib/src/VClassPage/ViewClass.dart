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
          const Subtitle(label: '快速入口'),
          const Subtitle(label: '我的课堂'),
          _buildMyClassWidget(),
        ],
      ),
    );
  }
}
