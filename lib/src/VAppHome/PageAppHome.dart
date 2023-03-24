import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:project_soe/src/GGlobalParams/styles.dart';
import 'package:project_soe/src/VNativeLanguageChoice/ViewNativeLanguageChoice.dart';
import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';

// FIXME 22.12.7 temp
List<String> horizontalScrollImages = [
  'https://www.ecnu.edu.cn/__local/7/E4/99/C2BFA77AF634A4BE23A589FA770_FB066FB1_1913D.jpg',
  'https://static.hd1080.pro/wp-content/uploads/2021/09/20210923091955364.jpg',
];

// FIXME 22.12.7 temp
class HomeRecData {
  String label;
  IconData icon;
  Function()? onPressed;
  HomeRecData(this.label, this.icon, this.onPressed);
}

// FIXME 22.12.7 temp
List<HomeRecData> homeRecDatasFirst = [
  HomeRecData('快速入口1', Icons.book, null),
  HomeRecData('快速入口2', Icons.book, null),
  HomeRecData('快速入口3', Icons.book, null),
];
List<HomeRecData> homeRecDatasSecond = [
  HomeRecData('快速入口4', Icons.book, null),
  HomeRecData('快速入口5', Icons.book, null),
  HomeRecData('快速入口6', Icons.book, null),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routeName = 'home';

  List<Widget> _buildHorizontalScrollWidget() {
    return horizontalScrollImages
        .map(
          (uri) => Container(
            height: 140.0,
            width: 200.0,
            child: Center(
              child: Image.network(
                uri,
                fit: BoxFit.fitHeight,
              ),
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
                  style: gHomePageListitemStyle,
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildFullExamEntranceWidget(BuildContext context) {
    return Container(
      height: 48.0,
      width: 120.0,
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book),
            Text(
              '进入评测',
              style: gSubtitleStyle,
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context)
              .pushReplacementNamed(NativeLanguageChoice.routeName);
        },
        style: gHomePageExamEntranceButtonStyle,
      ),
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
          const Subtitle(label: '初次使用，体验全面评测。'),
          _buildFullExamEntranceWidget(context),
          // _buildSubtitle('推荐内容'),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            height: 160.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _buildHorizontalScrollWidget(),
            ),
          ),
          const Subtitle(label: '快速入口'),
          _buildRecWidget(homeRecDatasFirst),
          _buildRecWidget(homeRecDatasSecond),
          const Subtitle(label: '练习'),
          _buildExerciseWidget(),
        ],
      ),
    );
  }
}
