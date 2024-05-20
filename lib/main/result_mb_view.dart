// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lott_flutter_application/utils/box_shadow.dart';
import '../../utils/common.dart';
import '../controller/result_controller.dart';
import '../model/response/get_result_lotomb_response.dart';
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

  List<GetResultLotoMBResponse>? results;

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
    ResponseObject res = await _con.getResultMB();
    if (mounted) Navigator.of(context).pop();
    if (res.code == "00") {
      setState(() {
        results = List<GetResultLotoMBResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultLotoMBResponse.fromJson(model))));
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
    );
  }

  Widget buidView() {
    if (results != null) {
      var size = MediaQuery.of(context).size;
      return Container(
          color: ColorLot.ColorBackground,
          child: Row(children: <Widget>[
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: results!.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      GetResultLotoMBResponse item = results![index];
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
                                          "${getDayOfWeekVi(DateFormat('EEEE').format(DateFormat("dd/MM/yyyy").parse(item.drawDate!)))} - ${item.drawDate}",
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
                          ],
                        ),
                      );
                    }))
          ]));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildTextResult(String value, double fontSize, Color color) {
    return Text(
      value,
      style: TextStyle(
          fontSize: fontSize, color: color, fontWeight: FontWeight.w600),
    );
  }
}
