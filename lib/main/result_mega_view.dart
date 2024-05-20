// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lott_flutter_application/controller/result_controller.dart';
import 'package:lott_flutter_application/model/response/response_object.dart';
import 'package:lott_flutter_application/utils/dialog_process.dart';
import '../../utils/common.dart';
import '../model/response/get_result_response.dart';
import '../utils/color.dart';

class ResultMegaView extends StatefulWidget {
  const ResultMegaView({Key? key}) : super(key: key);

  @override
  State<ResultMegaView> createState() => _ResultMegaViewState();
}

class _ResultMegaViewState extends State<ResultMegaView> {
  final ResultController _con = ResultController();

  List<GetResultResponse>? results;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getResultMega();
    });
  }

  getResultMega() async {
    if (mounted) {
      showProcess(context);
    }
    ResponseObject res = await _con.getResultMega();
    if (mounted) Navigator.of(context).pop();
    if (res.code == "00") {
      setState(() {
        results = List<GetResultResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultResponse.fromJson(model))));
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
        title: const Text("Kết quả Mega 6/45"),
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
                      GetResultResponse item = results![index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: buildFooter(item),
                          ),
                          if (index == 0) ballFirst(item) else ballNormal(item),
                          const SizedBox(
                            height: 8,
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey[200],
                          )
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

Widget buildFooter(GetResultResponse item) {
  DateTime tempDate = DateFormat("dd/MM/yyyy").parse(item.drawDate!);
  String date = item.drawDate!;
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text("Kỳ quay #${item.drawCode}",
        style: TextStyle(color: Colors.blue.shade900)),
    Text("${getDayOfWeekVi(DateFormat('EEEE').format(tempDate))}, $date",
        style: TextStyle(color: Colors.blue.shade900))
  ]);
}

Widget ballNormal(GetResultResponse item) {
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
                      color: Colors.blue,
                      letterSpacing: 0.0)),
            ),
          );
        },
      ).toList());
}

Widget ballFirst(GetResultResponse item) {
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
