import 'package:flutter/material.dart';

import '../data/category.dart';

class SelectCategoryWidget extends StatefulWidget {
  final TextEditingController categoryController;

  const SelectCategoryWidget({super.key, required this.categoryController});

  @override
  State<SelectCategoryWidget> createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  String inputText='';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                widget.categoryController.text = category1;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
              ),
              child: Text(
                category1,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category2;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
              ),
              child: Text(
                category2,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category3;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
              ),
              child: Text(
                category3,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category4;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
              ),
              child: Text(
                category4,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                widget.categoryController.text = category5;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
              ),
              child: Text(
                category5,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category6;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
              ),
              child: Text(
                category6,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category7;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
              ),
              child: Text(
                category7,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category8;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
              ),
              child: Text(
                category8,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                widget.categoryController.text = category9;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
              ),
              child: Text(
                category9,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category10;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
              ),
              child: Text(
                category10,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category11;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
              ),
              child: Text(
                category11,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category12;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
              ),
              child: Text(
                category12,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                widget.categoryController.text = category13;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
              ),
              child: Text(
                category13,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category14;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
              ),
              child: Text(
                category14,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category15;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
              ),
              child: Text(
                category15,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category16;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
              ),
              child: Text(
                category16,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                widget.categoryController.text = category17;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
              ),
              child: Text(
                category17,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category18;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
              ),
              child: Text(
                category18,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category19;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange.shade100),
              ),
              child: Text(
                category19,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.categoryController.text = category20;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade100),
              ),
              child: Text(
                category20,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Yeongdeok-Sea",
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }


}
