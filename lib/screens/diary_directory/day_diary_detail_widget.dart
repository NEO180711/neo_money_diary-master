//날짜별 가계부 목록 작게 보여주는 것들

import 'package:abc_money_diary/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/diary_model.dart';
import '../../repository/sql_diary_crud_repository.dart';
import 'modify_diary_screen.dart';

class DayDiaryDetailWidget extends StatefulWidget {
  final Diary diary;

  const DayDiaryDetailWidget({
    super.key, required this.diary,
  });

  @override
  State<DayDiaryDetailWidget> createState() => _DayDiaryDetailWidgetState();
}

class _DayDiaryDetailWidgetState extends State<DayDiaryDetailWidget> {

  void update() => setState(() {});

  //수정버튼 클릭시 이벤트
  void modifyButton() {
    //바텀시트 상세설정은 메인화면에 theme에서 설정했음
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 600,
          child: ModifyDiaryScreen(
            diary: widget.diary,
          ),
        );
      },
      backgroundColor: Colors.white,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ).then((value) => update());
  }

  //삭제버튼 클릭시 이벤트
  void deleteButton(Diary diary) async {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('삭제하시겠습니까?'),
        scrollable: true,
        actions: [
          TextButton(
            onPressed: () {
              SqlDiaryCrudRepository.delete(diary.id!);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
              update();
            },
            child: Text(
              '예',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '아니요',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(widget.diary.type!),
      titleTextStyle: TextStyle(
          color: Colors.red, fontSize: 50, fontWeight: FontWeight.w600),
      scrollable: true,
      surfaceTintColor: Colors.white,

      //상세내용부분
      content: SizedBox(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10,),
              Text(
                '금액 : ${moneyToString(widget.diary.money!)} 원',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "HakgyoansimWoojuR"),
              ),
              Divider(
                  color: Colors.grey.shade300, thickness: 2, height: 10),
              SizedBox(height: 20,),
              Text(
                '날짜 : ${widget.diary.date}',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '시간 : ${widget.diary.time}',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '분류 : ${widget.diary.category}',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '결제 방법 : ${widget.diary.payment}',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내용 : ',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${widget.diary.contents}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (widget.diary.memo != '')
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '메모 : ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${widget.diary.memo}',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),

      //삭제하기랑 수정하기 버튼
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => deleteButton(widget.diary),
          child: Text(
            '삭제하기',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: modifyButton,
          child: Text(
            '수정하기',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String moneyToString(String money) {
    if (money == "") {
      money = "0";
    }
    int temp = int.parse(money);
    String result = NumberFormat.decimalPattern('ko_KR').format(temp);
    return result;
  }
}
