// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flip_board/flip_clock.dart';
import 'package:flutter/material.dart';
import 'package:lott_flutter_application/main/keno_view.dart';
import 'package:lott_flutter_application/model/response/params_response.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../controller/result_controller.dart';
import '../model/response/get_draw_keno_response.dart';
import '../model/response/get_result_keno_response.dart';
import '../model/response/response_object.dart';
import '../model/selected_item_model.dart';
import '../utils/color.dart';
import '../utils/dialog_process.dart';

class KenoLiveView extends StatefulWidget {
  const KenoLiveView({super.key});

  @override
  State<StatefulWidget> createState() => _KenoLiveView();
}

class _KenoLiveView extends State<KenoLiveView> {
  final ResultController _con = ResultController();

  List<GetResultKenoResponse>? resultKenos;
  GetDrawKenoResponse? drawKenoResponse;
  String drawCode = "#";
  int secondCountdown = 0;
  Timer? timer;
  String? urlLive;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  getData() async {
    if (mounted) {
      showProcess(context);
    }
    await getParams();
    await getResultKeno();
    if (mounted) Navigator.of(context).pop();
  }

  getParams() async {
    ResponseObject res = await _con.getPrams();

    if (res.code == "00") {
      List<ParamsResponse> params = List<ParamsResponse>.from(
          (jsonDecode(res.data!)
              .map((model) => ParamsResponse.fromJson(model))));
      ParamsResponse p =
          params.where((element) => element.parameter == "KENO_LIVE_URL").first;
      urlLive = p.value;
    }
  }

  getResultKeno() async {
    ResponseObject res = await _con.getResultKeno();

    if (res.code == "00") {
      setState(() {
        resultKenos = List<GetResultKenoResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultKenoResponse.fromJson(model))));
        setState(() {});
      });
    }
  }

  Widget buildWebview() {
    if (urlLive == null) {
      return SizedBox.shrink();
    }
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(urlLive!));
    var size = MediaQuery.of(context).size.width - 16;
    return SizedBox(
      width: size,
      height: size / 2,
      child: WebViewWidget(controller: controller),
    );
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
          title: const Text("Trực tiếp Keno"),
        ),
        body: SingleChildScrollView(
          child: Container(
              color: ColorLot.ColorBackground,
              margin: EdgeInsets.only(top: 8),
              child: Column(
                children: [buildWebview(), buildResultFirst(), buildGeneral()],
              )),
        ));
  }

  Widget buildResultFirst() {
    if (resultKenos != null) {
      GetResultKenoResponse item = resultKenos![0];
      return Container(
          height: 180,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.75))
            ],
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Kết quả kỳ quay #${item.drawCode}",
                  style: TextStyle(color: Colors.blue.shade900),
                ),
              ),
              ballFirst(item),
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
            ],
          ));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildGeneral() {
    if (resultKenos != null) {
      List<String> results = [];
      for (int i = 0; i < resultKenos!.length; i++) {
        results.addAll(resultKenos![i].result!.split(','));
      }
      List<SelectItemModel> items = [];
      for (int i = 1; i <= 80; i++) {
        SelectItemModel item = SelectItemModel();
        item.text = i.toString().padLeft(2, '0');
        item.iValue = results
            .where((element) => element == i.toString().padLeft(2, '0'))
            .length;
        items.add(item);
      }
      items.sort((a, b) => b.iValue!.compareTo(a.iValue!));
      return Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.75))
            ],
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Thống kê các kỳ xổ gần nhất",
                  style: TextStyle(color: Colors.blue.shade900),
                ),
              ),
              buildBall(items)
            ],
          ));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildBall(List<SelectItemModel> items) {
    return Wrap(
        alignment: WrapAlignment.center,
        children: items.map((e) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    border: Border.all(color: Colors.blue, width: 1)),
                child: InkWell(
                  onTap: () {},
                  child: Center(
                      child: Text(e.text!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              letterSpacing: 0.0,
                              color: Colors.white))),
                ),
              ),
              Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(
                    "${e.iValue!} lần",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  )),
              SizedBox(
                height: 5,
              ),
            ],
          );
        }).toList());
  }
}
