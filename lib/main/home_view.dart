import 'package:flutter/material.dart';
import 'package:lott_flutter_application/config/common.dart';
import 'package:lott_flutter_application/main/result_max3d_pro_view.dart';
import 'package:lott_flutter_application/main/result_max3d_view.dart';
import 'package:lott_flutter_application/main/result_mb_view.dart';
import 'package:lott_flutter_application/main/result_mega_view.dart';
import 'package:lott_flutter_application/main/result_power_view.dart';
import 'package:lott_flutter_application/utils/box_shadow.dart';

import '../utils/color.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewView();
}

class _HomeViewView extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: const Text("Kết quả vn"),
        ),
        body: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                Row(
                  children: [
                    Expanded(
                        child: buildItem("assets/img/mega.png", "Mega 6/45",
                            Common.ID_MEGA)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: buildItem("assets/img/power.png", "Power 6/55",
                            Common.ID_POWER))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: buildItem("assets/img/mienbac.png", "Miền Bắc",
                            Common.ID_LOTO235)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: buildItem("assets/img/mienbac.png", "Miền Trung",
                            Common.ID_LOTO235)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: buildItem("assets/img/mienbac.png", "Miền Nam",
                            Common.ID_LOTO235)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: buildItem("assets/img/max3dtrang.png", "Max 3D",
                            Common.ID_MAX3D)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: buildItem("assets/img/max_3dpro.png",
                            "Max 3D Pro", Common.ID_MAX3D_PRO))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: buildItem("assets/img/dientoan123.png",
                            "Điện toán 123", Common.ID_LOTO235)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: buildItem("assets/img/6x36.png",
                            "Điện toán 6x36", Common.ID_LOTO235)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: buildItem("assets/img/thantai4.png",
                            "Thần tài 4", Common.ID_LOTO235)),
                  ],
                ),
              ])),
            )));
  }

  Widget buildItem(String logo, String name, int product) {
    return InkWell(
        onTap: () => booking(product),
        child: Container(
          alignment: Alignment.center,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[boxShadow()],
            borderRadius: const BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image(
              image: AssetImage(logo),
              width: 80,
              height: 60,
            ),
            Text(
              name,
              style: const TextStyle(color: Colors.red),
            )
          ]),
        ));
  }

  booking(int productID) {
    switch (productID) {
      case Common.ID_MEGA:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResultMegaView()));
        break;
      case Common.ID_POWER:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResultPowerView()));
        break;
      case Common.ID_MAX3D:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResultMax3DView()));
        break;
      case Common.ID_MAX3D_PRO:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ResultMax3DProView()));
        break;
      case Common.ID_LOTO235:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResultMienBacView()));
        break;
    }
  }
}
