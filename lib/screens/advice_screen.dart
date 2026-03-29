import 'dart:math';

import 'package:abc_money_diary/data/advice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../repository/sql_diary_crud_repository.dart';
import '../widgets/pair.dart';

class EtcScreen extends StatefulWidget {
  const EtcScreen({super.key});

  @override
  State<EtcScreen> createState() => _EtcScreenState();
}

class _EtcScreenState extends State<EtcScreen> {
  List<Pair> categoryMoney = [];

  Future<List<Pair>> _getABCcategory(String month) async {
    List<Pair> newList =
    await SqlDiaryCrudRepository.getABCcategory(month, 'C');
    categoryMoney = newList;
    return categoryMoney;
  }

  //돈 3글자마다 ',' 넣어주기
  String moneyToCleanString(String money) {
    int temp = int.parse(money);
    String result = '${NumberFormat.decimalPattern('ko_KR').format(temp)}원';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    int randomNumberPic = Random().nextInt(12);
    int randomNumberAdvice = Random().nextInt(10);

    return Scaffold(
      appBar: AppBar(
        //스테이터스바 투명하게 만드는 부분
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.orange,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.orange,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        //앱바 높이
        toolbarHeight: 70,
        //글자 색
        foregroundColor: Colors.white,
        //앱 바 색
        backgroundColor: Colors.orange,
        //앱 바 밑에 음영 사라지게 만드는 코드
        elevation: 2,

        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: "Yeongdeok-Sea",
            fontWeight: FontWeight.w600),
        title: Text('ABC 가계부'),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            //이번 달 지출 일침 부분
            FutureBuilder(
              future: _getABCcategory(DateTime.now().toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var datas = snapshot.data!.reversed.toList();

                  if (datas.isEmpty || datas[0].b == 0) {
                    return AspectRatio(
                      aspectRatio: 1.5,
                      child: Card(
                        color: Colors.red,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '이번 달은 아직 불필요한 지출이 없어요!!',
                                style: TextStyle(fontSize: 16,color: Colors.white, fontFamily: "Soyo"),
                              ),
                              Text(
                                '다음 달도 이번 달만큼 노력해 봐요:)',
                                style: TextStyle(fontSize: 16,color: Colors.white, fontFamily: "Soyo"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return AspectRatio(
                    aspectRatio: 1.3,
                    child: Card(
                      color: Colors.red,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '이번 달은 [${datas[0].a}]에 \n불필요한 지출을 가장 많이 했어요.',
                              style: TextStyle(fontSize: 16,color: Colors.white, fontFamily: "Soyo"),
                            ),
                            Text(
                              '총 ${moneyToCleanString(datas[0].b.toString())} 지출했습니다.',
                              style: TextStyle(fontSize: 16,color: Colors.white, fontFamily: "Soyo"),
                            ),
                            Text(
                              '다음 달은 [${datas[0].a}]에 \n사용하는 낭비성 지출을 더 줄여봐요!!',
                              style: TextStyle(fontSize: 16,color: Colors.white, fontFamily: "Soyo"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );

              },
            ),

            //돈 사진 부분
            Card(
              child: Image.asset('assets/images/image${randomNumberPic + 1}.jpg'),
            ),

            //동기부여 글귀 부분
            AspectRatio(
              aspectRatio: randomNumberAdvice == 2
                  ? 1.2
                  : randomNumberAdvice == 7
                      ? 1
                      : randomNumberAdvice == 4
                          ? 0.8
                          : randomNumberAdvice == 6
                              ? 0.7
                              : randomNumberAdvice == 8
                                  ? 0.7
                                  : randomNumberAdvice == 5
                                      ? 1.2
                                      : 1.5,
              child: Card(
                color: Colors.black,
                child: Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Advice(num: randomNumberAdvice + 1),
                ),
              ),
            ),

            //앱 아이콘
            Card(
              child: Image.asset('assets/images/abc_advice.png'),
            ),
          ],
        ),
      ),
    );
  }
}
