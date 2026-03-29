//가계부 수정하는 화면

import 'package:abc_money_diary/models/diary_model.dart';
import 'package:abc_money_diary/repository/sql_diary_crud_repository.dart';
import 'package:abc_money_diary/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/money_text_field_widget.dart';
import '../../widgets/select_category_widget.dart';
import '../../widgets/select_payment_widget.dart';

class ModifyDiaryScreen extends StatefulWidget {
  final Diary diary;

  const ModifyDiaryScreen({super.key, required this.diary, });

  @override
  State<ModifyDiaryScreen> createState() => _ModifyDiaryScreenState();
}

class _ModifyDiaryScreenState extends State<ModifyDiaryScreen> {

  @override
  void initState() {
    isSelected = [aButton, bButton, cButton];
    super.initState();

    _categoryTextEditingController =
        TextEditingController(text: widget.diary.category);

    _moneyTextEditingController =
        TextEditingController(text: moneyToString(moneyToInt(widget.diary.money!)));

    _contentTextEditingController =
        TextEditingController(text: widget.diary.contents);

    _memoTextEditingController =
        TextEditingController(text: widget.diary.memo);

    _paymentTextEditingController = TextEditingController(text: widget.diary.payment);

    focusNode.addListener(() {
      setState(() {
        isMoneyFocused = focusNode.hasFocus;
      });
    });


  }

  void update() => setState(() {});

  //수정버튼 누르면 작동하는 곳
  void onTapModifyButton(Diary diary) async {
    if (moneyToCleanString(_moneyTextEditingController.text) == '0'|| moneyToCleanString(_moneyTextEditingController.text) == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('금액이 없습니다'),
          content: Text('저장하시겠습니까?'),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  var modifyDiary = diary.clone(
                    type: getABC(),
                    date: getToday(),
                    time: getTimeNow(),
                    money: moneyToCleanString(
                                _moneyTextEditingController.text) ==
                            ''
                        ? '0'
                        : moneyToCleanString(_moneyTextEditingController.text),
                    contents: _contentTextEditingController.text,
                    category: _categoryTextEditingController.text,
                    memo: _memoTextEditingController.text,
                    payment: _paymentTextEditingController.text,
                  );
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false);
                  await SqlDiaryCrudRepository.update(modifyDiary);
                  update();
                },
                child: Text('예')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('아니요')),
          ],
        ),
      );
    }

    else {
      var modifyDiary = diary.clone(
        type: getABC(),
        date: getToday(),
        time: getTimeNow(),
        money: moneyToCleanString(_moneyTextEditingController.text) == ''
            ? '0'
            : moneyToCleanString(_moneyTextEditingController.text),
        contents: _contentTextEditingController.text,
        category: _categoryTextEditingController.text,
        memo: _memoTextEditingController.text,
        payment: _paymentTextEditingController.text,
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false);
      await SqlDiaryCrudRepository.update(modifyDiary);
      update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //앱바 높이
        toolbarHeight: 50,
        //글자 색
        foregroundColor: Colors.orange,
        //앱 바 색
        backgroundColor: Colors.white,
        //앱 바 밑에 음영 사라지게 만드는 코드
        elevation: 1,
        //타이틀 왼쪽에 딱 붙이는 코드
        titleSpacing: 0,
        //타이틀 가운데로 정렬
        centerTitle: true,
        //뒤로가기 띄우는 코드
        automaticallyImplyLeading: false,

        title: Text(
          'ABC 가계부',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.orange,
            fontFamily: "Yeongdeok-Sea",
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20),
            onPressed: null,
            icon: Icon(
              Icons.help,
              size: 30,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //ABC 선택하는 부분
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(20),
                //선택한 버튼의 테두리 색
                selectedBorderColor: Colors.orange,
                //테두리 색
                borderColor: Colors.orange,
                //선택한 버튼의 배경색
                fillColor: Colors.orange,
                //기본 버튼들의 글자색
                color: Colors.orange,
                //선택한 버튼의 글자색
                selectedColor: Colors.white,
                //터치 이펙트 색
                splashColor: Colors.white30,
                isSelected: isSelected,
                onPressed: onTapToggleButton,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: Text(
                      'A',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Yeongdeok-Sea",
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: Text(
                      'B',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Yeongdeok-Sea",
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: Text(
                      'C',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Yeongdeok-Sea",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //날짜 선택하는 부분
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        '날짜',
                        style: TextStyle(
                          fontFamily: "HakgyoansimWoojuR",
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: Colors.grey),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      //날짜선택
                      TextButton(
                        onPressed: () => onTapDateButton(context),
                        child: Text(
                          getToday(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.brown,
                          ),
                        ),
                      ),

                      //시간선택
                      TextButton(
                        onPressed: () => onTapTimeButton(context),
                        child: Text(
                          getTimeNow(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),

            //금액 입력하는 부분
            AnimatedContainer(

              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
              height: isMoneyFocused ? 120 : 50,
              duration: const Duration(milliseconds: 300),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '금액',
                          style: TextStyle(
                            fontFamily: "HakgyoansimWoojuR",
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: Colors.grey),
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: MoneyTextField(
                                  controller: _moneyTextEditingController,
                                  focusNode: focusNode)),
                        ),
                      ],
                    ),
                    makeButtons(),
                  ],
                ),
              ),
            ),

            //결제 방법 선택하는 부분
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '결제 방법',
                    style: TextStyle(
                      fontFamily: "HakgyoansimWoojuR",
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: TextField(
                        onTap: _onTapPayment,
                        controller: _paymentTextEditingController,

                        canRequestFocus: false,
                        //키보드 안올라오게 만드는 거
                        keyboardType: TextInputType.none,

                        decoration: InputDecoration(
                          labelText: '결제 방법을 선택하세요',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(color: Colors.brown.shade200),
                          hintStyle: TextStyle(color: Colors.brown.shade200),

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
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //분류 선택하는 부분
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '분류',
                    style: TextStyle(
                      fontFamily: "HakgyoansimWoojuR",
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: TextField(
                        onTap: _onTapcategory,
                        controller: _categoryTextEditingController,

                        canRequestFocus: false,
                        //키보드 안올라오게 만드는 거
                        keyboardType: TextInputType.none,

                        decoration: InputDecoration(
                          labelText: '분류를 선택하세요',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(color: Colors.brown.shade200),
                          hintStyle: TextStyle(color: Colors.brown.shade200),

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
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //내용 입력하는 부분
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '내용',
                    style: TextStyle(
                      fontFamily: "HakgyoansimWoojuR",
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: TextField(
                        controller: _contentTextEditingController,
                        decoration: InputDecoration(
                          labelText: '내용을 입력하세요',
                          hintText: 'ex) 점심 값, 군것질...',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(color: Colors.brown.shade200),
                          hintStyle: TextStyle(color: Colors.brown.shade200),

                          //한 번에 내용 삭제 하는 아이콘(suffixIcon이 오른쪽)
                          suffixIcon: GestureDetector(
                            onTap: () => _contentTextEditingController.clear(),
                            child: Icon(
                              Icons.cancel,
                            ),
                          ),

                          isDense: true,

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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //필수 항목과 선택 항목 구분선
            Divider(
              height: 10,
              color: Colors.grey.shade300,
              thickness: 5
            ),

            //메모 입력하는 부분
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: TextField(
                      controller: _memoTextEditingController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: '메모',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.brown.shade200),

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
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //수정버튼
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () => onTapModifyButton(widget.diary),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  '수정하기',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            //화면 끝에 안 닿게 만들기 위한 공간
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  // ABC 선택 관련 변수
  String getABC() {
    if (ABC == '') {
      String preABC = widget.diary.type!;
      return preABC;
    }
    return ABC;
  }

  String ABC = '';
  bool aButton = false;
  bool bButton = false;
  bool cButton = false;
  late List<bool> isSelected;

  //ABC 버튼 선택
  void onTapToggleButton(index) {
    if (index == 0) {
      aButton = true;
      bButton = false;
      cButton = false;
      ABC = 'A';
    } else if (index == 1) {
      aButton = false;
      bButton = true;
      cButton = false;
      ABC = 'B';
    }
    if (index == 2) {
      aButton = false;
      bButton = false;
      cButton = true;
      ABC = 'C';
    }
    setState(() {
      isSelected = [aButton, bButton, cButton];
    });
  }

  //날짜 선택 관련 변수
  String selectedDate = '';

  // 기본 오늘 날짜 구하는 곳
  String getToday() {
    if (selectedDate == "") {
      String Today = widget.diary.date!;
      return Today;
    }
    return selectedDate;
  }

  // 날짜 클릭 시 선택 화면 나오게 만드는 곳
  Future onTapDateButton(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,

      //날짜 선택 부분의 색깔 등등 테마 설정부분
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.orange,
                onPrimary: Colors.white,
              ),
            ),
            child: child!);
      },
    );
    if (selected != null) {
      setState(() {
        selectedDate = (DateFormat('yyyy-MM-dd (E)', 'ko')).format(selected);
      });
    }
  }

  //시간 선택 관련 변수
  String selectedTime = "";

  // 기본 지금 시간 구하는 곳
  String getTimeNow() {
    if (selectedTime == "") {
      String NowTime = widget.diary.time!;
      return NowTime;
    }
    return selectedTime;
  }

  // 시간 클릭 시 선택 화면 나오게 만드는 곳
  Future onTapTimeButton(BuildContext context) async {
    TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
              primary: Colors.orange,
            )),
            child: child!);
      },
    );

    if (selected != null) {
      setState(() {
        if (selected.hour < 12 && selected.hour >= 10) {
          if (selected.minute < 10) {
            selectedTime = '오전 ${selected.hour}:0${selected.minute}';
          } else {
            selectedTime = '오전 ${selected.hour}:${selected.minute}';
          }
        } else if (selected.hour < 10) {
          if (selected.minute < 10) {
            selectedTime = '오전 0${selected.hour}:0${selected.minute}';
          } else {
            selectedTime = '오전 0${selected.hour}:${selected.minute}';
          }
        } else if (selected.hour == 0) {
          if (selected.minute < 10) {
            selectedTime = '오전 0${selected.hour}:0${selected.minute}';
          } else {
            selectedTime = '오전 0${selected.hour}:${selected.minute}';
          }
        } else {
          if (selected.minute < 10) {
            selectedTime = '오후 ${selected.hour}:0${selected.minute}';
          } else {
            selectedTime = '오후 ${selected.hour}:${selected.minute}';
          }
        }
      });
    }
  }

  //금액 부분 관련
  bool isMoneyFocused = false;
  FocusNode focusNode = FocusNode();

  void addMoney(int addVal) {
    if (_moneyTextEditingController.text == "") {
      _moneyTextEditingController.text = moneyToString(addVal);
    } else {
      int newVal =
          int.parse(_moneyTextEditingController.text.replaceAll(',', '')) +
              addVal;
      _moneyTextEditingController.text = moneyToString(newVal);
    }
  }

  Widget makeButtons() {
    return isMoneyFocused
        ? Column(
            children: [
              Row(
                children: [
                  CustomButton(
                    onTap: () {
                      addMoney(1000);
                    },
                    text: "+1천",
                  ),
                  CustomButton(
                    onTap: () {
                      addMoney(5000);
                    },
                    text: "+5천",
                  ),
                  CustomButton( onTap: () { addMoney(10000); }, text: "+1만",),
            CustomButton( onTap: () { addMoney(50000); }, text: "+5만",),
            CustomButton( onTap: () { addMoney(100000); }, text: "+10만",),
          ],
        )
      ],
    )
        : const SizedBox.shrink();
  }

  //money를 int 형식으로 바꿔주기
  int moneyToInt(String money){
    if(money == "") {
      money = "0";
    }
    int result = int.parse(money.replaceAll(',', ''));
    if(result>1000000000000) {
      result = 1000000000000;
    }
    return result;
  }

  //돈 입력 시 3자리마다 , 붙여주는 등 관련 설정
  String moneyToString(int money) => NumberFormat.decimalPattern('ko_KR').format(money);

  //돈 깔끔하게 숫자만 있게 만드는 거
  String moneyToCleanString(String money){
    String result = money.replaceAll(',', '');
    return result;
  }

  //분류 부분 컨트롤러
  late final TextEditingController _categoryTextEditingController;

  //금액 부분 컨트롤러
  late final TextEditingController _moneyTextEditingController;

  //내용 부분 컨트롤러
  late final TextEditingController _contentTextEditingController;

  //메모 부분 컨트롤러
  late final TextEditingController _memoTextEditingController;

  //결제 방법 부분 컨트롤러
  late final TextEditingController _paymentTextEditingController;

  void _onTapPayment() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
            height: 80,
            child: SelectPaymentWidget(paymentController: _paymentTextEditingController)
        );
      },
      barrierColor: Colors.transparent,
      backgroundColor: Colors.brown.shade400,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    ).then((value) => update());
  }

  void _onTapcategory() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: SelectCategoryWidget(
              categoryController: _categoryTextEditingController),
        );
      },
      barrierColor: Colors.transparent,
      backgroundColor: Colors.brown.shade400,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    ).then((value) => update());
  }

}
