import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PageRouter {
  static push(BuildContext context, Widget className) {
    _navigate(context, className, NavigationType.push);
  }

  static pushReplacement(BuildContext context, Widget className) {
    _navigate(context, className, NavigationType.pushReplacement);
  }

  static pushRemoveUntil(BuildContext context, Widget className) {
    _navigate(context, className, NavigationType.pushRemoveUntil);
  }

  static _navigate(
    BuildContext context,
    Widget className,
    NavigationType type,
  ) {
    routeBuilder(BuildContext context) => className;

    final platform =
        Platform.isAndroid ? PlatformType.android : PlatformType.ios;

    final pageRoute = switch (platform) {
      PlatformType.android => MaterialPageRoute(builder: routeBuilder),
      PlatformType.ios => CupertinoPageRoute(builder: routeBuilder),
    };

    switch (type) {
      case NavigationType.push:
        Navigator.push(context, pageRoute);
        break;
      case NavigationType.pushReplacement:
        Navigator.pushReplacement(context, pageRoute);
        break;
      case NavigationType.pushRemoveUntil:
        Navigator.pushAndRemoveUntil(context, pageRoute, (route) => false);
        break;
    }
  }
}

/// Enum for navigation type
enum NavigationType { push, pushReplacement, pushRemoveUntil }

/// Enum for platform type
enum PlatformType { android, ios }
