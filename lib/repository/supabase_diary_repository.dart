import 'package:abc_money_diary/repository/sql_database.dart';
import 'package:abc_money_diary/widgets/pair.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/diary_model.dart';
import 'package:flutter/material.dart';

class SupabaseDiaryRepository {
  static const String categoryTableName = 'category';
  static const String installmentTableName = 'installment';

   /* 카테고리 관련 메서드 (Supabase 버전) */
  
  // 1. 카테고리 목록 불러오기
  static Future<List<Map<String, dynamic>>> getCategoryList() async {
    // supabase 클라이언트 호출
    final supabase = Supabase.instance.client;
    
    // 'category' 테이블에서 이름 오름차순으로 모든 데이터 선택
    final data = await supabase
        .from('category')
        .select()
        .order('name', ascending: true);
        
    return data as List<Map<String, dynamic>>;
  }
  
  // 2. 카테고리 추가
  static Future<void> createCategory(String name, String icon) async {
    final supabase = Supabase.instance.client;
    
    // 'category' 테이블에 새로운 행 삽입
    await supabase.from('category').insert({
      'name': name,
      'icon': icon,
    });
  }
  
  // 3. 카테고리 수정
  static Future<void> updateCategory(int id, String name, String icon) async {
    final supabase = Supabase.instance.client;
    
    // 해당 id를 가진 행의 name과 iconCode 업데이트
    await supabase
        .from('category')
        .update({'name': name, 'icon': icon})
        .eq('id', id); // SQLite의 whereArgs 대신 .eq() 사용
  }
  
  // 4. 카테고리 삭제
  static Future<void> deleteCategory(int id) async {
    final supabase = Supabase.instance.client;
    
    // 해당 id를 가진 행 삭제
    await supabase
        .from('category')
        .delete()
        .eq('id', id);
  }

  /* 할부 관련 메서드 */

  static Future<List<Map<String, dynamic>>> getInstallmentList() async {
    var db = await SqlDataBase().database;
    try {
      return await db.query(installmentTableName);
    } catch (e) {
      return [];
    }
  }

  static Future<int> createInstallment(Map<String, dynamic> data) async {
    var db = await SqlDataBase().database;
    return await db.insert(installmentTableName, data);
  }

  static Future<int> deleteInstallment(int id) async {
    var db = await SqlDataBase().database;
    return await db.delete(installmentTableName, where: 'id = ?', whereArgs: [id]);
  }

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
