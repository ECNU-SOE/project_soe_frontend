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
  static const String routeName = 'mistake';
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
  Widget _buildItem(
          BuildContext context, DataMistakeBookListItem mistakeItem) =>
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Container(
          alignment: Alignment.center,
          height: 80,
          decoration: new BoxDecoration(
            color: gColorE3EDF7RGBA,
            // borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Scaffold(
            backgroundColor: gColorE3EDF7RGBA,
            appBar: AppBar(
              toolbarHeight: 25,
              elevation: 6.0,
              shape: ContinuousRectangleBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              backgroundColor: gColorE8F3FBRGBA,
              // backgroundColor: Color.fromARGB(255, 240, 240, 240),
              leading: Text("题目id"),
              actions: [
                ComponentRoundButton(
                  func: () => Navigator.of(context).pushNamed(
                      ViewMistakeDetail.routeName,
                      arguments: <int>[0, mistakeItem.mistakeTypeCode]),
                  color: gColorE8F3FBRGBA,
                  child: Text("查看"),
                  height: 25,
                  width: 70,
                  radius: 0
                ),
              ],
            ),
            // body 修改“错题简略版信息”
            body: Container(color: gColorE8F3FBRGBA, child: Text("错题简略版信息")),
          ),
        ),
      );

  Widget _buildBodyImpl(BuildContext context, DataMistakeBook mistakeBook) {
    List<Widget> wrongList = List.empty(growable: true);
    wrongList.add(Row(children: [
      Text(
        '总错题数：' + mistakeBook.mistakeTotalNumber.toString(),
        style: gSubtitleStyle,
      ),
      Text('顽固错题数：' + mistakeBook.stubbornMistakeNumber.toString(),
          style: gSubtitleStyle),
    ], mainAxisAlignment: MainAxisAlignment.spaceAround));

    for (DataMistakeBookListItem mistakeItem in mistakeBook.listMistakeBook) {
      wrongList.add(_buildItem(context, mistakeItem));
    }

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
          body: Container(
            child: TabBarView(children: <Widget>[
              listView,
              listView,
            ]),
          )),
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
