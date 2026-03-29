import 'package:abc_money_diary/models/diary_model.dart';
import 'package:abc_money_diary/widgets/pair.dart';
import 'package:intl/intl.dart';

class AiFormatter {
  /// Diary 리스트를 AI가 분석하기 쉬운 요약 문자열로 변환합니다.
  static String formatDiaryList(List<Diary> diaries) {
    if (diaries.isEmpty) return "분석할 가계부 내역이 없습니다.";
    
    return diaries.map((d) {
      // d가 null일 가능성을 대비하거나 필드 접근 시 안전하게 처리
      return "- [${d.date ?? ''}] ${d.type ?? ''}: ${d.category ?? ''}(${d.contents ?? ''}) / ${d.money ?? '0'}원";
    }).join('\n');
  }

  /// 카테고리별 통계 데이터(List<Pair>)를 요약된 문자열로 변환합니다.
  static String formatCategoryList(List<Pair> categories) {
    if (categories.isEmpty) return "분석할 지출 내역이 없습니다.";
    
    final formatter = NumberFormat.decimalPattern('ko_KR');
    return categories.map((p) => "${p.a}: ${formatter.format(p.b)}원").join(', ');
  }
}