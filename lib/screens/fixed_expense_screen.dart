import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FixedExpenseScreen extends StatefulWidget {
  const FixedExpenseScreen({super.key});

  @override
  State<FixedExpenseScreen> createState() => _FixedExpenseScreenState();
}

class _FixedExpenseScreenState extends State<FixedExpenseScreen> {
  // 임시 데이터 리스트 (추후 DB 연동 가능)
  List<Map<String, dynamic>> _fixedExpenses = [
    {'id': 1, 'name': '월세', 'price': '500000', 'day': '25', 'icon': Icons.home},
    {'id': 2, 'name': '통신비', 'price': '65000', 'day': '15', 'icon': Icons.phone_android},
    {'id': 3, 'name': '보험료', 'price': '110000', 'day': '5', 'icon': Icons.security},
  ];

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _dayController = TextEditingController();

  // 입력 필드 통일 (WriteDiaryScreen 스타일)
  Widget _buildInputRow(String label, TextEditingController controller, {String? hint, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: "HakgyoansimWoojuR", fontWeight: FontWeight.w600, fontSize: 20, color: Colors.grey.shade600),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(child: _buildCustomTextField(controller, hint ?? '', isNumber: isNumber)),
        ],
      ),
    );
  }

  // 지출 추가/수정 다이얼로그
  void _showExpenseDialog({Map<String, dynamic>? expense}) {
    if (expense != null) {
      _nameController.text = expense['name'];
      _priceController.text = expense['price'];
      _dayController.text = expense['day'];
    } else {
      _nameController.clear();
      _priceController.clear();
      _dayController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 20),
              Text(
                expense == null ? '새 고정 지출 등록' : '고정 지출 정보 수정',
                style: const TextStyle(fontFamily: "Yeongdeok-Sea", fontSize: 20, color: Colors.orange),
              ),
              const SizedBox(height: 20),
              _buildInputRow('항목명', _nameController, hint: '예: 월세, 통신비'),
              _buildInputRow('금액', _priceController, hint: '숫자만 입력', isNumber: true),
              _buildInputRow('이체일', _dayController, hint: '매달 결제일(숫자)', isNumber: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (expense == null) {
                        _fixedExpenses.add({
                          'id': DateTime.now().millisecondsSinceEpoch,
                          'name': _nameController.text,
                          'price': _priceController.text,
                          'day': _dayController.text,
                          'icon': Icons.stars_outlined,
                        });
                      } else {
                        expense['name'] = _nameController.text;
                        expense['price'] = _priceController.text;
                        expense['day'] = _dayController.text;
                      }
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('저장하기', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.brown.shade100, fontSize: 16),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange.shade100)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      ),
      style: const TextStyle(color: Colors.brown, fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  // 삭제 확인 (커스텀 바텀 시트로 변경)
// 1. 'id'를 'void'로 수정
void _deleteExpense(int id) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('정말 삭제할까요?',
              style: TextStyle(
                  fontFamily: "Yeongdeok-Sea",
                  fontSize: 20,
                  color: Colors.redAccent)),
          const SizedBox(height: 15),
          const Text('등록된 고정 지출 정보가 영구히 삭제됩니다.',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('취소', style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() =>
                        _fixedExpenses.removeWhere((e) => e['id'] == id));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('삭제하기',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ); // 2. 여기서 괄호 하나로 깔끔하게 닫고 세미콜론!
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '고정 지출 및 예산 관리',
          style: TextStyle(fontFamily: "Yeongdeok-Sea"),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('이번 달 예산 관리'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const ListTile(
                leading: Icon(Icons.account_balance_wallet, color: Colors.orange),
                title: Text('설정된 총 예산'),
                trailing: Text('1,200,000원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('자동 기록될 고정 지출'),
            if (_fixedExpenses.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('등록된 고정 지출이 없습니다.'),
              ))
            else
              ..._fixedExpenses.map((expense) => _buildFixedExpenseItem(expense)).toList(),
            const SizedBox(height: 10),
            const Text('Tip) 항목을 클릭하면 수정, 길게 누르면 삭제할 수 있습니다.', 
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_fixed_expense',
        onPressed: () => _showExpenseDialog(),
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "Yeongdeok-Sea",
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _buildFixedExpenseItem(Map<String, dynamic> expense) {
    final f = NumberFormat('###,###,###');
    String formattedPrice = "${f.format(int.parse(expense['price']))}원";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => _showExpenseDialog(expense: expense),
        onLongPress: () => _deleteExpense(expense['id']),
        leading: CircleAvatar(
          backgroundColor: Colors.orange[50],
          child: Icon(expense['icon'], color: Colors.orange),
        ),
        title: Text(expense['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("매달 ${expense['day']}일", style: TextStyle(color: Colors.grey[600])),
        trailing: Text(
          formattedPrice, 
          style: const TextStyle(
            color: Colors.redAccent, 
            fontWeight: FontWeight.bold,
            fontSize: 15
          )
        ),
      ),
    );
  }
}