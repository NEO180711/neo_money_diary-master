import 'package:flutter/material.dart';

class NoneInformationWidget extends StatelessWidget {
  const NoneInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        color: Colors.white,
        child: Center(
          child: Text('정보가 없습니다.'),
        ),
      ),
    );
  }
}
