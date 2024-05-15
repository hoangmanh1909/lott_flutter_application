// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

showProcess(BuildContext context) {
  final spinkit = SpinKitRotatingCircle(color: Colors.white);

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return spinkit;
    },
  );
}
