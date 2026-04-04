import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../repository/sql_diary_crud_repository.dart';
import '../widgets/pair.dart';
import 'fixed_expense_screen.dart';
import 'installment_management_screen.dart';
import 'category_management_screen.dart';

class EtcScreen extends StatefulWidget {
  const EtcScreen({super.key});

  @override
  State<EtcScreen> createState() => _EtcScreenState();
}

class _EtcScreenState extends State<EtcScreen> {
  List<Pair> categoryMoney = [];

  Future<List<Pair>> _getABCcategory(String month) async {
    List<Pair> newList =
        await SqlDiaryCrudRepository.getABCcategory(month, 'C');
    categoryMoney = newList;
    return categoryMoney;
  }

  // 돈 3글자마다 ',' 넣어주기
  String moneyToCleanString(String money) {
    int temp = int.parse(money);
    String result = '${NumberFormat.decimalPattern('ko_KR').format(temp)}원';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //스테이터스바 투명하게 만드는 부분
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.orange,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.orange,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        //앱바 높이
        toolbarHeight: 70,
        //글자 색
        foregroundColor: Colors.white,
        //앱 바 색
        backgroundColor: Colors.orange,
        //앱 바 밑에 음영 사라지게 만드는 코드
        elevation: 2,

        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: "Yeongdeok-Sea",
            fontWeight: FontWeight.w600),
        title: Text('NEO가계부'),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 1. 프로필 영역 (카카오톡 스타일)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange[100],
                    child: const Icon(Icons.person, size: 40, color: Colors.orange),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '사용자님',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'neo_diary@example.com',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('편집', style: TextStyle(color: Colors.black, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.5),

            // 2. 이번 달 지출 요약 (기존 일침 기능 활용)
            FutureBuilder(
              future: _getABCcategory(DateFormat('yyyy-MM-dd').format(DateTime.now())),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var datas = snapshot.data!.reversed.toList();
                  String message = (datas.isEmpty || datas[0].b == 0)
                      ? '이번 달은 아직 낭비가 없네요! 훌륭해요 :)'
                      : '이번 달 [${datas[0].a}] 항목 낭비가 가장 많아요!';

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            message,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox(height: 10);
              },
            ),

            // 3. 주요 기능 그리드 메뉴
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenuItem(Icons.category_outlined, '카테고리 관리', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CategoryManagementScreen()),
                        );
                      }),
                      _buildMenuItem(Icons.credit_card_outlined, '할부 관리', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InstallmentManagementScreen()),
                        );
                      }),
                      _buildMenuItem(Icons.calendar_month_outlined, '고정지출/예산', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FixedExpenseScreen()),
                        );
                      }),
                      _buildMenuItem(Icons.info_outline, '버전 정보', () {}),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenuItem(Icons.cloud_upload_outlined, '백업/복구', () {}),
                      _buildMenuItem(Icons.color_lens_outlined, '테마 설정', () {}),
                      _buildMenuItem(Icons.lock_outline, '잠금 설정', () {}),
                      _buildMenuItem(Icons.picture_as_pdf_outlined, '엑셀/PDF로 변환', () {}),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
