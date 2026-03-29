import 'dart:convert';
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
  void init() {
    final String? apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY 가 .env 파일에 설정되지 않았습니다.');
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
    _isInitialized = true;
  }

  /// 요약된 데이터를 바탕으로 AI 분석 리포트를 가져옵니다.
  Future<Map<String, String>> getAnalysisReport(String summarizedData) async {
    if (!_isInitialized) init();

    final prompt = '''
    당신은 'NEO가계부'의 전문 AI 자산 관리사입니다. 
    아래 가계부 데이터를 분석하여 사용자의 소비 패턴을 진단하고 조언을 해주세요.
    응답은 반드시 아래의 JSON 형식으로만 작성하고, 마크다운 기호 없이 순수 JSON 문자열만 출력하세요.
    {
      "title": "리포트 제목",
      "content": "상세 분석 내용",
      "tip": "금융 조언 및 팁"
    }
    데이터:
    $summarizedData
    ''';

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
  }
}