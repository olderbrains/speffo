import 'package:flutter/material.dart';
import 'package:flashy_flushbar/flashy_flushbar_widget.dart';

enum FlashAlertType { success, error, warning, info }

class FlashAlert {
  static void show({required String message, required FlashAlertType type}) {
    switch (type) {
      case FlashAlertType.info:
        {
          _showAlertType(message: message, type: type);
        }
      case FlashAlertType.success:
        {
          _showAlertType(
            message: message,
            type: type,
            iconColor: Colors.green,
            icon: Icons.check_circle,
          );
        }
      case FlashAlertType.error:
        {
          _showAlertType(
            message: message,
            type: type,
            iconColor: Colors.redAccent,
            icon: Icons.block_rounded,
          );
        }
      case FlashAlertType.warning:
        {
          _showAlertType(
            message: message,
            type: type,
            iconColor: Colors.orange,
            icon: Icons.warning,
          );
        }
    }
  }

  static void _showAlertType({
    required String message,
    required FlashAlertType type,
    Color? iconColor,
    IconData? icon,
  }) {
    FlashyFlushbar(
      message: message,
      duration: const Duration(seconds: 3),

      dismissDirection: DismissDirection.horizontal,
      isDismissible: false,
      trailingWidget: Material(
        color: Colors.transparent,
        child: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            FlashyFlushbar.cancelAll();
          },
          icon: Icon(Icons.clear),
        ),
      ),

      leadingWidget: Icon(icon ?? Icons.error_outline, color: iconColor),
    ).show();
  }
}
