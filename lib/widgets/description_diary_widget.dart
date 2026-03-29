import 'package:flutter/material.dart';

class DescriptionDiary extends StatelessWidget {
  const DescriptionDiary({super.key});

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
            Text('ABC 가계부란?',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, fontFamily: "Soyo")),

            Divider(color: Colors.black,thickness: 2,),

            Text('ABC 가계부는 지출을 크게 세 가지로 분류합니다.'),

            SizedBox(height: 10,),

            Text('(A) 꼭 필요한 것', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10,),
            Text('꼭 필요한 것은 먹고사는 데 필수적인 것입니다. \n예를 들어 교통비나 식대, 아파트 관리비, 세금과 같은 것이겠지요.'),

            SizedBox(height: 20,),

            Text('(B) 필요한 것', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10,),
            Text('필요한 것은 자녀 교육비와 같은 것입니다. 이것들은 반드시는 아니어도 필요한 것들입니다.'),

            SizedBox(height: 20,),

            Text('(C) 있으면 좋은 것, 그리고 없어도 되는 것', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10,),
            Text('있으면 좋은 것은 명품이나 잦은 외식 같은 것들이 대표적입니다. 말 그대로 있으면 좋은 것들입니다.'),
            SizedBox(height: 10,),
            Text('마지막으로 없어도 되는 것은 주차위반 딱지나 과태료, 연체료 등 조금만 신경 쓰면 얼마든지 없앨 수 있는 것입니다. 생돈 날리는 경우지요.'),

            SizedBox(height: 30,),

            Text('사용목적',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, fontFamily: "Soyo")),

            Divider(color: Colors.black,thickness: 2,),

            Text('일반적인 가계부로는 낭비성 지출을 찾아내기 어렵습니다.'),
            Text('그저 현금 흐름만 파악될 뿐입니다.'),
            SizedBox(height: 10,),
            Text('- C 항목의 구체적인 금액을 한 눈에 확인하고 스스로에게 경각심을 일깨워줍니다.'),
            SizedBox(height: 10,),
            Text('- C 항목을 최대한 줄이면서 낭비성 지출을 줄이는 것이 이 가계부의 사용 목적이라고 할 수 있습니다.'),


            SizedBox(height: 30,),
            Divider(color: Colors.black,thickness: 2,),
            Text('오늘부터 ABC 가계부를 쓰면서 \n줄일 건 줄이고, 저축을 늘리는 재미를 찾아보시기 바랍니다.',),
            SizedBox(height: 20,),
            Text('이것이 부자가 되는 \n첫걸음입니다.',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, fontFamily: "Soyo")),

          ],
        ),
      ),
    );
  }
}
