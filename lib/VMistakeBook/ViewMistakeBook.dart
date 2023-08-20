import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VMistakeBook/DataMistakeBook.dart';
import 'package:project_soe/VMistakeBook/ViewMistakeDetail.dart';

// import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
          height: 60,
          decoration: new BoxDecoration(
            color: gColorE3EDF7RGBA,
          ),
          child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ComponentSubtitle(label: mistakeItem.mistakeTypeName, style: gSubtitleStyle0)                    
                  ],
                ),
                ComponentRoundButton(
                          func: () => Navigator.of(context).pushNamed(
                              ViewMistakeDetail.routeName,
                              arguments: <int>[0, mistakeItem.mistakeTypeCode]),
                          color: gColorE8F3FBRGBA,
                          child: Text("查看"),
                          height: 25,
                          width: 70,
                          radius: 0)
              ],
            )
          
        ),
      );

  Widget _buildBodyImpl(BuildContext context, DataMistakeBook mistakeBook) {
    List<Widget> wrongList = List.empty(growable: true);
    final listMistakeBook = mistakeBook.listMistakeBook;
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
