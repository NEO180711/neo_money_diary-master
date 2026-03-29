import 'package:flutter/material.dart';

import '../../repository/sql_diary_crud_repository.dart';
import '../../widgets/pair.dart';
import 'circle_category_screen.dart';

class CircularChartCard extends StatefulWidget {
  final String diaryMonth;
  const CircularChartCard({super.key, required this.diaryMonth});

  @override
  State<CircularChartCard> createState() => _CircularChartCardState();
}

class _CircularChartCardState extends State<CircularChartCard> {

  List<Pair> categoryMoney = [];
  Map<String, String> categoryMap = {};

  Future<List<Pair>> _getTotalCategory(String month) async {
    List<Pair> newList = await SqlDiaryCrudRepository.getTotalCategory(month);
    categoryMoney = newList;
    return categoryMoney;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getTotalCategory(widget.diaryMonth),
      initialData: [],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //총 합 0일경우 방지를 위해
          int sum = 0;
          for (int i = 0; i < categoryMoney.length; i++) {
            int money = categoryMoney[i].b;
            sum += money;
          }

          if (snapshot.data!.isEmpty || sum == 0) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Circular Chart",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Yeongdeok-Sea"),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text('정보가 없습니다.'),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Circular Chart",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Yeongdeok-Sea"),
              ),
              CircleCategoryScreen(
                categoryMap: categoryMap,
                categoryMoney: categoryMoney,
              ),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
