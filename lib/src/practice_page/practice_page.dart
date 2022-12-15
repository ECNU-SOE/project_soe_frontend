import 'package:flutter/material.dart';
import 'package:project_soe/src/components/subtitle.dart';
import 'package:project_soe/src/data/styles.dart';

// FIXME 22.12.4 Temp
List<String> tempTitles = [
  '文章标题1',
  '文章标题2',
  '文章标题3',
  '文章标题4',
  '文章标题5',
  '文章标题6',
];
// FIXME 22.12.4 Temp
List<String> tempTitles1 = [
  '看图说话1',
  '看图说话2',
  '看图说话3',
  '看图说话4',
  '看图说话5',
  '看图说话6',
];
// FIXME 22.12.4 Temp
List<int> tempCount2 = [212, 39, 4];
List<String> tempTitles2 = [
  '声母练习',
  '韵母练习',
  '声调练习',
];
// FIXME 22.12.4 Temp
List<String> tempTitle3 = [
  '专项练习1',
  '专项练习2',
  '专项练习3',
];

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});
  static const String routeName = 'practice';

  Widget _buildSpecificText() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0),
      child: Center(
        child: Wrap(
          children: [
            Center(
              child: Text('您还没有测试结果, 点击进入测试', style: gSubtitleStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('点击进入测试'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDoubleWordListChild0(String title, int count) {
    return Padding(
      padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 8.0, right: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: gPracticePageListitemStyle,
        ),
        trailing: Text('$count个题目', style: gPracticePageListitemStyle),
      ),
    );
  }

  Widget _buildDoubleWordSubtitle(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.0, top: 12.0),
          child: Text(
            title,
            style: gSubtitleStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildDoubleWordRowChild0(String label) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(18.0),
            child: IconButton(
              icon: Icon(
                Icons.text_format_outlined,
                color: Colors.black87,
              ),
              onPressed: () {},
            )),
        Text(
          label,
          style: gPracticePageListitemStyle,
        ),
      ],
    );
  }

  Widget _buildDoubleWordPage() {
    var _listView = ListView(
      children: [
        const Subtitle(label: '声韵调练习'),
        _buildDoubleWordListChild0(tempTitles2[0], tempCount2[0]),
        _buildDoubleWordListChild0(tempTitles2[1], tempCount2[1]),
        _buildDoubleWordListChild0(tempTitles2[2], tempCount2[2]),
        const Subtitle(label: '专项训练'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDoubleWordRowChild0(tempTitle3[0]),
            _buildDoubleWordRowChild0(tempTitle3[1]),
            _buildDoubleWordRowChild0(tempTitle3[2]),
          ],
        ),
        const Subtitle(label: '个性化训练'),
        _buildSpecificText(),
      ],
    );
    return _listView;
  }

  Widget _buildArticlePage() {
    final _listView = ListView.builder(
      itemCount: tempTitles.length,
      itemBuilder: (context, index) => ListTile(
        title: Padding(
          padding: EdgeInsets.all(6.0),
          child: TextButton(
            child: Text(tempTitles[index]),
            style: gPracticePageArticleButtonStyle,
            onPressed: () {
              // FIXME 22.12.4 实现点击函数.
            },
          ),
        ),
      ),
    );
    return _listView;
  }

  Widget _buildSpeakingPage() {
    final _listView = ListView.builder(
      itemCount: tempTitles1.length,
      itemBuilder: (context, index) => ListTile(
        title: Padding(
          padding: EdgeInsets.all(6.0),
          child: TextButton(
            child: Text(tempTitles1[index]),
            style: gPracticePageSpeakingButtonStyle,
            onPressed: () {
              // FIXME 22.12.4 实现点击函数.
            },
          ),
        ),
      ),
    );
    return _listView;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('练习', style: gPracticePageTabStyle)),
              Tab(child: Text('短文阅读', style: gPracticePageTabStyle)),
              Tab(child: Text('看图说话', style: gPracticePageTabStyle))
            ],
          ),
        ),
        body: TabBarView(children: [
          // _buildSingleWordPage(),
          _buildDoubleWordPage(),
          _buildArticlePage(),
          _buildSpeakingPage(),
        ]),
      ),
    );
  }
}
