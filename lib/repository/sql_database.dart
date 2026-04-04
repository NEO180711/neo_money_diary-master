import 'package:abc_money_diary/models/diary_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDataBase {
  static final SqlDataBase instance = SqlDataBase._instance();

  Database? _database;

  SqlDataBase._instance() {
    _initDataBase();
  }

  factory SqlDataBase() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await _initDataBase();
    return _database!;
  }

  Future<void> _initDataBase() async {
    var dataBasepath = await getDatabasesPath();
    String path = join(dataBasepath, 'Diary.db');
    // 버전 관리가 필요하다면 version을 올리거나, 개발 중에는 앱을 삭제 후 재설치하는 게 가장 확실합니다.
    _database = await openDatabase(path, version: 1, onCreate: _databaseCreate);
  }

  void _databaseCreate(Database db, int version) async {
    // 1. 가계부 메인 테이블 생성
    await db.execute('''
          create table $tableName(
            ${DiaryFields.id} integer primary key autoincrement,
            ${DiaryFields.type} text not null,
            ${DiaryFields.date} text not null,
            ${DiaryFields.time} text not null,
            ${DiaryFields.category} text,
            ${DiaryFields.money} text not null,
            ${DiaryFields.contents} text,
            ${DiaryFields.memo} text,
            ${DiaryFields.payment} text
            )'''
    );

    // 2. 카테고리 테이블 생성 (추가됨)
    await db.execute('''
          create table category (
            id integer primary key autoincrement,
            name text not null,
            iconCode integer not null
          )
    ''');

    // 3. 할부 테이블 생성 (추가됨)
    await db.execute('''
          create table installment (
            id integer primary key autoincrement,
            name text,
            amount integer
          )
    ''');
  }

  void closeDataBase() async {
    if (_database != null) await _database!.close();
  }
}