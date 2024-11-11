// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget textLableJackpot(String mes) {
  return Text(
    mes,
    style: TextStyle(color: Colors.black, fontSize: 14),
  );
}

Widget textValueJackpot(String mes) {
  return Text(
    mes,
    style: TextStyle(
        color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.w600),
  );
}

Widget textLableTable(String mes) {
  return Padding(
    padding: EdgeInsets.all(3),
    child: Text(
      mes,
      style: TextStyle(color: Colors.white, fontSize: 14),
    ),
  );
}

Widget textLableTableRight(String mes) {
  return Container(
    padding: EdgeInsets.all(3),
    alignment: Alignment.centerRight,
    child: Text(
      mes,
      style: TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}

Widget textLableTableCenter(String mes) {
  return Container(
    padding: EdgeInsets.all(3),
    alignment: Alignment.center,
    child: Text(
      mes,
      style: TextStyle(color: Colors.white, fontSize: 14),
    ),
  );
}

Widget textLableTableBold(String mes) {
  return Container(
    padding: EdgeInsets.all(2),
    alignment: Alignment.center,
    child: Text(
      mes,
      style: TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}
