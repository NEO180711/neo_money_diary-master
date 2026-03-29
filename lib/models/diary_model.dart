const String tableName = 'Diary';

class DiaryFields {
  static const String id = '_id';
  static const String type = 'type';
  static const String date = 'date';
  static const String time = 'time';
  static const String category = 'category';
  static const String money = 'money';
  static const String contents = 'contents';
  static const String memo = 'memo';
  static const String payment = 'payment';
}

class Diary {
  final int? id;
  final String? type;
  final String? date;
  final String? time;
  final String? category;
  final String? money;
  final String? contents;
  final String? memo;
  final String? payment;

  const Diary({
    this.id,
    this.type,
    this.date,
    this.time,
    this.category,
    this.money,
    this.contents,
    this.memo,
    this.payment,
  });

  Map<String, dynamic> toJson() {
    return {
      DiaryFields.id: id,
      DiaryFields.type: type,
      DiaryFields.date: date,
      DiaryFields.time: time,
      DiaryFields.category: category,
      DiaryFields.money: money,
      DiaryFields.contents: contents,
      DiaryFields.memo: memo,
      DiaryFields.payment: payment,
    };
  }

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      id: json[DiaryFields.id] as int?,
      type: json[DiaryFields.type] == null
          ? ''
          : json[DiaryFields.type] as String,
      date: json[DiaryFields.date] == null
          ? ''
          : json[DiaryFields.date] as String,
      time: json[DiaryFields.time] == null
          ? ''
          : json[DiaryFields.time] as String,
      category: json[DiaryFields.category] == null
          ? ''
          : json[DiaryFields.category] as String,
      money: json[DiaryFields.money] == null
          ? '0'
          : json[DiaryFields.money] as String,
      contents: json[DiaryFields.contents] == null
          ? ''
          : json[DiaryFields.contents] as String,
      memo: json[DiaryFields.memo] == null
          ? ''
          : json[DiaryFields.memo] as String,
      payment: json[DiaryFields.payment] == null
          ? ''
          : json[DiaryFields.payment] as String,
    );
  }

  Diary clone({
    int? id,
    String? type,
    String? date,
    String? time,
    String? category,
    String? money,
    String? contents,
    String? memo,
    String? payment,
  }) {
    return Diary(
      type: type ?? this.type,
      date: date ?? this.date,
      time: time ?? this.time,
      money: money ?? this.money,
      id: id ?? this.id,
      memo: memo ?? this.memo,
      category: category ?? this.category,
      contents: contents ?? this.contents,
      payment: payment ?? this.payment,
    );
  }
}
