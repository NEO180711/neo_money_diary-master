import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/installment_model.dart';

class InstallmentDetailScreen extends StatefulWidget {
  final Installment installment;
  const InstallmentDetailScreen({super.key, required this.installment});

  @override
  State<InstallmentDetailScreen> createState() => _InstallmentDetailScreenState();
}

class _InstallmentDetailScreenState extends State<InstallmentDetailScreen> {
  bool _isNotificationOn = true;
  final f = NumberFormat('###,###,###');

  @override
  Widget build(BuildContext context) {
    final item = widget.installment;

    return Scaffold(
      appBar: AppBar(
        title: const Text('할부 상세 정보', style: TextStyle(fontFamily: "Yeongdeok-Sea")),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.orange,
              padding: const EdgeInsets.only(bottom: 30, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text(item.isInterestFree ? '무이자' : '유이자 할부', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        backgroundColor: item.isInterestFree ? Colors.green : Colors.redAccent,
                        padding: EdgeInsets.zero,
                      ),
                      if (!item.isInterestFree) ...[
                        const SizedBox(width: 10),
                        Text('월 수수료: ${f.format(item.monthlyFee)}원', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      ]
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildDetailRow('결제 수단', item.paymentMethod),
                  _buildDetailRow('회차 정보', '${item.currentMonth} / ${item.totalMonths} 회'),
                  _buildDetailRow('이번 달 납입금', '${f.format(item.totalMonthlyPayment)}원'),
                  const Divider(height: 40),
                  _buildDetailRow('남은 원금', '${f.format(item.remainingPrincipal)}원', isBold: true),
                  _buildDetailRow('전체 총액', '${f.format(item.totalPrice)}원'),
                  const SizedBox(height: 30),
                  
                  // 알림 설정 영역
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notifications_active_outlined, color: Colors.grey.shade700),
                            const SizedBox(width: 12),
                            const Text('결제일 알림 받기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Switch(
                          value: _isNotificationOn,
                          onChanged: (val) => setState(() => _isNotificationOn = val),
                          activeColor: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // 중도 상환 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // 중도 상환 로직
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('중도 상환하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: isBold ? Colors.orange : Colors.black87),
          ),
        ],
      ),
    );
  }
}