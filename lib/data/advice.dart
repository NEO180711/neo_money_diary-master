import 'package:flutter/material.dart';

class Advice extends StatelessWidget {
  final int num;
  const Advice({super.key, required this.num});

  @override
  Widget build(BuildContext context) {

    switch (num){
      case 1 : return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(advice1, style: TextStyle(fontFamily: "Jeongnimsaji-R", fontSize: 18, color: Colors.white,)),
          Text(source1, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      );
      case 2 : return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(advice2, style: TextStyle(fontFamily: "Jeongnimsaji-R", fontSize: 18, color: Colors.white,)),
          Text(source2, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      );
      case 3 : return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(advice3, style: TextStyle(fontFamily: "Jeongnimsaji-R", fontSize: 17, color: Colors.white,)),
          Text(source3, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      );
      case 4 : return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(advice4, style: TextStyle(fontFamily: "Jeongnimsaji-R", fontSize: 18, color: Colors.white,)),
          Text(source4, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      );
      case 5 : return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(advice5, style: TextStyle(fontFamily: "Jeongnimsaji-R", fontSize: 17, color: Colors.white,)),
          Text(source5, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      );
      case 6 : return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(advice6, style: TextStyle(fontFamily: "Jeongnimsaji-R", fontSize: 17, color: Colors.white,)),
          Text(source6, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      );
      case 7 : return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(advice7, style: TextStyle(fontFamily: "Jeongnimsaji-R", fontSize: 17, color: Colors.white,)),
          Text(source7, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      );
      case 8 : return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(advice8, style: TextStyle(fontFamily: "Jeongnimsaji-R", fontSize: 17, color: Colors.white,)),
          Text(source8, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      );
      case 9 : return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(advice9, style: TextStyle(fontFamily: "Jeongnimsaji-R", fontSize: 17, color: Colors.white,)),
          Text(source9, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      );
      case 10 : return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(advice10, style: TextStyle(fontFamily: "Jeongnimsaji-R", fontSize: 17, color: Colors.white,)),
          Text(source10, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      );
    }

    return Text('동기부여 페이지');
  }
}


//글귀 모음

const advice1 = '"재테크든 재정관리든 돈을 모으려면 \n일단 지출을 제대로 관리해야 해요.\n씀씀이 관리를 해야 하는 거죠"';
const source1 = '박종기, 『젊은 부자』, 청림출판(2013),  p64';

const advice2 = '"돈을 모으지 못하는 이유는 \n돈을 못 벌어서가 아니라 얼마를 쓰고 얼마를 모아야 하는지를 모르기 때문"';
const source2 = '박종기, 『젊은 부자』, 청림출판(2013),  p66';

const advice3 = '"생활비를 줄이기 위해 \n\'한 달에 50만원으로 살아야지\' 하면서 \n금액을 정해놓고 아껴 쓰려 하면 \n대부분 실패하게 되어 있어요.'
    '\n\n자신의 생활 패턴을 고려하지 않고 \n무작정 생활비를 정해놓고 쓰면 \n반드시 실패하게 돼요"';
const source3 = '박종기, 『젊은 부자』, 청림출판(2013),  p67';

const advice4 = '"재테크를 시작하기 전에 \n반드시 거쳐야 할 기본 단계가 바로 \n가계부를 쓰면서 내게 적정한 \n생활비 규모를 찾는 일이랍니다"';
const source4 = '박종기, 『젊은 부자』, 청림출판(2013),  p68';

const advice5 = '"사람들이 왜 재테크를 잘 못하고 돈을 모으지 못하는지 아나?" '
    '\n\n"낭비성 지출을 줄이라고 주변에서 아무리 얘기해도 자신들은 낭비하는 게 없다고 생각하거든." '
    '\n\n"습관적으로 커피 마시고, 외식하고, 옷 사고, 반값에 좋은 물건이 나오면 \n별로 필요하지도 않은데 마치 횡재라도 한 듯 얼른 사면서 말이야." '
    '\n\n"씀씀이 관리가 안 되면 재테크고 뭐고 아무것도 할 수 없는거야"';
const source5 = '박종기, 『젊은 부자』, 청림출판(2013),  p79~p80';

const advice6 = '"모든 일에 순서가 있듯, 돈을 모아 부자가 되는 데도 다 순서가 있는 것 같아. '
    '\n그동안 빨리 모으려고만 했지 순서 같은 건 신경도 안 썼거든." \n\n'
    '"그래서 지금부터 재테크 판을 다시 짤 거야. 순서에 맞게 말이야"';
const source6 = '박종기, 『젊은 부자』, 청림출판(2013),  p99';

const advice7 = '"만약 매달 150만 원씩 저축을 할 수 없는 경우라면 어떻게 해야 하나요?"'
    '\n\n허 대리가 자신 없는 목소리로 얘기했다.'
    '\n\n"둘 중 하나에요. 소득을 올리든지 아니면 지출을 더 줄이든지. \n그렇게 하지 않는다면 재테크는 할 필요가 없는 거에요."'
    '\n\n"재테크를 하는 목적이 돈으로 인생을 바꾸는 것인데 이를 위해 150만 원을 저축할 수 없다면 재테크를 할 필요가 없겠지요.'
    '평생 돈에 시달리며 살 수밖에 없을 거에요"';
const source7 = '박종기, 『젊은 부자』, 청림출판(2013),  p115';

const advice8 = '"파이프라인을 만들기 위해 매달 시간과 돈을 썼더니 자신도 알지 못했던 재능을 찾아낼 수 있었고, '
    '\n\n이를 수입으로 연결시킨 결과 지금과 같은 부를 쌓을 수 있었던 거야. '
    '\n\n내 자신에게 시간과 돈을 투자하는 자기계발만이 추가 소득을 위한 가장 현명한 길이라고 생각하네"';
const source8 = '박종기, 『젊은 부자』, 청림출판(2013),  p166';

const advice9 = '"나 자신에게 투자해 수입을 올리는 거지. 하지만 이것은 막연한 자기계발하고는 달라. '
    '\n\n대부분 자기계발 한답시고 운동하고 책 읽고 영어 공부하지만 그런 것은 특별한 목적이 없다고 할 수 있어. '
    '\n\n운동하니까 건강해지고 책을 읽으니까 견문이 넓어지고 그리고 영어를 배우니까 영어 실력이 나아질 뿐이지. '
    '\n\n내가 말하는 파이프라인은 목적이 분명해. 오로지 \'추가소득\'을 만들어내기 위한 것이지. 추가소득을 위한 자기계발이라고 볼 수 있어"';
const source9 = '박종기, 『젊은 부자』, 청림출판(2013),  p159';

const advice10 = '"쓸 거 다 쓰고, 놀 거 다 놀고, \n할 거 다 하면서 부자가 된 사람은 \n아무도 없습니다"';
const source10 = '박종기, 『젊은 부자』, 청림출판(2013),  p74';

