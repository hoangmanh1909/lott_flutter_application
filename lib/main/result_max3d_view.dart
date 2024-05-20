// ignore_for_file: must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lott_flutter_application/utils/color.dart';

import '../../utils/common.dart';
import '../controller/result_controller.dart';
import '../model/response/get_result_max3d_response.dart';
import '../model/response/response_object.dart';
import '../utils/dialog_process.dart';
import '../utils/widget_divider.dart';

class ResultMax3DView extends StatefulWidget {
  const ResultMax3DView({Key? key}) : super(key: key);

  @override
  State<ResultMax3DView> createState() => _ResultMax3DViewState();
}

class _ResultMax3DViewState extends State<ResultMax3DView> {
  final ResultController _con = ResultController();

  List<GetResultMax3DResponse>? results;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getResultMax3D();
    });
  }

  getResultMax3D() async {
    if (mounted) {
      showProcess(context);
    }
    ResponseObject res = await _con.getResultMax3D();
    if (mounted) Navigator.of(context).pop();
    if (res.code == "00") {
      setState(() {
        results = List<GetResultMax3DResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultMax3DResponse.fromJson(model))));
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
        title: const Text("Kết quả Max 3D"),
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
      return Container(
          color: Colors.white,
          child: Row(children: <Widget>[
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: results!.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  GetResultMax3DResponse item = results![index];
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: buildFooter(item),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Giải đặc biệt",
                                style: TextStyle(color: Colors.blue.shade900)),
                            SizedBox(
                              height: 4,
                            ),
                            resultST(item),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Giải nhất",
                              style: TextStyle(color: Colors.blue.shade900),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            resultND(item),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Giải nhì",
                              style: TextStyle(color: Colors.blue.shade900),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            resultRD(item),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Giải ba",
                              style: TextStyle(color: Colors.blue.shade900),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            resultENC(item),
                          ],
                        ),
                        dividerLot(),
                      ]);
                },
              ),
            ),
          ]));
    } else {
      return SizedBox.shrink();
    }
  }
}

Widget buildFooter(GetResultMax3DResponse item) {
  DateTime tempDate = DateFormat("dd/MM/yyyy").parse(item.drawDate!);
  String date = item.drawDate!;
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text("Kỳ quay #${item.drawCode}",
        style: TextStyle(color: Colors.blue.shade900)),
    Text("${getDayOfWeekVi(DateFormat('EEEE').format(tempDate))}, $date",
        style: TextStyle(color: Colors.blue.shade900))
  ]);
}

Widget resultST(item) {
  List<String> drawResults = item.resultST!.split(',');
  List<String> list1 = drawResults[0].split('').map((char) => char).toList();
  List<String> list2 = drawResults[1].split('').map((char) => char).toList();

  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    _result(list1, ColorLot.ColorPrimary),
    SizedBox(
      width: 10,
    ),
    _result(list2, ColorLot.ColorPrimary)
  ]);
}

Widget resultST1(item) {
  List<String> drawResults = item.resultST!.split(',');
  List<String> list1 = drawResults[0].split('').map((char) => char).toList();
  List<String> list2 = drawResults[1].split('').map((char) => char).toList();

  return Row(children: [
    _result(list2, Colors.red),
    SizedBox(
      width: 10,
    ),
    _result(list1, Colors.red)
  ]);
}

Widget resultND(item) {
  List<String> drawResults = item.resultND!.split(',');
  List<String> list1 = drawResults[0].split('').map((char) => char).toList();
  List<String> list2 = drawResults[1].split('').map((char) => char).toList();
  List<String> list3 = drawResults[2].split('').map((char) => char).toList();
  List<String> list4 = drawResults[3].split('').map((char) => char).toList();

  return Wrap(
    children: [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _result(list1, Colors.red),
              SizedBox(
                width: 5,
              ),
              _result(list2, Colors.red),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _result(list3, Colors.red),
              SizedBox(
                width: 5,
              ),
              _result(list4, Colors.red),
            ],
          ),
        ],
      )
    ],
  );
}

Widget resultRD(item) {
  List<String> drawResults = item.resultRD!.split(',');
  List<String> list1 = drawResults[0].split('').map((char) => char).toList();
  List<String> list2 = drawResults[1].split('').map((char) => char).toList();
  List<String> list3 = drawResults[2].split('').map((char) => char).toList();
  List<String> list4 = drawResults[3].split('').map((char) => char).toList();
  List<String> list5 = drawResults[4].split('').map((char) => char).toList();
  List<String> list6 = drawResults[5].split('').map((char) => char).toList();
  return Wrap(
    children: [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _result(list1, Colors.purple),
              SizedBox(
                width: 5,
              ),
              _result(list2, Colors.purple),
              SizedBox(
                width: 5,
              ),
              _result(list3, Colors.purple),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _result(list4, Colors.purple),
              SizedBox(
                width: 5,
              ),
              _result(list5, Colors.purple),
              SizedBox(
                width: 5,
              ),
              _result(list6, Colors.purple),
            ],
          ),
        ],
      )
    ],
  );
}

Widget resultENC(item) {
  List<String> drawResults = item.resultENC!.split(',');
  List<String> list1 = drawResults[0].split('').map((char) => char).toList();
  List<String> list2 = drawResults[1].split('').map((char) => char).toList();
  List<String> list3 = drawResults[2].split('').map((char) => char).toList();
  List<String> list4 = drawResults[3].split('').map((char) => char).toList();
  List<String> list5 = drawResults[4].split('').map((char) => char).toList();
  List<String> list6 = drawResults[5].split('').map((char) => char).toList();
  List<String> list7 = drawResults[6].split('').map((char) => char).toList();
  List<String> list8 = drawResults[7].split('').map((char) => char).toList();
  return Wrap(
    children: [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _resultENC(list1),
              SizedBox(
                width: 5,
              ),
              _resultENC(list2),
              SizedBox(
                width: 5,
              ),
              _resultENC(list3),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _resultENC(list4),
              SizedBox(
                width: 5,
              ),
              _resultENC(list5),
              SizedBox(
                width: 5,
              ),
              _resultENC(list6),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _resultENC(list7),
              SizedBox(
                width: 5,
              ),
              _resultENC(list8),
            ],
          ),
        ],
      )
    ],
  );
}

Widget _result(List<String> list, Color color) {
  return Wrap(
      direction: Axis.horizontal,
      children: list.map((item) {
        return SizedBox(
            width: 30,
            height: 30,
            child: Container(
              margin: EdgeInsets.all(1),
              padding: EdgeInsets.all(1),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(color: color, width: 1)),
              child: InkWell(
                onTap: () {},
                child: Text(item,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.0,
                        color: Colors.white)),
              ),
            ));
      }).toList());
}

Widget _resultENC(List<String> list) {
  return Wrap(
      direction: Axis.horizontal,
      children: list.map((item) {
        return SizedBox(
            width: 30,
            height: 30,
            child: Container(
              margin: EdgeInsets.all(1),
              padding: EdgeInsets.all(1),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                  border: Border.all(color: Colors.orange, width: 1)),
              child: InkWell(
                onTap: () {},
                child: Text(item,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.0,
                        color: Colors.white)),
              ),
            ));
      }).toList());
}
