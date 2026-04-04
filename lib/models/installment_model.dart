class Installment {
  final int? id;
  final String name;          // 품목명
  final int totalPrice;      // 전체 결제 총액 (예: 12,000,000)
  final int monthlyPrice;    // 월 납입금 (원금 기준, 예: 1,000,000)
  final int totalMonths;     // 전체 할부 개월 수 (예: 12)
  final int remainingMonths; // 💡 수정: 남은 할부 개월 수 (예: 6)
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
    required this.remainingMonths, // 이제 현재 회차 대신 남은 개월수를 받습니다.
    required this.paymentMethod,
    required this.isInterestFree,
    required this.interestRate,
    required this.payDay,
  });

  // 💡 잔여 원금 getter 수정
  // 사용자가 기대하는 대로 (월 납입금 * 남은 개월 수)로 계산합니다.
  // 예: 1,000,000원 * 6개월 = 6,000,000원
  int get remainingPrincipal {
    return monthlyPrice * remainingMonths;
  }

  // 💡 현재 회차 정보 getter 추가
  // 전체 개월수와 남은 개월수를 비교하여 현재가 몇 회차인지 계산합니다.
  // 예: 12개월 중 6개월 남았다면 (12 - 6 + 1) = 현재 7회차 납부 예정
  int get currentMonth {
    if (totalMonths <= 0) return 1;
    int calculated = totalMonths - remainingMonths + 1;
    return calculated > totalMonths ? totalMonths : (calculated < 1 ? 1 : calculated);
  }

  // 월 수수료(이자) getter: (총액 * 이자율 / 100) / 12개월
  int get monthlyFee {
    if (isInterestFree || interestRate <= 0) return 0;
    return ((totalPrice * (interestRate / 100)) / 12).round();
  }

  // 이번 달 실제 총 납입액 (원금 + 수수료)
  int get totalMonthlyPayment => monthlyPrice + monthlyFee;
}