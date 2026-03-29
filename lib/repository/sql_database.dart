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
    _database = await openDatabase(path, version: 1, onCreate: _databaseCreate);
  }

  void _databaseCreate(Database db, int version) async {
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
  }

  void closeDataBase() async {
    if(_database!=null) await _database!.close();
  }


}
