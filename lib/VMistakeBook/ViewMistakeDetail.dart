import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VMistakeBook/DataMistakeBook.dart';

class ViewMistakeDetail extends StatelessWidget {
  static String routeName = 'mistakeDetail';
  ViewMistakeDetail();
  Widget _buildImpl(BuildContext context, DataMistakeDetail mistakeDetail) {
    List<Widget> children = List.empty(growable: true);
    for (final detailItem in mistakeDetail.listMistakeDetail) {
      children.add(_buildItem(detailItem));
    }
    return ListView(
      children: children,
    );
  }

  Widget _buildItem(DataMistakeDetailListItem listItem) {
    return 
    Container(
      height: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ComponentTitle(
              label: '题目ID:${listItem.cpsrcdId}', style: gInfoTextStyle0),
          ComponentTitle(
              label: '难度:${listItem.difficulty} ', style: gInfoTextStyle0),
          ComponentTitle(
              label: '分数:${listItem.wordWeight} ', style: gInfoTextStyle0),
          ComponentTitle(
              label: '拼音:${listItem.pinyin} ', style: gInfoTextStyle0),
          ComponentTitle(
              label: '原文:${listItem.refText} ', style: gInfoTextStyle0),
          ComponentTitle(
              label: '音频:${listItem.audioUrl}', style: gInfoTextStyle0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ComponentRoundButton(
                func: () {
                  // TODO-23-8-13 进入答题界面
                  // 语音输入答题参考 ComponentVoiceInput
                  // ViewExam, ViewPractice
                  // 1. 复用ViewExam如何ComponentVoiceInput, Data(Msg)Question
                  // 2. 参考ViewPractice如何开启答题界面, 如何和返回参数
                },
                color: gColorE3EDF7RGBA,
                child: ComponentTitle(
                  label: '点击答题',
                  style: gInfoTextStyle0,
                ),
                height: 25,
                width: 25,
                radius: 3,
              ),
            ],
          ),
          Divider(
            thickness: 2.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<int>;
    int oneWeekKey = args[0];
    int mistakeTypeCode = args[1];
    return FutureBuilder<DataMistakeDetail>(
      future: postGetDataMistakeDetail(mistakeTypeCode, oneWeekKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("postGetDataMistakeDetail succeeded");
          return Scaffold(
            backgroundColor: gColorE3EDF7RGBA,
            appBar: ComponentAppBar(
              title: ComponentTitle(label: "错题详情", style: gTitleStyle),
              hasBackButton: true,
            ),
            body: _buildImpl(context, snapshot.data!),
            // bottomNavigationBar: ComponentBottomNavigator(
            //     curRouteName: ViewMistakeDetail.routeName),
          );
        } else {
          print("postGetDataMistakeDetail failed");
          return Scaffold(
            backgroundColor: gColorE3EDF7RGBA,
            appBar: ComponentAppBar(
              title: ComponentTitle(label: "错题详情", style: gTitleStyle),
              hasBackButton: true,
            ),
            body: CircularProgressIndicator(),
            bottomNavigationBar: ComponentBottomNavigator(
                curRouteName: ViewMistakeDetail.routeName),
          );
        }
      },
    );
  }
}
