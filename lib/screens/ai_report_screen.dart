import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/diary_model.dart';
import '../repository/sql_diary_crud_repository.dart';
import '../services/gemini_service.dart';
import '../utils/ai_formatter.dart';

class AiReportScreen extends StatefulWidget {
  const AiReportScreen({super.key});

  @override
  State<AiReportScreen> createState() => _AiReportScreenState();
}

class _AiReportScreenState extends State<AiReportScreen> {
  final GeminiService _apiService = GeminiService(); // 싱글톤 인스턴스 사용
  Map<String, String>? _report;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateReport();
  }

  Future<void> _generateReport() async {
    setState(() => _isLoading = true);
    try {
      final String currentMonth = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final List<Diary> diaries = await SqlDiaryCrudRepository.getMonthList(currentMonth);
      final String formattedData = AiFormatter.formatDiaryList(diaries);
      
      final result = await _apiService.getAnalysisReport(formattedData);
      setState(() => _report = result);
    } catch (e) {
      debugPrint('AI 분석 오류: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AI 소비 패턴 리포트', style: TextStyle(fontFamily: "Yeongdeok-Sea")),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.orange))
        : _report == null 
          ? const Center(child: Text('데이터를 분석하는 중 오류가 발생했습니다.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _report!['title']!,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _report!['content']!,
                      style: const TextStyle(fontSize: 16, height: 1.5, fontFamily: "Soyo"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTipCard(_report!['tip']!),
                ],
              ),
            ),
    );
  }

  Widget _buildTipCard(String tip) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(tip, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}