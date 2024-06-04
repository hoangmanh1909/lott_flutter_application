// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flip_board/flip_clock.dart';
import 'package:flutter/material.dart';
import 'package:lott_flutter_application/main/keno_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

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
  late final WebViewController _controller;
  final ResultController _con = ResultController();

  List<GetResultKenoResponse>? resultKenos;
  GetDrawKenoResponse? drawKenoResponse;
  String drawCode = "#";
  int secondCountdown = 0;
  Timer? timer;
  String? urlLive;
  FirebaseDatabase database = FirebaseDatabase.instance;

  final rtdb = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ket-qua-xo-so-b5917-default-rtdb.firebaseio.com/');

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });

    id();
  }

  id() async {
    final url = await rtdb.ref().child('urlLive').get();
    urlLive = url.value.toString();
    late PlatformWebViewControllerCreationParams params =
        const PlatformWebViewControllerCreationParams();

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

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
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(urlLive!));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  getData() async {
    if (mounted) {
      showProcess(context);
    }
    await getDrawKeno();
    await getResultKeno();
    if (mounted) Navigator.of(context).pop();
  }

  getDrawKeno() async {
    ResponseObject res = await _con.getDrawKeno();
    if (res.code == "00") {
      drawKenoResponse = GetDrawKenoResponse.fromJson(jsonDecode(res.data!));
      secondCountdown = drawKenoResponse!.closeTime!;
      drawCode = drawKenoResponse!.drawCode!;
      setState(() {});
      if (drawKenoResponse != null) {
        startTimer();
      }
    }
  }

  void startTimer() {
    Duration oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (secondCountdown == 0) {
          Future.delayed(Duration(seconds: 1), () {
            getData();
          });

          setState(() {});
        } else {
          setState(() {
            secondCountdown--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
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
              child: Column(
                children: [
                  _buidLink(),
                  Container(
                      height: 60,
                      width: double.infinity,
                      margin: EdgeInsets.all(8),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Image(
                                  image: AssetImage("assets/img/keno.png"),
                                  width: 75,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Kỳ quay",
                                      style: TextStyle(color: Colors.blue[900]),
                                    ),
                                    Text("#$drawCode",
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18))
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          _flipClock()
                        ],
                      )),
                  buildResultFirst(),
                  buildGeneral()
                ],
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

  Widget _buidLink() {
    if (urlLive != null) {
      return SizedBox(
          width: double.infinity,
          height: 220,
          child: WebViewWidget(controller: _controller));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _flipClock() {
    if (secondCountdown > 0) {
      return FlipCountdownClock(
        duration: Duration(seconds: secondCountdown),
        flipDirection: AxisDirection.down,
        digitSize: 26.0,
        width: 30.0,
        height: 40.0,
        separatorColor: Colors.blue,
        digitColor: Colors.white,
        backgroundColor: Colors.blue,
        // separatorColor: colors.onSurface,
        // borderColor: colors.primary,
        // hingeColor: colors.surface,
        onDone: () {
          setState(() {});
        },
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
