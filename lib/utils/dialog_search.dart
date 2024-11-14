// ignore_for_file: prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lott_flutter_application/model/response/draw_result_response.dart';
import 'package:lott_flutter_application/utils/color.dart';
import 'package:lott_flutter_application/utils/dimen.dart';

dialogSearch(BuildContext context, String title, List<DrawResultResponse> draws,
    Function filterDate) {
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
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: draws.map((e) {
                      String drawDate =
                          "${e.drawDate!.toString().substring(6)}/${e.drawDate!.toString().substring(4, 6)}/${e.drawDate!.toString().substring(0, 4)}";
                      return InkWell(
                        onTap: () {
                          filterDate(e.drawCode!);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(6),
                          margin: EdgeInsets.all(2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.black12)),
                          child: Text("${e.drawCode} - $drawDate"),
                        ),
                      );
                    }).toList()))),
        actions: [
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
                            border: Border.all(
                                color: ColorLot.ColorPrimary, width: 1)),
                        child: Text("Đóng",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ))),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        filterDate("1");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: Dimen.buttonHeight,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimen.radiusBorderButton)),
                            color: Colors.blue,
                            border: Border.all(color: Colors.blue, width: 1)),
                        child: Text("Hiển thị cả",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ))),
            ],
          )
        ],
      );
    },
  );
}
