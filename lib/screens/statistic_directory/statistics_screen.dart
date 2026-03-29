import 'package:abc_money_diary/screens/statistic_directory/abc_list_chart_card.dart';
import 'package:abc_money_diary/screens/statistic_directory/circular_chart_card.dart';
import 'package:abc_money_diary/screens/statistic_directory/list_chart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:intl/intl.dart';

import '../../widgets/description_diary_widget.dart';
import '../../widgets/total_abc_money.dart';
import 'abc_circular_chart_card.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  late String diaryMonth;
  DateTime selectedDate = DateTime.now();

  //돈 3글자마다 ',' 넣어주기
  String moneyToCleanString(String money) {
    int temp = int.parse(money);
    String result = '${NumberFormat.decimalPattern('ko_KR').format(temp)}원';
    return result;
  }

  @override
  Widget build(BuildContext context) {
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

        leadingWidth: double.infinity,
        leading: Row(
          children: [
            IconButton(
                onPressed: onTapLeftChevron,
                icon: Icon(
                  Icons.chevron_left_outlined,
                  color: Colors.white,
                )),
            TextButton(
              onPressed: () => DatePicker.showSimpleDatePicker(
                context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                dateFormat: "yyyy년-MMMM",
                locale: DateTimePickerLocale.ko,
                looping: false,
                cancelText: '취소',
                confirmText: '확인',
              ).then((date) {
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                    diaryMonth =
                        DateFormat('yyyy-MM-dd').format(selectedDate);
                  });
                }
              }),
              child: Text(
                getTimeNow(),
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontFamily: "Yeongdeok-Sea",
                ),
              ),
            ),
            IconButton(
                onPressed: selectedDate!=DateTime.now() ? onTapRightChevron : null,
                icon: Icon(
                  Icons.chevron_right_outlined,
                  color: Colors.white,
                )),
          ],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('ABC 가계부 알아보기',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Soyo")),
                  content: DescriptionDiary(),
                ),
              );
            },
            icon: Icon(
              Icons.help_outline,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // ABC 항목 별 금액 표시해주는 곳
          TotalAbcMoney(
            diaryMonth: diaryMonth,
          ),

          //통계부분
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 3,
                  ),

                  //원형 통계부분
                  AspectRatio(
                    aspectRatio: 1,
                    child: Card(
                      elevation: 4,
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      child: CircularChartCard(diaryMonth: diaryMonth),
                    ),
                  ),

                  //리스트표 부분
                  AspectRatio(
                    aspectRatio: 1,
                    child: Card(
                      elevation: 4,
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      child: ListChartCard(diaryMonth: diaryMonth),
                    ),
                  ),

                  //ABC 원형 통계부분
                  AspectRatio(
                    aspectRatio: 1,
                    child: Card(
                      elevation: 4,
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      child: AbcCircularChartCard(diaryMonth: diaryMonth),
                    ),
                  ),

                  //ABC 리스트표 부분
                  AspectRatio(
                    aspectRatio: 1,
                    child: Card(
                      elevation: 4,
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      child: AbcListChartCard(diaryMonth: diaryMonth),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  //setState 간단하게 update로 만들어둔 곳
  void update() => setState(() {});

  /*-------------------------------------------appbar 관련 부분 시작----------------------------------------------------------------*/

  //왼쪽 화살표
  void onTapLeftChevron() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
    diaryMonth = DateFormat('yyyy-MM-dd').format(selectedDate);

    update();
  }

  //오른쪽 화살표
  void onTapRightChevron() {
    if(selectedDate == DateTime(DateTime.now().year, DateTime.now().month)){
      update();
    }

    else {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
      diaryMonth = DateFormat('yyyy-MM-dd').format(selectedDate);
      update();
    }

  }

  //앱바 날짜 바꿀 때 작동하는 부분들
  String getTimeNow() {
    diaryMonth = DateFormat('yyyy-MM-dd').format(selectedDate);
    selectedDate = selectedDate = DateTime(selectedDate.year, selectedDate.month);
    return DateFormat('yyyy 년 MM 월').format(selectedDate);
  }

  //돈 입력 시 3자리마다 , 붙여주는 등 관련 설정
  String moneyToString(int money) => NumberFormat.decimalPattern('ko_KR').format(money);


  /*-----------------------------------------------차트 관련 부분 시작-----------------------------------------------------------*/


}
