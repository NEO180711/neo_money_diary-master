import 'package:abc_money_diary/widgets/pair.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/textOutLine.dart';

class AbcCircleCategoryScreen extends StatefulWidget {
  final List<Pair> categoryMoney;
  final Map<String, String> categoryMap;
  final int index;

  const AbcCircleCategoryScreen(
      {super.key,
      required this.categoryMoney,
      required this.categoryMap,
      required this.index});

  @override
  State<AbcCircleCategoryScreen> createState() =>
      _AbcCircleCategoryScreenState();
}

class _AbcCircleCategoryScreenState extends State<AbcCircleCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
              pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              }),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 5,
              centerSpaceRadius: 50,
              sections: showingSections()),
        ),
      ),
    );
  }

  int touchedIndex = -1;

  //원형통계 만드는 부분
  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> list = [];

    int sum = 0;
    int index = 0;
    for (int i = 0; i < widget.categoryMoney.length; i++) {
      int money = widget.categoryMoney[i].b;
      //if( money > 0 ) break;
      sum += money;
      index++;
    }

    int hop = index < 5 ? 200 : 100;

    for (int i = 0; i < index && i < 20; i++) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 70.0 : 60.0;

      String category = widget.categoryMoney[i].a;
      int money = widget.categoryMoney[i].b;
      double per = money == 0 ? 0 : money / sum * 100;

      //추후 이미지로 바꿀 수도 있음
      String categoryIcon = "*";

      if (widget.categoryMap.containsKey(category)) {
        categoryIcon = widget.categoryMap[category]!;
      }

      list.add(PieChartSectionData(
        //차트 색깔 선택부분인데 맘에 드는 색깔이 없음 흠;;
        color: widget.index == 0
            ? Colors.teal[(index - i) * hop]
            : widget.index == 1
                ? Colors.orange[(index - i) * hop]
                : Colors.red[(index - i) * hop],
        title: '',
        value: per,
        radius: radius,
        badgeWidget: Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              categoryIcon,
              style: TextStyle(color: Colors.orange),
            ),
          ),
          backgroundColor: Colors.orange[(index - i) * hop],
          label: isTouched
              ? TextOutline(
                  text: "$category: ${(per).toStringAsFixed(2)}%",
                  textColor: Colors.white,
                  outlineColor: Colors.orange,
                )
              : TextOutline(
                  text: category,
                  textColor: Colors.white,
                  outlineColor: Colors.orange,
                ),
        ),
        badgePositionPercentageOffset: .98,
      ));
    }

    return list;
  }
}
