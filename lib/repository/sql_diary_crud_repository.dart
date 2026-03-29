import 'package:abc_money_diary/repository/sql_database.dart';
import 'package:abc_money_diary/widgets/pair.dart';

import '../models/diary_model.dart';

class SqlDiaryCrudRepository {

  //가계부 만들기
  static Future<Diary> create(Diary diary) async {
    var db = await SqlDataBase().database;
    var id = await db.insert(tableName, diary.toJson());
    return diary.clone(id: id);
  }

  /* 목록 전체 불러오기 */

  // 가계부 목록 전체 불러오기
  static Future<List<Diary>> getList() async {
    var db = await SqlDataBase().database;
    var result = await db.query(
      tableName,
      columns: [
        DiaryFields.id,
        DiaryFields.money,
        DiaryFields.type,
        DiaryFields.date,
        DiaryFields.time,
        DiaryFields.category,
        DiaryFields.contents,
        DiaryFields.memo,
        DiaryFields.payment,
      ],
      orderBy: DiaryFields.time,
    );

    return result.map(
          (data) {
        return Diary.fromJson(data);
      },
    ).toList();
  }

  //가계부 검색해서 전부 불러오기
  static Future<List<Diary>> getSearchAllList(String text) async {
    var db = await SqlDataBase().database;
    var result = await db.rawQuery(
        "SELECT * FROM $tableName WHERE ${DiaryFields.memo} LIKE '%$text%' OR ${DiaryFields.category} LIKE '%$text%' "
            "OR ${DiaryFields.contents} LIKE '%$text%' OR ${DiaryFields.type} LIKE '%$text%'"
            "ORDER BY ${DiaryFields.date} ASC ;",
        null);

    return result.map(
          (data) {
        return Diary.fromJson(data);
      },
    ).toList();
  }

  //가계부 검색해서 한 달치 항목 불러오기
  static Future<List<Diary>> getSearchList(String text, String month) async {
    var db = await SqlDataBase().database;
    var result = await db.rawQuery(
        "SELECT * FROM $tableName WHERE (${DiaryFields.memo} LIKE '%$text%' OR ${DiaryFields.category} LIKE '%$text%' "
            "OR ${DiaryFields.contents} LIKE '%$text%' OR ${DiaryFields.type} LIKE '%$text%')"
            "AND ${DiaryFields.date} >= date('$month','start of month','localtime') AND ${DiaryFields.date} <= date('$month','start of month','+1 month','-1 day','localtime')"
            "ORDER BY ${DiaryFields.date} ASC ;",
        null);

    return result.map(
          (data) {
        return Diary.fromJson(data);
      },
    ).toList();
  }

  //가계부 검색해서 한 달치 항목 불러오기 ABC
  static Future<List<Diary>> getSearchABCList(String text, String month, String abc) async {
    var db = await SqlDataBase().database;
    var result = await db.rawQuery(
        "SELECT * FROM $tableName WHERE (${DiaryFields.memo} LIKE '%$text%' OR ${DiaryFields.category} LIKE '%$text%' "
            "OR ${DiaryFields.contents} LIKE '%$text%' OR ${DiaryFields.type} LIKE '%$text%')"
            "AND ${DiaryFields.date} >= date('$month','start of month','localtime') AND ${DiaryFields.date} <= date('$month','start of month','+1 month','-1 day','localtime')"
            "AND ${DiaryFields.type} = '$abc'"
            "ORDER BY ${DiaryFields.date} ASC ;",
        null);

    return result.map(
          (data) {
        return Diary.fromJson(data);
      },
    ).toList();
  }


  /* 한 달치 목록 불러오기 */

  // 한 달치 가계부 불러오기
  static Future<List<Diary>> getMonthList(String month) async {
    var db = await SqlDataBase().database;
    var result = await db.rawQuery(
        "SELECT * FROM $tableName WHERE ${DiaryFields.date} >= date('$month','start of month','localtime') AND ${DiaryFields.date} <= date('$month','start of month','+1 month','localtime')"
        "ORDER BY ${DiaryFields.time} ;",
        null);

    return result.map(
          (data) {
        return Diary.fromJson(data);
      },
    ).toList();
  }

  /* 하루치 목록 불러오기 */

  // 하루치 가계부 불러오기
  static Future<List<Diary>> getDayList(String date) async {
    var db = await SqlDataBase().database;
    var result = await db.rawQuery(
        "SELECT * FROM $tableName WHERE ${DiaryFields.date} >= date('$date', 'localtime') "
        " AND ${DiaryFields.date} <= date('$date', 'localtime', '+1 days') ORDER BY ${DiaryFields.time} ;",
        null);

    return result.map(
          (data) {
        return Diary.fromJson(data);
      },
    ).toList();
  }


  /* 총 합 불러오기 */

  // A 총합 불러오기
  static Future<String> getTotalMoneyA(String month) async {
    var db = await SqlDataBase().database;
    var results = await db.rawQuery(
        "SELECT SUM(${DiaryFields.money}) FROM $tableName WHERE ${DiaryFields.date} >= date('$month','start of month','localtime') "
        "AND ${DiaryFields.date} <= date('$month','start of month','+1 month','-1 day','localtime') AND ${DiaryFields.type} = 'A' ");

    String str = results.toString();

    if (str.contains('null')) {
      return '0';
    }

    return resultToCleanString(str);
  }

  // B 총합 불러오기
  static Future<String> getTotalMoneyB(String month) async {
    var db = await SqlDataBase().database;
    var results = await db.rawQuery(
        "SELECT SUM(${DiaryFields.money}) as sum FROM $tableName WHERE ${DiaryFields.date} >= date('$month','start of month','localtime') "
        "AND ${DiaryFields.date} <= date('$month','start of month','+1 month','-1 day','localtime') AND ${DiaryFields.type} = 'B' ");

    String str = results.toString();

    if (str.contains('null')) {
      return '0';
    }

    return resultToCleanString(str);
  }

  // C 총합 불러오기
  static Future<String> getTotalMoneyC(String month) async {
    var db = await SqlDataBase().database;
    var results = await db.rawQuery(
        "SELECT SUM(${DiaryFields.money}) as sum FROM $tableName WHERE ${DiaryFields.date} >= date('$month','start of month','localtime') "
        "AND ${DiaryFields.date} <= date('$month','start of month','+1 month','-1 day','localtime') AND ${DiaryFields.type} = 'C' ");

    String str = results.toString();

    if (str.contains('null')) {
      return '0';
    }

    return resultToCleanString(str);
  }

  // 카테고리별로 불러오기
  static Future<List<Pair>> getTotalCategory(String month) async {
    var db = await SqlDataBase().database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT category, SUM(money) FROM $tableName WHERE ${DiaryFields.date} >= date('$month','start of month','localtime') "
        "AND ${DiaryFields.date} <= date('$month','start of month','+1 month','-1 day','localtime') GROUP BY category ORDER BY SUM(money)");

    if (maps.isEmpty) return [];

    List<Pair> list = [];
    for (int i = 0; i < maps.length; i++) {
      list.add(Pair(maps[i]["category"], maps[i]["SUM(money)"]));
    }

    return list;
  }

  // ABC,카테고리 별로 불러오기
  static Future<List<Pair>> getABCcategory(String month,String abc) async {
    var db = await SqlDataBase().database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT category, SUM(money) FROM $tableName WHERE ${DiaryFields.date} >= date('$month','start of month','localtime') "
        "AND ${DiaryFields.date} <= date('$month','start of month','+1 month','-1 day','localtime') "
        "AND ${DiaryFields.type} = '$abc' GROUP BY category ORDER BY SUM(money)");

    if (maps.isEmpty) return [];

    List<Pair> list = [];
    for (int i = 0; i < maps.length; i++) {
      list.add(Pair(maps[i]["category"], maps[i]["SUM(money)"]));
    }

    return list;
  }

  /* 선택이나 수정, 삭제 등 */

  //가계부 한 개를 선택해서 불러오기
  static Future<Diary?> getDiaryOne(int id) async {
    var db = await SqlDataBase().database;
    var result = await db.query(
      tableName,
      columns: [
        DiaryFields.category,
        DiaryFields.contents,
        DiaryFields.date,
        DiaryFields.id,
        DiaryFields.memo,
        DiaryFields.money,
        DiaryFields.time,
        DiaryFields.type,
        DiaryFields.payment,
      ],
      where: '${DiaryFields.id} = ?',
      whereArgs: [id],
    );

    var list = result.map(
      (data) {
        return Diary.fromJson(data);
      },
    ).toList();
    if (list.isNotEmpty) {
      return list.first;
    } else {
      return null;
    }
  }

  //가계부 수정
  static Future<int> update(Diary diary) async {
    var db = await SqlDataBase().database;
    return await db.update(
      tableName,
      diary.toJson(),
      where: '${DiaryFields.id}=?',
      whereArgs: [diary.id],
    );
  }

  //가계부 삭제
  static Future<int> delete(int id) async {
    var db = await SqlDataBase().database;
    return await db.delete(
      tableName,
      where: '${DiaryFields.id}=?',
      whereArgs: [id],
    );
  }

  //가계부 전체 삭제
  static Future<int> deleteAll() async {
    var db = await SqlDataBase().database;
    return await db.delete(
      tableName,
    );
  }



  static String moneyToCleanInt(String str){
    var temp = str.split('');
    int Index=0;

    for(int i=0;i<str.length;i++){
      if(temp[i]=='.' || temp[i]=='}') {
        Index = i;
        break;
      }
    }

    String result = str.substring(0, Index);
    return result;
  }

  //돈 깔끔하게 숫자만 있게 만드는 거
  static String resultToCleanString(String str){
    List num = ['0','1','2','3','4','5','6','7','8','9'];
    int firstIndex=0;
    int lastIndex=0;
    var temp = str.split('');

    for(int i=0;i<str.length;i++){
      if(num.contains(temp[i])) {
        firstIndex = i;
        break;
      }
    }

    for(int i=0;i<str.length;i++){
      if(temp[i]=='.' || temp[i]=='}') {
        lastIndex = i;
        break;
      }
    }

    String result = str.substring(firstIndex, lastIndex);
    return result;
  }


}
