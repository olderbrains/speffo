import 'package:flutter/material.dart';
import 'package:flashy_flushbar/flashy_flushbar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum FlashAlertType { success, error, warning, info }

class FlashAlert {
  static OverlayEntry? _currentOverlay;

  static void show(BuildContext context, String message,
      {FlashAlertType type = FlashAlertType.info}) {
    _currentOverlay?.remove();

    final config = _getConfig(type);

    final overlay = OverlayEntry(
      builder: (ctx) => Positioned(
        top: 50.h,
        left: 16.w,
        right: 16.w,
        child: Material(
          color: Colors.transparent,
          child: FlashyFlushbar(
            leadingWidget: Icon(
              config.icon,
              color: config.color,
              size: 24.sp,
            ),
            message: message,
            duration: const Duration(seconds: 2),
            trailingWidget: IconButton(
              icon: const Icon(Icons.close, color: Colors.black, size: 24),
              onPressed: () {
                _currentOverlay?.remove();
              },
            ),
            isDismissible: false,
          ),
        ),
      ),
    );

    _currentOverlay = overlay;
    Overlay.of(context).insert(overlay);

    Future.delayed(const Duration(seconds: 3), () {
      _currentOverlay?.remove();
      _currentOverlay = null;
    });
  }

  static _FlashAlertConfig _getConfig(FlashAlertType type) {
    switch (type) {
      case FlashAlertType.success:
        return _FlashAlertConfig(
          icon: Icons.check_circle_outline,
          color: Colors.green,
        );
      case FlashAlertType.error:
        return _FlashAlertConfig(
          icon: Icons.error_outline,
          color: Colors.red,
        );
      case FlashAlertType.warning:
        return _FlashAlertConfig(
          icon: Icons.warning_amber_outlined,
          color: Colors.orange,
        );
      case FlashAlertType.info:
      return _FlashAlertConfig(
          icon: Icons.info_outline,
          color: Colors.blue,
        );

    }
  }
}

class _FlashAlertConfig {
  final IconData icon;
  final Color color;

  _FlashAlertConfig({required this.icon, required this.color});
}
