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

class ResultMegaView extends StatefulWidget {
  const ResultMegaView({Key? key}) : super(key: key);

  @override
  State<ResultMegaView> createState() => _ResultMegaViewState();
}

class _ResultMegaViewState extends State<ResultMegaView> {
  final ResultController _con = ResultController();

  List<DrawResultResponse>? results;
  List<DrawResultResponse>? resultsView;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getResultMega();
    });
  }

  getResultMega() async {
    DrawResultRequest req = DrawResultRequest();
    req.isVietlott = "Y";
    req.productID = 1;

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
        title: const Text("Kết quả Mega 6/45"),
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
                          if (index == 0) ballFirst(item) else ballNormal(item),
                          const SizedBox(
                            height: 8,
                          ),
                          buidJackpot(item),
                          const SizedBox(
                            height: 8,
                          ),
                          buildTable(item),
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

Widget buidJackpot(DrawResultResponse item) {
  return Column(
    children: [
      textLableJackpot("Giá trị Jackpot"),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.yellow, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: textValueJackpot(formatAmount(item.jackpot1!)),
      )
    ],
  );
}

Widget buildTable(DrawResultResponse item) {
  return Container(
    decoration: BoxDecoration(
        color: ColorLot.ColorBackgroundMega,
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
        border: TableBorder.all(color: Colors.white),
        children: [
          TableRow(children: [
            textLableTableBold("Giải", Colors.white),
            textLableTableBold("Trùng", Colors.white),
            textLableTableBold("Số lượng", Colors.white),
            textLableTableBold("Giá trị", Colors.white),
          ]),
          TableRow(children: [
            textLableTable("Jackpot", Colors.white),
            textLableTableCenter("6 số", Colors.white),
            textLableTableRight(
                item.numberOfJackpot1!.toString(), Colors.white),
            textLableTableRight(formatAmount(item.jackpot1), Colors.white),
          ]),
          TableRow(children: [
            textLableTable("Giải nhất", Colors.white),
            textLableTableCenter("5 số", Colors.white),
            textLableTableRight(formatAmount(item.numberOf01!), Colors.white),
            textLableTableRight(formatAmount(10000000), Colors.white),
          ]),
          TableRow(children: [
            textLableTable("Giải nhì", Colors.white),
            textLableTableCenter("4 số", Colors.white),
            textLableTableRight(formatAmount(item.numberOf02!), Colors.white),
            textLableTableRight(formatAmount(300000), Colors.white),
          ]),
          TableRow(children: [
            textLableTable("Giải ba", Colors.white),
            textLableTableCenter("3 số", Colors.white),
            textLableTableRight(formatAmount(item.numberOf03!), Colors.white),
            textLableTableRight(formatAmount(30000), Colors.white),
          ])
        ]),
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
                      fontSize: 16,
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
                    fontSize: 16,
                    color: Colors.white)),
          ),
        );
      }).toList());
}
