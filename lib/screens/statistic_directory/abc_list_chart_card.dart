import 'package:flutter/material.dart';

import '../../repository/sql_diary_crud_repository.dart';
import '../../widgets/pair.dart';
import 'abc_list_category_screen.dart';

class AbcListChartCard extends StatefulWidget {
  final String diaryMonth;

  const AbcListChartCard({super.key, required this.diaryMonth});

  @override
  State<AbcListChartCard> createState() => _AbcListChartCardState();
}

class _AbcListChartCardState extends State<AbcListChartCard> {
  List<Pair> categoryMoney = [];

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

          var datas = snapshot.data!.reversed.toList();

          int sum = 0;
          for (int i = 0; i < datas.length; i++) {
            int money = datas[i].b;
            sum += money;
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 50, height: 65),
                  Text(
                    '${abc[index]} type List',
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
                child: ABCListCategoryScreen(
                  datas: datas,
                  sum: sum,
                  month: widget.diaryMonth,
                  abc: abc[index],
                ),
              ),
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
