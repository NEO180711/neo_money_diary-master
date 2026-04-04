import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../repository/supabase_diary_repository.dart';
import '../models/diary_model.dart';

class TotalAbcMoney extends StatelessWidget {
  final String diaryMonth;

  @override
  Widget build(BuildContext context) {

    //돈 3글자마다 ',' 넣어주기
    String moneyToCleanString(String money){
      int temp = int.parse(money);
      String result = '${NumberFormat.decimalPattern('ko_KR').format(temp)}원';
      return result;
    }


    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),

        child: Row(
          children: [
            // A 항목 금액
            Flexible(
              flex: 1,
              child: FutureBuilder(
                future: _loadTotalMoney('수입'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Not Support Sqflite'),
                    );
                  }
                  if (snapshot.hasData) {
                    var datas = snapshot.data;
                    return Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            '수입',
                            style: TextStyle(
                              color: Colors.black,
                                fontFamily: "Yeongdeok-Sea",
                                fontWeight: FontWeight.w500),
                          ),
                          Text(moneyToCleanString(datas!),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Yeongdeok-Sea",
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),

            // B 항목 금액
            Flexible(
              flex: 1,
              child: FutureBuilder(
                future: _loadTotalMoney('지출'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Not Support Sqflite'),
                    );
                  }
                  if (snapshot.hasData) {
                    var datas = snapshot.data;
                    return Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            '지출',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Yeongdeok-Sea",
                                fontWeight: FontWeight.w500),
                          ),
                          Text(moneyToCleanString(datas!),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Yeongdeok-Sea",
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),

            // C 항목 금액
            Flexible(
              flex: 1,
              child: FutureBuilder(
                future: _loadSumMoney(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Not Support Sqflite'),
                    );
                  }
                  if (snapshot.hasData) {
                    var datas = snapshot.data;
                    return Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            '합계',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Yeongdeok-Sea",
                                fontWeight: FontWeight.w500),
                          ),
                          Text(moneyToCleanString(datas!),
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: "Yeongdeok-Sea",
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
    
  }

  const TotalAbcMoney({super.key, required this.diaryMonth});

  // 특정 타입(수입/지출)의 합계 계산
  Future<String> _loadTotalMoney(String type) async {
    List<Diary> list = await SupabaseDiaryRepository.getMonthList(diaryMonth);
    int total = 0;
    for (var diary in list) {
      if (diary.type == type) {
        total += int.parse(diary.money ?? '0');
      }
    }
    return total.toString();
  }

  // 합계 계산 (수입 - 지출)
  Future<String> _loadSumMoney() async {
    List<Diary> list = await SupabaseDiaryRepository.getMonthList(diaryMonth);
    int income = 0;
    int expense = 0;
    for (var diary in list) {
      if (diary.type == '수입') {
        income += int.parse(diary.money ?? '0');
      } else if (diary.type == '지출') {
        expense += int.parse(diary.money ?? '0');
      }
    }
    return (income - expense).toString();
  }
}
