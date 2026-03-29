//가계부 상세내용 보여주는 위젯

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/diary_model.dart';
import 'day_diary_detail_widget.dart';

class DayDiaryWidget extends StatefulWidget {
  final Diary diary;

  const DayDiaryWidget({super.key, required this.diary,});

  @override
  State<DayDiaryWidget> createState() => _DayDiaryWidgetState();
}

class _DayDiaryWidgetState extends State<DayDiaryWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //가계부 목록 클릭시 상세내용 보여주는 위젯
      onTap: () async {
        showDialog(
          context: context,
          barrierColor: Colors.black38,
          builder: (context) {
            return DayDiaryDetailWidget(diary: widget.diary);
          },
        );
        update();
      },

      //가계부 목록들
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          //가계부 테두리랑 뒤에 그림자 효과 등등
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.orange,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey,
                blurStyle: BlurStyle.outer,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              //날짜 및 c항목 금액 표시하는 곳
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.diary.date!,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Yeongdeok-Sea",
                    ),
                  ),
                  Text(
                    widget.diary.time!,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Yeongdeok-Sea",
                    ),
                  ),
                ],
              ),

              //경계선
              Divider(
                thickness: 2,
                height: 5,
                color: Colors.orange,
              ),

              //각 지출들을 날짜 별로 출력하는 곳
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(flex: 1,child: Text(widget.diary.type!, overflow: TextOverflow.ellipsis)),
                    Flexible(flex: 1,child: Text(widget.diary.category!, overflow: TextOverflow.ellipsis)),
                    Flexible(flex: 1,child: Text(widget.diary.payment!, overflow: TextOverflow.ellipsis)),
                    Flexible(flex: 1,child: Text('￦ ${moneyToString(widget.diary.money!)}', overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String moneyToString(String money){
    if (money == "") {
      money = "0";
    }
    int temp = int.parse(money);
    String result = NumberFormat.decimalPattern('ko_KR').format(temp);
    return result;
  }

  void update() => setState(() {});
}
