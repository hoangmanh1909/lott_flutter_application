// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:lott_flutter_application/main/keno_live_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    KenoLiveView(),
    KenoLiveView(),
    KenoLiveView(),
  ];
  bool isShowHistory = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {});
  }

  int visit = 1;
  List<TabItem> items = [
    TabItem(
      icon: Icons.home,
      title: 'Trang chủ',
    ),
    TabItem(
      icon: Icons.live_tv,
      title: 'Trực tiếp',
    ),
    TabItem(
      icon: Icons.bookmarks,
      title: 'Keno',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.isNotEmpty
            ? _widgetOptions.elementAt(_selectedIndex)
            : SizedBox.shrink(),
      ),
      bottomNavigationBar: BottomBarInspiredOutside(
        items: items,
        backgroundColor: Colors.white,
        color: Colors.blue,
        colorSelected: Colors.white,
        indexSelected: visit,
        onTap: (int index) => setState(() {
          visit = index;
        }),
        top: -25,
        animated: true,
        itemStyle: ItemStyle.circle,
        chipStyle: const ChipStyle(drawHexagon: true),
      ),
    );
  }
}
