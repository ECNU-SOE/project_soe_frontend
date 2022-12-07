import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_soe/src/data/styles.dart';

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
    '滚动广告1',
    Colors.red,
  ),
  HorizontalScrollData(
    '滚动广告1',
    Colors.blue,
  ),
  HorizontalScrollData(
    '滚动广告1',
    Colors.yellow,
  ),
];

// FIXME 22.12.7 temp
class HomeRecData {
  String label;
  IconData icon;
  Function()? onPressed;
  HomeRecData(this.label, this.icon, this.onPressed);
}

// FIXME 22.12.7 temp
List<HomeRecData> classRecDatasFirst = [
  HomeRecData('快速入口1', Icons.book, null),
  HomeRecData('快速入口2', Icons.book, null),
  HomeRecData('快速入口3', Icons.book, null),
];
List<HomeRecData> classRecDatasSecond = [
  HomeRecData('快速入口4', Icons.book, null),
  HomeRecData('快速入口5', Icons.book, null),
  HomeRecData('快速入口6', Icons.book, null),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routeName = 'home';

  List<Widget> _buildHorizontalScrollWidget() {
    return horizontalScrollDatas
        .map(
          (data) => Container(
            width: 240.0,
            color: data.color,
            child: Center(
              child: Text(data.label, style: gClassPageAdsStyle),
            ),
          ),
        )
        .toList();
  }

  Widget _buildRecWidget(List<HomeRecData> datalist) {
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

  Widget _buildSubtitle(String label) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            label,
            style: gClassPageSubTitleStyle,
          ),
        ),
      ],
    );
  }

  // FIXME
  Widget _buildExerciseWidget() {
    return Row();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          _buildSubtitle('推荐内容'),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            height: 160.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _buildHorizontalScrollWidget(),
            ),
          ),
          _buildSubtitle('快速入口'),
          _buildRecWidget(classRecDatasFirst),
          _buildRecWidget(classRecDatasSecond),
          _buildSubtitle('练习'),
          _buildExerciseWidget(),
        ],
      ),
    );
  }
}
