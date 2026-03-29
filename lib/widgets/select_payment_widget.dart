import 'package:flutter/material.dart';

class SelectPaymentWidget extends StatefulWidget {
  final TextEditingController paymentController;

  const SelectPaymentWidget({super.key, required this.paymentController});

  @override
  State<SelectPaymentWidget> createState() => _SelectPaymentWidgetState();
}

class _SelectPaymentWidgetState extends State<SelectPaymentWidget> {
  String inputText = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            widget.paymentController.text = '현금';
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
          ),
          child: Text(
            '현금',
            style: TextStyle(
                color: Colors.black, fontFamily: "Yeongdeok-Sea", fontSize: 15),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.paymentController.text = '카드';
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
          ),
          child: Text(
            '카드',
            style: TextStyle(
                color: Colors.black, fontFamily: "Yeongdeok-Sea", fontSize: 15),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.paymentController.text = '계좌이체';
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
          ),
          child: Text(
            '계좌이체',
            style: TextStyle(
                color: Colors.black, fontFamily: "Yeongdeok-Sea", fontSize: 15),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.paymentController.text = '페이(Pay)류';
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
          ),
          child: Text(
            '페이(Pay)류',
            style: TextStyle(
                color: Colors.black, fontFamily: "Yeongdeok-Sea", fontSize: 15),
          ),
        ),
      ],
    );
  }
}
