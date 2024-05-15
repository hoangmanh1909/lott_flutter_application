// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flip_board/flip_clock.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class KenoLiveView extends StatefulWidget {
  const KenoLiveView({super.key});

  @override
  State<StatefulWidget> createState() => _KenoLiveView();
}

class _KenoLiveView extends State<KenoLiveView> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();

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
      ..loadRequest(Uri.parse(
          'https://www.youtube.com/embed/0HdjzH9nu5k?si=Q8mDT9PlxBgQOxrz'));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
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
                          width: 80,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Kỳ quay",
                              style: TextStyle(color: Colors.blue[900]),
                            ),
                            Text("0156789",
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
              ))
        ],
      ),
    ));
  }

  Widget _buidLink() {
    return SizedBox(
        width: double.infinity,
        height: 220,
        child: WebViewWidget(controller: _controller));
  }

  Widget _flipClock() {
    return FlipCountdownClock(
      duration: Duration(seconds: 500),
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
  }
}
