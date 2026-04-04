import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../repository/supabase_diary_repository.dart';
import '../models/installment_model.dart';
import 'installment_detail_screen.dart';

class InstallmentManagementScreen extends StatefulWidget {
  const InstallmentManagementScreen({super.key});

  @override
  State<InstallmentManagementScreen> createState() => _InstallmentManagementScreenState();
}

class _InstallmentManagementScreenState extends State<InstallmentManagementScreen> {
  // 기존 컨트롤러
  final _nameController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _monthController = TextEditingController();
  final _dayController = TextEditingController();

  // 새로운 입력 필드 컨트롤러 추가
  final _remainingPriceController = TextEditingController(); // 남은 총 할부 잔액
  final _remainingMonthController = TextEditingController(); // 남은 개월 수
  final _paymentMethodController = TextEditingController();  // 결제 카드/계좌
  final _interestRateController = TextEditingController();   // 이자율
  final _freeMonthController = TextEditingController();      // 무이자 개월 수 (부분 무이자용)
  
  bool _isNotificationOn = true; // 결제일 알림 설정 상태
  
  List<Installment> _installments = [];
  final f = NumberFormat('###,###,###');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await SupabaseDiaryRepository.getInstallmentList();
    setState(() {
      _installments = data.map((item) => Installment(
        id: item['id'],
        name: item['name'] ?? '항목 없음',
        totalPrice: item['totalPrice'] ?? 0,
        monthlyPrice: item['monthlyPrice'] ?? 0,
        totalMonths: item['months'] ?? 1,
        currentMonth: item['currentMonth'] ?? 1,
        paymentMethod: item['paymentMethod'] ?? '신용카드',
        isInterestFree: item['interestType'] == '무이자',
        interestRate: (item['interestRate'] ?? 0.0).toDouble(),
        payDay: item['payDay'] ?? 1,
      )).toList();
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
    // 컨트롤러 초기화
    _nameController.clear();
    _totalPriceController.clear();
    _remainingPriceController.clear();
    _monthController.clear();
    _remainingMonthController.clear();
    _paymentMethodController.clear();
    _interestRateController.clear();
    _freeMonthController.clear();
    _dayController.text = "1";
    String interestType = '무이자'; // 초기 선택값
    _isNotificationOn = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder( // 다이얼로그 내 동적 UI 변경을 위해 사용
        builder: (context, setDialogState) => Padding(
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
                _buildInputRow('총 금액', _totalPriceController, hint: '전체 결제 금액', isNumber: true),
                _buildInputRow('남은 잔액', _remainingPriceController, hint: '현재 기준 남은 금액', isNumber: true),
                _buildInputRow('전체 개월', _monthController, hint: '예: 12', isNumber: true),
                _buildInputRow('남은 개월', _remainingMonthController, hint: '앞으로 낼 횟수', isNumber: true),
                _buildInputRow('결제 수단', _paymentMethodController, hint: '카드사 또는 계좌명'),
                _buildInputRow('결제일', _dayController, hint: '매달 결제일(숫자)', isNumber: true),
                
                // 결제일 알림 Switch
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('결제일 알림', style: TextStyle(fontFamily: "HakgyoansimWoojuR", fontWeight: FontWeight.w600, fontSize: 18, color: Colors.grey.shade600)),
                      Switch(
                        value: _isNotificationOn,
                        onChanged: (val) => setDialogState(() => _isNotificationOn = val),
                        activeColor: Colors.orange,
                      ),
                    ],
                  ),
                ),
                
                const Divider(),
                const Text('이자 유형 선택', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                
                // 이자 유형 라디오 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['무이자', '유이자', '부분 무이자'].map((type) => Row(
                    children: [
                      Radio<String>(
                        value: type,
                        groupValue: interestType,
                        onChanged: (val) => setDialogState(() => interestType = val!),
                        activeColor: Colors.orange,
                      ),
                      Text(type, style: const TextStyle(fontSize: 14)),
                    ],
                  )).toList(),
                ),

                // 이자 유형에 따른 동적 입력창
                if (interestType == '유이자') 
                  _buildInputRow('이자율', _interestRateController, hint: '연 이자율(%)', isNumber: true),
                
                if (interestType == '부분 무이자') ...[
                  _buildInputRow('무이자 기간', _freeMonthController, hint: '예: 3 (3개월 무이자)', isNumber: true),
                  _buildInputRow('이후 이자율', _interestRateController, hint: '이후 적용 이자율(%)', isNumber: true),
                ],

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text.isNotEmpty) {
                        int total = int.tryParse(_totalPriceController.text) ?? 0;
                        int months = int.tryParse(_monthController.text) ?? 1;
                        int monthly = (total / months).floor();

                        await SupabaseDiaryRepository.createInstallment({
                          'name': _nameController.text,
                          'totalPrice': total,
                          'remaining_principal': int.tryParse(_remainingPriceController.text) ?? total,
                          'months': months,
                          'remaining_months': int.tryParse(_remainingMonthController.text) ?? months,
                          'monthlyPrice': monthly,
                          'paymentMethod': _paymentMethodController.text,
                          'payDay': int.parse(_dayController.text),
                          'interestType': interestType,
                          'interestRate': double.tryParse(_interestRateController.text) ?? 0.0,
                          'freeMonths': int.tryParse(_freeMonthController.text) ?? 0,
                          'isNotificationOn': _isNotificationOn,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('진행 중인 할부', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey.shade800)),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => InstallmentDetailScreen(installment: item)),
                            );
                          },
                          leading: const CircleAvatar(backgroundColor: Colors.orangeAccent, child: Icon(Icons.shopping_bag, color: Colors.white)),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('매달 ${item.payDay}일 / ${item.totalMonths}개월 중 ${item.currentMonth}회차'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${f.format(item.monthlyPrice)}원', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              Text('${f.format(item.remainingPrincipal)}원 남음', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          onLongPress: () async {
                            await SupabaseDiaryRepository.deleteInstallment(item.id!);
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
    int totalRemaining = 0;

    for (var item in _installments) {
      totalMonthly += item.monthlyPrice;
      totalRemaining += item.remainingPrincipal;
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
          const SizedBox(height: 4),
          Text(
            '${f.format(totalMonthly)}원',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallSummary('남은 총 할부 금액', '${f.format(totalRemaining)}원'),
              _buildSmallSummary('진행 중인 건수', '${_installments.length}건'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallSummary(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
      ],
    );
  }
}