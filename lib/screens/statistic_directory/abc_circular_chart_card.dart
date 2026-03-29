import 'package:flutter/material.dart';

import '../../repository/sql_diary_crud_repository.dart';
import '../../widgets/pair.dart';
import 'abc_circle_category_screen.dart';

class AbcCircularChartCard extends StatefulWidget {
  final String diaryMonth;

  const AbcCircularChartCard({super.key, required this.diaryMonth});

  @override
  State<AbcCircularChartCard> createState() => _AbcCircularChartCardState();
}

class _AbcCircularChartCardState extends State<AbcCircularChartCard> {
  List<Pair> categoryMoney = [];
  Map<String, String> categoryMap = {};

  Future<List<Pair>> _getABCcategory(String month, String abc) async {
    List<Pair> newList =
        await SqlDiaryCrudRepository.getABCcategory(month, abc);
    categoryMoney = newList;
    return categoryMoney;
  }

  List abc = ['A', 'B', 'C'];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getABCcategory(widget.diaryMonth, abc[index]),
      initialData: [],
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          //총 합 0일경우 방지를 위해
          int sum = 0;
          for(int i=0;i<categoryMoney.length;i++){
            int money = categoryMoney[i].b;
            sum += money;
          }

          if (snapshot.data!.isEmpty || sum==0) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Text(
                      "ABC Circular Chart",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Yeongdeok-Sea"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (index == 2) {
                            index = 0;
                          } else {
                            index++;
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.black),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      child: Text(abc[index]),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    "ABC Circular Chart",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Yeongdeok-Sea"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (index == 2) {
                          index = 0;
                        } else {
                          index++;
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black),
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    child: Text(abc[index]),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              AbcCircleCategoryScreen(
                categoryMap: categoryMap,
                categoryMoney: categoryMoney,
                index: index,
              ),
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
