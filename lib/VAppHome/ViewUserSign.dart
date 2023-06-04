import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentShadowedContainer.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VAppHome/DataAppHomePage.dart';
import 'package:project_soe/s_o_e_icons_icons.dart';

class ViewUserSign extends StatefulWidget {
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  @override
  State<StatefulWidget> createState() => _ViewUserSignState();
}

class _ViewUserSignState extends State<ViewUserSign> {
  Widget _buildIconTxt(bool hasIcon, String txt, bool thisMonth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Center(
        child: Container(
          width: 22,
          child: Center(
            child: Text(
              txt,
              style: TextStyle(
                  color: thisMonth ? Color(0xff313131) : Color(0x7f313131),
                  fontSize: 12),
            ),
          ),
          decoration: ShapeDecoration(
            color: hasIcon ? Color(0x7f7bcbe6) : Color(0x00000000),
            shape: CircleBorder(),
          ),
        ),
      ),
    );
  }

  bool _checkHasIcon(List<DataSignDayInfo> list, int day, int month) {
    if (month != widget.month) {
      return false;
    }
    for (final signDay in list) {
      if (signDay.day == day) {
        return true;
      }
    }
    return false;
  }

  int _nextMonth(int month) {
    int m = month + 1;
    if (m > 12) {
      return 1;
    }
    return m;
  }

  int _lastMonth(int month) {
    int m = month - 1;
    if (m == 0) {
      return 12;
    }
    return m;
  }

  Widget _buildImpl(BuildContext context, List<DataSignDayInfo> list) {
    DateTime now = DateTime(widget.year, widget.month, 10);
    final int daysThisMonth = DateTime(now.year, now.month + 1, 0).day;
    final int daysLastMonth = DateTime(now.year, now.month, 0).day;
    final int nowWeekDay = DateTime(now.year, now.month, 0).weekday;
    List<List<Widget>> matrixChildren =
        List.generate(7, (index) => List.empty(growable: true));
    matrixChildren[0].addAll([
      _buildIconTxt(false, 'MO', true),
      _buildIconTxt(false, 'TU', true),
      _buildIconTxt(false, 'WE', true),
      _buildIconTxt(false, 'TH', true),
      _buildIconTxt(false, 'FR', true),
      _buildIconTxt(false, 'SA', true),
      _buildIconTxt(false, 'SU', true),
    ]);
    int curLine = 1;
    for (int lastWeekDay = 0; lastWeekDay < nowWeekDay; ++lastWeekDay) {
      int day = daysLastMonth - (nowWeekDay - lastWeekDay) + 1;
      matrixChildren[curLine].add(
        _buildIconTxt(
          _checkHasIcon(
            list,
            day,
            _lastMonth(now.month),
          ),
          day.toString(),
          false,
        ),
      );
    }
    int thisWeekDay = nowWeekDay;
    if (thisWeekDay >= 7) {
      thisWeekDay %= 7;
      curLine++;
    }
    for (int day = 1; day <= daysThisMonth; ++day) {
      matrixChildren[curLine].add(
        _buildIconTxt(
          _checkHasIcon(list, day, now.month),
          day.toString(),
          true,
        ),
      );
      ++thisWeekDay;
      if (thisWeekDay >= 7) {
        thisWeekDay %= 7;
        curLine++;
      }
    }
    int nextMonthDay = 1;
    while (thisWeekDay != 7) {
      matrixChildren[curLine].add(
        _buildIconTxt(
          _checkHasIcon(
            list,
            nextMonthDay,
            _nextMonth(now.month),
          ),
          nextMonthDay.toString(),
          false,
        ),
      );
      nextMonthDay++;
      thisWeekDay++;
    }
    if (matrixChildren.last.isEmpty) {
      matrixChildren.removeLast();
    }
    return ComponentShadowedContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  int m = widget.month - 1;
                  int y = widget.year;
                  if (0 == m) {
                    y -= 1;
                    m = 12;
                  }
                  setState(() {
                    widget.month = m;
                    widget.year = y;
                  });
                },
                icon: Icon(
                  SOEIcons.left_arrow,
                  color: Color(0xff23529A),
                ),
              ),
              Text(
                '${widget.year}/${widget.month}',
                style: gSubtitleStyle,
              ),
              IconButton(
                onPressed: () {
                  int m = widget.month + 1;
                  int y = widget.year;
                  if (13 == m) {
                    y += 1;
                    m = 1;
                  }
                  setState(() {
                    widget.month = m;
                    widget.year = y;
                  });
                },
                icon: Icon(
                  SOEIcons.right_arrow,
                  color: Color(0xff23529A),
                ),
              ),
            ],
          ),
          Table(
            border: null,
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
              4: FlexColumnWidth(),
              5: FlexColumnWidth(),
              6: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: matrixChildren
                .map((lstWiget) => TableRow(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: lstWiget,
                    ))
                .toList(),
          ),
        ],
      ),
      color: Color(0XFFE8F3FB),
      shadowColor: Color(0x4fffffff),
      edgesHorizon: 22,
      edgesVertical: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DataSignDayInfo>>(
      future: MsgSign().getListSignDataInfo(widget.month, widget.year),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildImpl(context, snapshot.data!);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
