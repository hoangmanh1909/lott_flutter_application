// ignore_for_file: unnecessary_new, use_build_context_synchronously, prefer_const_constructors, must_be_immutable, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lott_flutter_application/utils/common.dart';
import 'package:lott_flutter_application/utils/dialog_process.dart';
import '../controller/result_controller.dart';
import '../model/response/get_result_keno_response.dart';
import '../model/response/response_object.dart';

class ResultKenoView extends StatefulWidget {
  const ResultKenoView({Key? key}) : super(key: key);
  @override
  State<ResultKenoView> createState() => _ResultKenoViewState();
}

class _ResultKenoViewState extends State<ResultKenoView> {
  final ResultController _con = ResultController();

  List<GetResultKenoResponse>? resultKenos;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getResultKeno();
    });
  }

  getResultKeno() async {
    if (mounted) {
      showProcess(context);
    }
    ResponseObject res = await _con.getResultKeno();
    if (mounted) Navigator.of(context).pop();
    if (res.code == "00") {
      setState(() {
        resultKenos = List<GetResultKenoResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultKenoResponse.fromJson(model))));
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
        title: const Text("Kết quả Keno"),
      ),
      body: buidView(),
    );
  }

  Widget buidView() {
    if (resultKenos != null) {
      return Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: resultKenos!.length,
              itemBuilder: (BuildContext ctxt, int index) {
                GetResultKenoResponse item = resultKenos![index];
                String drawTime = item.drawTime!.padLeft(6, '0');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kỳ #${item.drawCode}",
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                          Text(
                            "${getDayOfWeekVi((DateFormat('EEEE').format(DateFormat("dd/MM/yyyy").parse(item.drawDate!))))} - ${drawTime.substring(0, 2)}:${drawTime.substring(2, 4)} - ${item.drawDate}",
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                        ],
                      ),
                    ),
                    if (index == 0) ballFirst(item) else ballNormal(item),
                    SizedBox(
                      height: 4,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      item.even! > 10
                          ? bigSmallActive("Chắn (${item.even})", Colors.blue)
                          : bigSmall("Chắn (${item.even})"),
                      item.even! == 11 || item.even == 12
                          ? bigSmallActive("Chẵn 11-12", Colors.blue)
                          : bigSmall("Chẵn 11-12"),
                      item.even! == 10
                          ? bigSmallActive("Hòa CL", Colors.blue)
                          : bigSmall("Hòa CL"),
                      item.odd! == 11 || item.odd == 12
                          ? bigSmallActive("Lẻ 11-12", Colors.blue)
                          : bigSmall("Lẻ 11-12"),
                      item.odd! == 10
                          ? bigSmallActive("Lẻ (${item.odd})", Colors.blue)
                          : bigSmall("Lẻ (${item.odd})"),
                    ]),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      item.big! > 10
                          ? bigSmallActive("Lớn (${item.big})", Colors.red)
                          : bigSmall("Lớn (${item.big})"),
                      item.big! == 10
                          ? bigSmallActive("Hòa lớn nhỏ", Colors.red)
                          : bigSmall("Hòa lớn nhỏ"),
                      item.small! > 10
                          ? bigSmallActive("Nhỏ (${item.small})", Colors.red)
                          : bigSmall("Nhỏ (${item.small})"),
                    ]),
                    const SizedBox(
                      height: 6,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey[200],
                    ),
                  ],
                );
              }));
    } else {
      return SizedBox.shrink();
    }
  }
}

Widget ballNormal(GetResultKenoResponse item) {
  List<String> drawResults = item.result!.split(',');

  return SizedBox(
      width: 350,
      child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: drawResults.map((item) {
            return Container(
              width: 28,
              height: 28,
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 1)),
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Text(item,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        fontSize: 13,
                        letterSpacing: 0.0,
                      )),
                ),
              ),
            );
          }).toList()));
}

Widget ballFirst(GetResultKenoResponse item) {
  List<String> drawResults = item.result!.split(',');

  return SizedBox(
      width: 350,
      child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: drawResults.map((item) {
            return Container(
              width: 28,
              height: 28,
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  border: Border.all(color: Colors.red, width: 1)),
              child: InkWell(
                onTap: () {},
                child: Center(
                    child: Text(item,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            letterSpacing: 0.0,
                            color: Colors.white))),
              ),
            );
          }).toList()));
}

Widget bigSmall(item) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
    margin: EdgeInsets.all(2),
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.blue.shade900, width: 1)),
    child: InkWell(
      onTap: () {},
      child: Text(item,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 0.0,
            color: Colors.blue[900],
          )),
    ),
  );
}

Widget bigSmallActive(item, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
    margin: EdgeInsets.all(2),
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1)),
    child: InkWell(
      onTap: () {},
      child: Text(item,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 12, letterSpacing: 0.0, color: Colors.white)),
    ),
  );
}
