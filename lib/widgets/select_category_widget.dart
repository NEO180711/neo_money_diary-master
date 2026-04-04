import 'package:flutter/material.dart';
import '../data/category.dart'; // 기존 category1, category2 등이 정의된 파일
import '../repository/supabase_diary_repository.dart';

class SelectCategoryWidget extends StatefulWidget {
  final TextEditingController categoryController;

  const SelectCategoryWidget({super.key, required this.categoryController});

  @override
  State<SelectCategoryWidget> createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  // DB에서 가져온 카테고리를 담을 리스트
  List<Map<String, dynamic>> _dbCategories = [];

  // 기존 category.dart에 있던 기본 항목들을 리스트로 정리
  final List<String> _defaultCategories = [
    category1, category2, category3, category4,
    category5, category6, category7, category8,
    category9, category10, category11, category12,
    category13, category14, category15, category16,
    category17, category18, category19, category20,
  ];

  @override
  void initState() {
    super.initState();
    _loadDbCategories();
  }

  Future<void> _loadDbCategories() async {
    final list = await SupabaseRepository.getCategoryList();
    setState(() {
      _dbCategories = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 기본 항목과 DB 항목을 합친 전체 리스트 생성
    // DB 데이터에서 'name' 필드만 추출하여 문자열 리스트로 변환합니다.
    List<String> allCategories = [
      ..._defaultCategories,
      ..._dbCategories.map((e) => e['name'].toString()).toList(),
    ];

    return Container(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: allCategories.asMap().entries.map((entry) {
            int index = entry.key;
            String categoryName = entry.value;

            return TextButton(
              onPressed: () {
                widget.categoryController.text = categoryName;
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                // 기존 코드처럼 주황색과 빨간색 계열을 번갈아가며 적용
                backgroundColor: index % 2 == 0 
                    ? Colors.orange.shade100 
                    : Colors.red.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                categoryName,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Yeongdeok-Sea",
                  fontSize: 15,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}