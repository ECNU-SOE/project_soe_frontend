import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VMistakeBook/DataMistakeBook.dart';
import 'package:project_soe/VMistakeBook/ViewMistakeDetail.dart';

class ViewMistakeBook extends StatelessWidget {
  // 静态常量字符串 routeName 给这个route命名, 这个名字是该View独有的, 要在全局的navigator里使用
  static const String routeName = 'mistake';
  // 实现其buildfunc
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ViewMistakeBookBody(),
      backgroundColor: gColorE3EDF7RGBA,
      bottomNavigationBar: ComponentBottomNavigator(
        curRouteName: routeName,
      ),
      appBar: ComponentAppBar(
        hasBackButton: true,
        title: ComponentTitle(
          label: '错题本',
          style: gTitleStyle,
        ),
      ),
    );
  }
}

class _ViewMistakeBookBody extends StatelessWidget {
  // 单个错题的模板，需要重新更改
  Widget _buildItem(BuildContext context, DataMistakeBookListItem mistakeItem) =>
      ListTile(
        leading: Text(mistakeItem.mistakeTypeName, style: gTitleStyle),
        title: ComponentCircleButton(
          func: () => Navigator.of(context).pushNamed(
              ViewMistakeDetail.routeName,
              arguments: <int>[0, mistakeItem.mistakeTypeCode]),
          color: gColor6E81A0RGBA,
          child: ComponentSubtitle(label: '查询一周', style: gSubtitleStyle),
          size: 25,
        ),
        trailing: ComponentCircleButton(
          func: () => Navigator.of(context).pushNamed(
              ViewMistakeDetail.routeName,
              arguments: <int>[1, mistakeItem.mistakeTypeCode]),
          color: gColor6E81A0RGBA,
          child: ComponentSubtitle(label: '查询全部', style: gSubtitleStyle),
          size: 25,
        ),
      );

  Widget _buildBodyImpl(BuildContext context, DataMistakeBook mistakeBook) {
    List<Widget> wrongList = List.empty(growable: true);
    for (DataMistakeBookListItem mistakeItem in mistakeBook.listMistakeBook) {
      wrongList.add(_buildItem(context, mistakeItem));
    }
    // 可能需要更改成滚轮
    final listView = ListView(
      children: wrongList,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: gColorE8F3FBRGBA,
          appBar: TabBar(
            labelColor: gColor6E81A0RGBA,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black54,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 1.0,
            tabs: <Widget>[Tab(text: '查询一周'), Tab(text: '查询全部')],
          ),
          // 单题模板修改后，将对应的listview放入下面body中
          body: TabBarView(children: <Widget>[
            Text("一周错题"),
            listView,
          ])),
    );
  }

  @override
  Widget build(BuildContext buildContext) => FutureBuilder<DataMistakeBook>(
        future: getGetDataMistakeBook(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildBodyImpl(context, snapshot.data!);
          } else {
            return CircularProgressIndicator();
          }
        },
      );
}
