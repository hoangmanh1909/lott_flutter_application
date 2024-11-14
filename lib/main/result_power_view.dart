// ignore_for_file: must_be_immutable, prefer_const_constructors, duplicate_ignore

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lott_flutter_application/controller/result_controller.dart';
import 'package:lott_flutter_application/model/request/draw_result_request.dart';
import 'package:lott_flutter_application/model/response/draw_result_response.dart';
import 'package:lott_flutter_application/model/response/response_object.dart';
import 'package:lott_flutter_application/utils/dialog_process.dart';
import 'package:lott_flutter_application/utils/dialog_search.dart';
import 'package:lott_flutter_application/utils/widget_text.dart';
import '../../utils/common.dart';
import '../utils/color.dart';

class ResultPowerView extends StatefulWidget {
  const ResultPowerView({Key? key}) : super(key: key);

  @override
  State<ResultPowerView> createState() => _ResultPowerViewState();
}

class _ResultPowerViewState extends State<ResultPowerView> {
  final ResultController _con = ResultController();

  List<DrawResultResponse>? results;
  List<DrawResultResponse>? resultsView;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getResultPower();
    });
  }

  getResultPower() async {
    DrawResultRequest req = DrawResultRequest();
    req.isVietlott = "Y";
    req.productID = 2;

    if (mounted) {
      showProcess(context);
    }
    ResponseObject res = await _con.getDrawResult(req);
    if (mounted) Navigator.of(context).pop();
    if (res.code == "00") {
      results = List<DrawResultResponse>.from((jsonDecode(res.data!)
          .map((model) => DrawResultResponse.fromJson(model))));
      resultsView = List<DrawResultResponse>.from((jsonDecode(res.data!)
          .map((model) => DrawResultResponse.fromJson(model))));
      setState(() {});
    }
  }

  filterDate(String drawCode) {
    resultsView = results!
        .where(
          (element) => element.drawCode! == drawCode,
        )
        .toList();
    if (resultsView!.isEmpty) {
      resultsView = List<DrawResultResponse>.from(
          (jsonDecode(jsonEncode(results))
              .map((model) => DrawResultResponse.fromJson(model))));
    }
    setState(() {});
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        title: const Text("Kết quả Power 6/55"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: buidView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialogSearch(context, "Chọn ngày xổ", results ?? [], filterDate);
        },
        shape: CircleBorder(),
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.calendar_month_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buidView() {
    if (resultsView != null) {
      return Container(
          color: Colors.white,
          child: Row(children: <Widget>[
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: resultsView!.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      DrawResultResponse item = resultsView![index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: buildFooter(item),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (index == 0)
                                ballFirst(item)
                              else
                                ballNormal(item),
                              Container(
                                width: 30,
                                height: 30,
                                padding: const EdgeInsets.all(3),
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                    border: Border.all(
                                        color: Colors.orange, width: 1)),
                                child: InkWell(
                                  onTap: () {},
                                  child: Text(item.bonus.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          buidJackpot(item),
                          const SizedBox(
                            height: 8,
                          ),
                          buildTable(item)
                        ],
                      );
                    }))
          ]));
    } else {
      // ignore: prefer_const_constructors
      return SizedBox.shrink();
    }
  }
}

Widget buildTable(DrawResultResponse item) {
  return Container(
    decoration: BoxDecoration(
        color: ColorLot.ColorBackgroundPower,
        borderRadius: BorderRadius.all(Radius.circular(6))),
    margin: EdgeInsets.all(4),
    padding: EdgeInsets.all(4),
    child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(70),
          1: FixedColumnWidth(60),
          2: FixedColumnWidth(80),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: ColorLot.ColorPower),
        children: [
          TableRow(children: [
            textLableTableBold("Giải", Colors.black),
            textLableTableBold("Trùng", Colors.black),
            textLableTableBold("Số lượng", Colors.black),
            textLableTableBold("Giá trị", Colors.black),
          ]),
          TableRow(children: [
            textLableTable("Jackpot", Colors.black),
            textLableTableCenter("6 số", Colors.black),
            textLableTableRight(
                item.numberOfJackpot1!.toString(), Colors.black),
            textLableTableRight(formatAmount(item.jackpot1), Colors.black),
          ]),
          TableRow(children: [
            textLableTable("Giải nhất", Colors.black),
            textLableTableCenter("5 số", Colors.black),
            textLableTableRight(formatAmount(item.numberOf01!), Colors.black),
            textLableTableRight(formatAmount(10000000), Colors.black),
          ]),
          TableRow(children: [
            textLableTable("Giải nhì", Colors.black),
            textLableTableCenter("4 số", Colors.black),
            textLableTableRight(formatAmount(item.numberOf02!), Colors.black),
            textLableTableRight(formatAmount(300000), Colors.black),
          ]),
          TableRow(children: [
            textLableTable("Giải ba", Colors.black),
            textLableTableCenter("3 số", Colors.black),
            textLableTableRight(formatAmount(item.numberOf03!), Colors.black),
            textLableTableRight(formatAmount(30000), Colors.black),
          ])
        ]),
  );
}

Widget buidJackpot(DrawResultResponse item) {
  return Column(
    children: [
      textLableJackpot("Giá trị Jackpot 1"),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: ColorLot.ColorBackgroundPower,
            border: Border.all(color: ColorLot.ColorPower, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: textValueJackpotPower(formatAmount(item.jackpot1!)),
      ),
      SizedBox(
        height: 8,
      ),
      textLableJackpot("Giá trị Jackpot 2"),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: ColorLot.ColorBackgroundPower,
            border: Border.all(color: ColorLot.ColorPower, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: textValueJackpotPower(formatAmount(item.jackpot2!)),
      )
    ],
  );
}

Widget buildFooter(DrawResultResponse item) {
  String drawDate =
      "${item.drawDate!.toString().substring(6)}/${item.drawDate!.toString().substring(4, 6)}/${item.drawDate!.toString().substring(0, 4)}";
  DateTime tempDate = DateFormat("dd/MM/yyyy").parse(drawDate);

  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text("Kỳ quay #${item.drawCode}",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
    Text(
        "${getDayOfWeekVi(DateFormat('EEEE').format(tempDate))}, ${DateFormat('dd/MM/yyyy').format(tempDate)}",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600))
  ]);
}

Widget ballNormal(DrawResultResponse item) {
  List<String> drawResults = item.result!.split(',');

  return Wrap(
      direction: Axis.horizontal,
      children: drawResults.map(
        (item) {
          return Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
            child: InkWell(
              onTap: () {},
              child: Text(item,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                      letterSpacing: 0.0)),
            ),
          );
        },
      ).toList());
}

Widget ballFirst(DrawResultResponse item) {
  List<String> drawResults = item.result!.split(',');

  return Wrap(
      direction: Axis.horizontal,
      children: drawResults.map((item) {
        return Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(3),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorLot.ColorPrimary,
              border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
          child: InkWell(
            onTap: () {},
            child: Text(item,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.0,
                    color: Colors.white)),
          ),
        );
      }).toList());
}
