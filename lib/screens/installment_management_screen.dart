import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../repository/sql_diary_crud_repository.dart';

class InstallmentManagementScreen extends StatefulWidget {
  const InstallmentManagementScreen({super.key});

  @override
  State<InstallmentManagementScreen> createState() => _InstallmentManagementScreenState();
}

class _InstallmentManagementScreenState extends State<InstallmentManagementScreen> {
  final _nameController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _monthController = TextEditingController();
  final _dayController = TextEditingController();
  
  List<Map<String, dynamic>> _installments = [];
  final f = NumberFormat('###,###,###');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await SqlDiaryCrudRepository.getInstallmentList();
    setState(() {
      _installments = data;
    });
  }

  Widget _buildInputRow(String label, TextEditingController controller, {String? hint, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontFamily: "HakgyoansimWoojuR", fontWeight: FontWeight.w600, fontSize: 18, color: Colors.grey.shade600),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.brown.shade100, fontSize: 14),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange.shade100)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
              ),
              style: const TextStyle(color: Colors.brown, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    _nameController.clear();
    _totalPriceController.clear();
    _monthController.clear();
    _dayController.text = "1"; // 기본 결제일

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20, right: 20, top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              const Text('할부 계산 및 등록', style: TextStyle(fontFamily: "Yeongdeok-Sea", fontSize: 20, color: Colors.orange)),
              const SizedBox(height: 20),
              _buildInputRow('품목명', _nameController, hint: '예: 맥북'),
              _buildInputRow('총 금액', _totalPriceController, hint: '숫자만 입력', isNumber: true),
              _buildInputRow('개월 수', _monthController, hint: '예: 12', isNumber: true),
              _buildInputRow('결제일', _dayController, hint: '매달 결제일(숫자)', isNumber: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty && _totalPriceController.text.isNotEmpty && _monthController.text.isNotEmpty) {
                      int total = int.parse(_totalPriceController.text);
                      int months = int.parse(_monthController.text);
                      int monthly = (total / months).floor();

                      await SqlDiaryCrudRepository.createInstallment({
                        'name': _nameController.text,
                        'totalPrice': total,
                        'months': months,
                        'monthlyPrice': monthly,
                        'payDay': int.parse(_dayController.text),
                        'startDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      });
                      _loadData();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('등록하기', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할부 관리', style: TextStyle(fontFamily: "Yeongdeok-Sea")),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('진행 중인 할부 목록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          Expanded(
            child: _installments.isEmpty
                ? const Center(child: Text('등록된 할부 내역이 없습니다.'))
                : ListView.builder(
                    itemCount: _installments.length,
                    itemBuilder: (context, index) {
                      final item = _installments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const CircleAvatar(backgroundColor: Colors.orangeAccent, child: Icon(Icons.shopping_bag, color: Colors.white)),
                          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('매달 ${item['payDay']}일 / ${item['months']}개월 중 1회차'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${f.format(item['monthlyPrice'])}원', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              Text('총 ${f.format(item['totalPrice'])}원', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          onLongPress: () async {
                            await SqlDiaryCrudRepository.deleteInstallment(item['id']);
                            _loadData();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_installment',
        onPressed: _showAddDialog,
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard() {
    int totalMonthly = 0;
    for (var item in _installments) {
      totalMonthly += (item['monthlyPrice'] as num).toInt();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          const Text('이번 달 할부 합계', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(
            '${f.format(totalMonthly)}원',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}