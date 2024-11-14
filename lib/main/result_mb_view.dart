// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lott_flutter_application/model/request/draw_result_request.dart';
import 'package:lott_flutter_application/model/response/draw_result_response.dart';
import 'package:lott_flutter_application/utils/dialog_search_mb.dart';
import 'package:lott_flutter_application/utils/widget_text.dart';
import '../../utils/common.dart';
import '../controller/result_controller.dart';
import '../model/response/response_object.dart';
import '../utils/color.dart';
import '../utils/dialog_process.dart';

class ResultMienBacView extends StatefulWidget {
  const ResultMienBacView({
    Key? key,
  }) : super(key: key);

  @override
  State<ResultMienBacView> createState() => _ResultMienBacViewState();
}

class _ResultMienBacViewState extends State<ResultMienBacView> {
  final ResultController _con = ResultController();

  List<DrawResultResponse>? results;
  List<DrawResultResponse>? resultsView;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getResultMB();
    });
  }

  getResultMB() async {
    if (mounted) {
      showProcess(context);
    }
    DrawResultRequest req = DrawResultRequest();
    req.area = 1;
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

  filterDate(int drawCode) {
    resultsView = results!
        .where(
          (element) => element.drawDate! == drawCode,
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
        title: const Text("Kết quả xổ số Miền Bắc "),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: buidView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialogSearchMB(context, "Chọn ngày xổ", results ?? [], filterDate);
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
      var size = MediaQuery.of(context).size;
      return Container(
          color: ColorLot.ColorBackground,
          child: Row(children: <Widget>[
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: resultsView!.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      DrawResultResponse item = resultsView![index];
                      String drawDate =
                          "${item.drawDate!.toString().substring(6)}/${item.drawDate!.toString().substring(4, 6)}/${item.drawDate!.toString().substring(0, 4)}";
                      return Container(
                        decoration: BoxDecoration(color: Colors.white),
                        margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Table(
                              columnWidths: const <int, TableColumnWidth>{
                                0: FixedColumnWidth(80),
                                1: FlexColumnWidth(),
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              border: TableBorder.all(color: Colors.black12),
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text("Ký hiệu",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${getDayOfWeekVi(DateFormat('EEEE').format(DateFormat("dd/MM/yyyy").parse(drawDate)))} - $drawDate",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          item.symbols!,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        "Đặc biệt",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Center(
                                      child: _buildTextResult(
                                          item.result!, 20, Colors.red),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text("Giải nhất",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                    ),
                                    Center(
                                      child: _buildTextResult(
                                          item.result01!, 16, Colors.black),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text("Giải nhì",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            item.result02!.split(',').map((e) {
                                          return Expanded(
                                              child: Center(
                                            child: _buildTextResult(
                                                e, 16, Colors.black),
                                          ));
                                        }).toList())
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text("Giải ba",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Wrap(
                                          children: item.result03!
                                              .split(',')
                                              .map((e) {
                                        return SizedBox(
                                          width: (size.width - 120) / 3,
                                          height: 30,
                                          child: Center(
                                            child: _buildTextResult(
                                                e, 16, Colors.black),
                                          ),
                                        );
                                      }).toList()),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text("Giải tư",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Wrap(
                                          children: item.result04!
                                              .split(',')
                                              .map((e) {
                                        return SizedBox(
                                          width: (size.width - 120) / 4,
                                          height: 30,
                                          child: Center(
                                            child: _buildTextResult(
                                                e, 16, Colors.black),
                                          ),
                                        );
                                      }).toList()),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text("Giải năm",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Wrap(
                                          children: item.result05!
                                              .split(',')
                                              .map((e) {
                                        return SizedBox(
                                          width: (size.width - 120) / 3,
                                          height: 30,
                                          child: Center(
                                            child: _buildTextResult(
                                                e, 16, Colors.black),
                                          ),
                                        );
                                      }).toList()),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text("Giải sáu",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Wrap(
                                          children: item.result06!
                                              .split(',')
                                              .map((e) {
                                        return SizedBox(
                                          width: (size.width - 120) / 3,
                                          height: 30,
                                          child: Center(
                                            child: _buildTextResult(
                                                e, 16, Colors.black),
                                          ),
                                        );
                                      }).toList()),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text("Giải bảy",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Wrap(
                                          children: item.result07!
                                              .split(',')
                                              .map((e) {
                                        return SizedBox(
                                          width: (size.width - 120) / 4,
                                          height: 30,
                                          child: Center(
                                            child: _buildTextResult(
                                                e, 16, Colors.blue.shade900),
                                          ),
                                        );
                                      }).toList()),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                  color: ColorLot.ColorBackgroundMB),
                              child: Text(
                                "Lô tô ${item.radioName}, ${getDayOfWeekVi(DateFormat('EEEE').format(DateFormat("dd/MM/yyyy").parse(drawDate)))} - $drawDate",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            buildLoto(item)
                          ],
                        ),
                      );
                    }))
          ]));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildLoto(DrawResultResponse item) {
    if (resultsView != null) {
      List<String> resultLotos = [];
      String db = item.result!.substring(item.result!.length - 2);
      item.result07!.split(',').forEach(
        (element) {
          resultLotos.add(element.substring(element.length - 2));
        },
      );
      item.result06!.split(',').forEach(
        (element) {
          resultLotos.add(element.substring(element.length - 2));
        },
      );
      item.result05!.split(',').forEach(
        (element) {
          resultLotos.add(element.substring(element.length - 2));
        },
      );
      item.result04!.split(',').forEach(
        (element) {
          resultLotos.add(element.substring(element.length - 2));
        },
      );
      item.result03!.split(',').forEach(
        (element) {
          resultLotos.add(element.substring(element.length - 2));
        },
      );
      item.result02!.split(',').forEach(
        (element) {
          resultLotos.add(element.substring(element.length - 2));
        },
      );
      item.result01!.split(',').forEach(
        (element) {
          resultLotos.add(element.substring(element.length - 2));
        },
      );
      resultLotos.add(db);

      var dau0 =
          resultLotos.where((element) => element.startsWith("0")).toList();
      dau0.sort(((a, b) => a.compareTo(b)));
      var duoi0 =
          resultLotos.where((element) => element.endsWith("0")).toList();
      duoi0.sort(((a, b) => a.compareTo(b)));

      var dau1 =
          resultLotos.where((element) => element.startsWith("1")).toList();
      var duoi1 =
          resultLotos.where((element) => element.endsWith("1")).toList();

      var dau2 =
          resultLotos.where((element) => element.startsWith("2")).toList();
      var duoi2 =
          resultLotos.where((element) => element.endsWith("2")).toList();

      var dau3 =
          resultLotos.where((element) => element.startsWith("3")).toList();
      var duoi3 =
          resultLotos.where((element) => element.endsWith("3")).toList();

      var dau4 =
          resultLotos.where((element) => element.startsWith("4")).toList();
      var duoi4 =
          resultLotos.where((element) => element.endsWith("4")).toList();

      var dau5 =
          resultLotos.where((element) => element.startsWith("5")).toList();
      var duoi5 =
          resultLotos.where((element) => element.endsWith("5")).toList();

      var dau6 =
          resultLotos.where((element) => element.startsWith("6")).toList();
      var duoi6 =
          resultLotos.where((element) => element.endsWith("6")).toList();

      var dau7 =
          resultLotos.where((element) => element.startsWith("7")).toList();
      var duoi7 =
          resultLotos.where((element) => element.endsWith("7")).toList();

      var dau8 =
          resultLotos.where((element) => element.startsWith("8")).toList();
      var duoi8 =
          resultLotos.where((element) => element.endsWith("8")).toList();

      var dau9 =
          resultLotos.where((element) => element.startsWith("9")).toList();
      var duoi9 =
          resultLotos.where((element) => element.endsWith("9")).toList();

      dau1.sort(((a, b) => a.compareTo(b)));
      dau2.sort(((a, b) => a.compareTo(b)));
      dau3.sort(((a, b) => a.compareTo(b)));
      dau4.sort(((a, b) => a.compareTo(b)));
      dau5.sort(((a, b) => a.compareTo(b)));
      dau6.sort(((a, b) => a.compareTo(b)));
      dau7.sort(((a, b) => a.compareTo(b)));
      dau8.sort(((a, b) => a.compareTo(b)));
      dau9.sort(((a, b) => a.compareTo(b)));

      duoi1.sort(((a, b) => a.compareTo(b)));
      duoi2.sort(((a, b) => a.compareTo(b)));
      duoi3.sort(((a, b) => a.compareTo(b)));
      duoi4.sort(((a, b) => a.compareTo(b)));
      duoi5.sort(((a, b) => a.compareTo(b)));
      duoi6.sort(((a, b) => a.compareTo(b)));
      duoi7.sort(((a, b) => a.compareTo(b)));
      duoi8.sort(((a, b) => a.compareTo(b)));
      duoi9.sort(((a, b) => a.compareTo(b)));

      return Container(
        decoration: BoxDecoration(
          color: ColorLot.ColorBackgroundMB,
        ),
        padding: EdgeInsets.all(4),
        child: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(40),
              2: FixedColumnWidth(40),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(color: Colors.white),
            children: [
              TableRow(children: [
                textLableTableBold("Đầu", Colors.white),
                textLableTableBold("Lô tô", Colors.white),
                textLableTableBold("Đuôi", Colors.white),
                textLableTableBold("Lô tô", Colors.white),
              ]),
              TableRow(children: [
                textLableTableCenter("0", Colors.white),
                textLableTable(dau0.join(" "), Colors.white),
                textLableTableCenter("0", Colors.white),
                textLableTable(duoi0.join(" "), Colors.white),
              ]),
              TableRow(children: [
                textLableTableCenter("1", Colors.white),
                textLableTable(dau1.join(" "), Colors.white),
                textLableTableCenter("1", Colors.white),
                textLableTable(duoi1.join(" "), Colors.white),
              ]),
              TableRow(children: [
                textLableTableCenter("2", Colors.white),
                textLableTable(dau2.join(" "), Colors.white),
                textLableTableCenter("2", Colors.white),
                textLableTable(duoi2.join(" "), Colors.white),
              ]),
              TableRow(children: [
                textLableTableCenter("3", Colors.white),
                textLableTable(dau3.join(" "), Colors.white),
                textLableTableCenter("3", Colors.white),
                textLableTable(duoi3.join(" "), Colors.white),
              ]),
              TableRow(children: [
                textLableTableCenter("4", Colors.white),
                textLableTable(dau4.join(" "), Colors.white),
                textLableTableCenter("4", Colors.white),
                textLableTable(duoi4.join(" "), Colors.white),
              ]),
              TableRow(children: [
                textLableTableCenter("5", Colors.white),
                textLableTable(dau5.join(" "), Colors.white),
                textLableTableCenter("5", Colors.white),
                textLableTable(duoi5.join(" "), Colors.white),
              ]),
              TableRow(children: [
                textLableTableCenter("6", Colors.white),
                textLableTable(dau6.join(" "), Colors.white),
                textLableTableCenter("6", Colors.white),
                textLableTable(duoi6.join(" "), Colors.white),
              ]),
              TableRow(children: [
                textLableTableCenter("7", Colors.white),
                textLableTable(dau7.join(" "), Colors.white),
                textLableTableCenter("7", Colors.white),
                textLableTable(duoi7.join(" "), Colors.white),
              ]),
              TableRow(children: [
                textLableTableCenter("8", Colors.white),
                textLableTable(dau8.join(" "), Colors.white),
                textLableTableCenter("8", Colors.white),
                textLableTable(duoi8.join(" "), Colors.white),
              ]),
              TableRow(children: [
                textLableTableCenter("9", Colors.white),
                textLableTable(dau9.join(" "), Colors.white),
                textLableTableCenter("9", Colors.white),
                textLableTable(duoi9.join(" "), Colors.white),
              ]),
            ]),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildTextResult(String value, double fontSize, Color color) {
    return Text(
      value,
      style: TextStyle(
          fontSize: fontSize, color: color, fontWeight: FontWeight.w600),
    );
  }
}
