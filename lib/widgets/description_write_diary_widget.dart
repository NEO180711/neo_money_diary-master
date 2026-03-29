import 'package:flutter/material.dart';

class DescriptionWriteDiary extends StatelessWidget {
  const DescriptionWriteDiary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 20,),

            Text('1. 상단에 수입/지출을 선택합니다.',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, fontFamily: "Soyo")),
            SizedBox(height: 10,),
            Text('-> 선택하지 않을 경우 기본 값은 \n\'지출\'로 저장됩니다.'),

            SizedBox(height: 20,),


            Text('2. 날짜와 시간을 선택합니다.',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, fontFamily: "Soyo")),
            SizedBox(height: 10,),
            Text('-> 선택하지 않을 경우 기본 값은 \n현재 시간과 날짜로 저장됩니다.'),

            SizedBox(height: 20,),


            Text('3. 금액을 입력합니다.',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, fontFamily: "Soyo")),
            SizedBox(height: 10,),
            Text('-> 입력하지 않을 경우 기본 값은 \n\'0원\'으로 저장됩니다.'),

            SizedBox(height: 20,),


            Text('4. 결제 방법을 입력합니다.',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, fontFamily: "Soyo")),
            SizedBox(height: 10,),
            Text('-> 입력하지 않을 경우 기본 값은 \n\'카드\'로 저장됩니다.'),

            SizedBox(height: 20,),


            Text('5. 분류를 선택합니다.',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, fontFamily: "Soyo")),
            SizedBox(height: 10,),
            Text('-> 선택하지 않을 경우 기본값은 \n\'기타\'로 저장됩니다.'),

            SizedBox(height: 20,),


            Text('6. 내용과 메모',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, fontFamily: "Soyo")),
            SizedBox(height: 10,),
            Text('-> 내용과 메모는 자율 선택입니다. \n입력해도 되고 입력하지 않아도 괜찮습니다.'),

          ],
        ),
      ),
    );
  }
}
