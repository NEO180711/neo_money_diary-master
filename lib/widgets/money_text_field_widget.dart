import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String moneyToString(int money) => NumberFormat.decimalPattern('ko_KR').format(money);

class MoneyTextField extends StatelessWidget {
  final controller;
  final FocusNode focusNode;

  const MoneyTextField({super.key, required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      focusNode: focusNode,

      //키보드에서 숫자 외에 .-/ 이런 거 입력 못하게 막는 코드
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,],

      onChanged: (string) {
        if(string.isEmpty) return ;
        int money = int.parse(string.replaceAll(',', ''));
        if(money>1000000000000) money = 1000000000000;
        string = moneyToString(money);
        controller.value = TextEditingValue(
          text: string,
          selection: TextSelection.collapsed(offset: string.length),
        );

      },

      decoration: InputDecoration(
        labelText: '금액을 입력하세요',
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: Colors.brown.shade200),
        suffixText: "₩",

        //텍스트를 입력하면 라벨 텍스트는 안보이게 만드는 코드
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 5,
        ),
      ),
      style: TextStyle(
        color: Colors.brown,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
