class Installment {
  final int? id;
  final String name;          // 품목명
  final int totalPrice;      // 총액
  final int monthlyPrice;    // 월 납입금 (원금 기준)
  final int totalMonths;     // 전체 개월 수
  final int currentMonth;    // 현재 회차
  final String paymentMethod; // 결제 수단 (카드/계좌)
  final bool isInterestFree; // 무이자 여부
  final double interestRate; // 이자율 (연이율 %)
  final int payDay;          // 결제일

  Installment({
    this.id,
    required this.name,
    required this.totalPrice,
    required this.monthlyPrice,
    required this.totalMonths,
    required this.currentMonth,
    required this.paymentMethod,
    required this.isInterestFree,
    required this.interestRate,
    required this.payDay,
  });

  // 잔여 원금 getter
  int get remainingPrincipal {
    int remaining = totalPrice - (monthlyPrice * currentMonth);
    return remaining < 0 ? 0 : remaining;
  }

  // 월 수수료(이자) getter: (총액 * 이자율 / 100) / 12개월 (단순 선형 계산식 기준)
  int get monthlyFee {
    if (isInterestFree) return 0;
    return ((totalPrice * (interestRate / 100)) / 12).round();
  }

  // 이번 달 실제 총 납입액 (원금 + 수수료)
  int get totalMonthlyPayment => monthlyPrice + monthlyFee;
}