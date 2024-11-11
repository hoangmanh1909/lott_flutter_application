// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:lott_flutter_application/main/home_view.dart';
import 'package:lott_flutter_application/main/keno_live_view.dart';

import 'keno_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<Widget> _widgetOptions = [
    HomeView(),
    KenoLiveView(),
    ResultKenoView(),
    ResultKenoView(),
  ];
  bool isShowHistory = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {});
  }

  int visit = 0;
  List<TabItem> items = [
    TabItem(
      icon: Icons.home_outlined,
      title: 'Kết quả',
    ),
    TabItem(
      icon: Icons.live_tv_outlined,
      title: 'Keno Live',
    ),
    TabItem(
      icon: Icons.bookmarks,
      title: 'Keno',
    ),
    TabItem(
      icon: Icons.local_play_outlined,
      title: 'Bingo',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.isNotEmpty
            ? _widgetOptions.elementAt(visit)
            : SizedBox.shrink(),
      ),
      bottomNavigationBar: BottomBarDefault(
          items: items,
          backgroundColor: Colors.white,
          color: Colors.blue,
          colorSelected: Colors.red,
          indexSelected: visit,
          onTap: (int index) => setState(() {
                visit = index;
              }),
          animated: true),
    );
  }
}
