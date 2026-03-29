import 'package:abc_money_diary/screens/diary_directory/day_diary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/diary_model.dart';
import '../repository/sql_diary_crud_repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  String searchText ='';

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
          //검색창
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.black,
              ),
              padding: EdgeInsets.all(1),
              child: SearchBar(
                hintText: '검색',
                hintStyle: MaterialStatePropertyAll(TextStyle(color: Colors.grey)),
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                leading: Icon(Icons.search),
                elevation: MaterialStatePropertyAll(0),
                controller: _searchTextController,
                onSubmitted: (value) {
                  setState(() {
                    searchText = value;
                    _searchTextController.text = value;
                  });
                },
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: _loadDiaryList(searchText),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Not Support Sqflite'),
                  );
                }

                if (snapshot.hasData) {
                  var datas = snapshot.data;

                  //가계부 없는 날 나오는 화면
                  if (datas!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('정보가 없습니다', style: TextStyle(fontSize: 15)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Tip) ABC, 분류, 내용, 메모 를 검색할 수 있습니다',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: datas.length,

                    itemBuilder: (BuildContext context, int index) {
                      return DayDiaryWidget(
                        diary: datas[index],
                      );
                    },
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
    );
  }

  Future<List<Diary>> _loadDiaryList(String text) async {
    return await SqlDiaryCrudRepository.getSearchAllList(text);
  }
}
