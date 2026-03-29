import '../models/diary_model.dart';

class AiFormatter {
  /// Diary 리스트를 AI가 분석하기 쉬운 요약 문자열로 변환합니다.
  static String formatDiaryList(List<Diary> diaries) {
    if (diaries.isEmpty) return "분석할 가계부 내역이 없습니다.";
    
    return diaries.map((d) {
      // d가 null일 가능성을 대비하거나 필드 접근 시 안전하게 처리
      return "- [${d.date ?? ''}] ${d.type ?? ''}: ${d.category ?? ''}(${d.contents ?? ''}) / ${d.money ?? '0'}원";
    }).join('\n');
  }
}