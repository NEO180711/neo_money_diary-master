import 'package:abc_money_diary/screens/calendar_screen.dart';
import 'package:abc_money_diary/screens/diary_directory/diary_screen.dart';
import 'package:abc_money_diary/screens/advice_screen.dart';
import 'package:abc_money_diary/screens/search_screen.dart';
import 'package:abc_money_diary/screens/statistic_directory/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  //뒤로가기 두 번 눌러 화면종료하기 관련
  DateTime? currentBackPressTime;
  bool canPop = false;
  void willPop(dynamic) {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      const msg = "'뒤로'버튼을 한 번 더 누르면 종료됩니다.";

      Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        fontSize: 20,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );

      setState(() {
        canPop = false;
      });
    }
    setState(() {
      canPop = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        onPopInvoked: willPop,
        canPop: canPop,
        child: Center(
          child: bodyItem.elementAt(selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        selectedItemColor: Colors.orange,
        currentIndex: selectedIndex,

        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: '가계부',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_outlined),
            label: '더보기',
          ),
        ],
      ),
    );
  }
}

List bodyItem = [
  DiaryScreen(),
  CalendarScreen(),
  SearchScreen(),
  StatisticScreen(),
  EtcScreen(),
];
