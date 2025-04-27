import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Indicators extends StatelessWidget {
  final Color? color;
  final double? size;

  const Indicators({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        color: color,

        radius: size ?? 10,
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: size ?? 1,
        ),
      );
    }
  }
}