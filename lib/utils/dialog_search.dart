// ignore_for_file: prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lott_flutter_application/utils/color.dart';
import 'package:lott_flutter_application/utils/dimen.dart';

dialogSearch(BuildContext context, String title) {
  TextEditingController fromDate = TextEditingController();
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        surfaceTintColor: Colors.transparent,
        titlePadding: EdgeInsets.all(10),
        contentPadding: EdgeInsets.all(10),
        actionsPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16)),
        content: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(Dimen.padingDefault),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimen.radiusBorderButton)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                children: [
                  Text("Từ ngày"),
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: fromDate,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        floatingLabelStyle:
                            TextStyle(color: ColorLot.ColorPrimary),
                        counterText: "",
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorLot.ColorPrimary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorLot.ColorPrimary),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ])),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: Container(
                    alignment: Alignment.center,
                    height: Dimen.buttonHeight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimen.radiusBorderButton)),
                        color: Colors.red,
                        border:
                            Border.all(color: ColorLot.ColorPrimary, width: 1)),
                    child: Text("Đóng",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: InkWell(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: Dimen.buttonHeight,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimen.radiusBorderButton)),
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue, width: 1)),
                  child: Text(
                    "Tìm kiếm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
            ],
          )
        ],
      );
    },
  );
}
