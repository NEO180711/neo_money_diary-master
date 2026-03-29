import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/diary_model.dart';
import '../repository/sql_diary_crud_repository.dart';
import 'diary_directory/day_diary_widget.dart';
import 'diary_directory/write_diary_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  void update() => setState(() {});

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

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

          centerTitle: true,
          titleTextStyle: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: "Yeongdeok-Sea",
              fontWeight: FontWeight.w600),
          title: Text('ABC 가계부'),
        ),

        body: Column(
          children: [
            // 달력 부분
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: DateTime(2000, 01),
              lastDay: DateTime.now(),
              locale: 'ko-KR',
              daysOfWeekHeight: 20,

              //다른 달 날짜 선택시 그 달로 이동
              pageJumpingEnabled: true,

              //헤더 스타일
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),

              //캘린더 스타일
              calendarStyle: CalendarStyle(
                //오늘 날짜
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 1.5),
                ),
                todayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),

                //선택 날짜
                selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 1.5),
                ),
                selectedTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),

              ),

              //날짜 선택 기능
              onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                setState(() {
                  this.focusedDay = focusedDay;
                  this.selectedDay = selectedDay;
                });
              },

              selectedDayPredicate: (day) => isSameDay(day, selectedDay),

              onDayLongPressed: (selectedDay, focusedDay) {
                setState(() {
                  this.focusedDay = focusedDay;
                  this.selectedDay = selectedDay;
                });
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 630,
                      child: WriteDiaryScreen(preDate: selectedDay),
                    );
                  },
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  showDragHandle: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ).then((value) => update());
              },
            ),

            // 날짜별 가계부 목록 보여주는 부분
            Expanded(
              child: FutureBuilder(
                future: _loadDiaryList(selectedDay),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Not Support Sqflite'),
                    );
                  }
                  if (snapshot.hasData) {
                    var datas = snapshot.data;

                    //가계부 없는 날 나오는 화면
                    if(datas!.isEmpty){
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('정보가 없습니다', style: TextStyle(fontSize: 15)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Tip) 날짜를 길게 누르면 가계부 작성이 가능합니다',
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return GroupedListView(
                      elements: datas,
                      groupBy: (element) => element.date,
                      order: GroupedListOrder.DESC,
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, element) =>
                          DayDiaryWidget(diary: element),
                      //그룹 헤더 디자인부분
                      groupSeparatorBuilder: (value) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Divider(
                                thickness: 2,
                                color: Colors.orange,
                              ),
                              Text(
                                value!,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Yeongdeok-Sea",
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }


  //하루치 가계부 목록 가져오기
  Future<List<Diary>> _loadDiaryList(DateTime date) async {
    return await SqlDiaryCrudRepository.getDayList(
        DateFormat('yyyy-MM-dd').format(date));
  }
}
