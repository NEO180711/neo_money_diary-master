import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // 싱글톤 패턴 적용
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  late GenerativeModel _model;
  bool _isInitialized = false;

  /// 서비스 초기화: .env에서 API 키를 읽어 모델을 설정합니다.
  Future<void> init() async {
    if (_isInitialized) return;

    final String? apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY 가 .env 파일에 설정되지 않았습니다.');
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
    _isInitialized = true;
    debugPrint('Gemini 모델 초기화 완료');
  }

  /// 요약된 데이터를 바탕으로 AI 분석 리포트를 가져옵니다.
  Future<Map<String, String>> getAnalysisReport(String summarizedData) async {
    if (!_isInitialized) await init();

    final prompt = '''
    당신은 'NEO가계부'의 전문 AI 자산 관리사입니다. 
    제공된 데이터를 분석해서 이번 달 소비 패턴 리포트를 친절한 말투로 작성해줘.
    응답은 반드시 아래의 JSON 형식으로만 작성하고, 마크다운(```json) 기호 없이 순수 JSON 문자열만 출력하세요.
    {
      "title": "리포트 제목",
      "content": "상세 분석 내용",
      "tip": "금융 조언 및 팁"
    }
    데이터:
    $summarizedData
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final String responseText = response.text ?? '{}';
      
      final cleanedText = responseText.replaceAll('```json', '').replaceAll('```', '').trim();
      final Map<String, dynamic> decoded = jsonDecode(cleanedText);
      
      return {
        'title': decoded['title']?.toString() ?? '분석 결과',
        'content': decoded['content']?.toString() ?? '분석 내용을 불러오지 못했습니다.',
        'tip': decoded['tip']?.toString() ?? '지속적인 가계부 작성을 통해 소비 습관을 점검해보세요.',
      };
    } catch (e) {
      debugPrint('Gemini API 호출 중 오류 발생: $e');
      return {
        'title': '분석 일시 중단',
        'content': '네트워크 오류 또는 API 키 설정 문제로 분석을 완료하지 못했습니다.',
        'tip': '잠시 후 다시 시도하거나 인터넷 연결을 확인해주세요.',
      };
    }
  }
}