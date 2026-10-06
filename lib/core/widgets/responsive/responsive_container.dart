import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double mobileWidthFactor; // موبایل → پیش‌فرض 1.0 (کامل)
  final double tabletWidthFactor; // تبلت → پیش‌فرض 0.6
  final double desktopWidthFactor; // دسکتاپ → پیش‌فرض 0.33 (یک‌سوم)
  final double maxWidth; // حداکثر عرض مجاز
  final double minWidth; // حداقل عرض مجاز

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.mobileWidthFactor = 1.0,
    this.tabletWidthFactor = 0.6,
    this.desktopWidthFactor = 0.33,
    this.maxWidth = 480,
    this.minWidth = 320,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        double factor;
        if (screenWidth < 600) {
          factor = mobileWidthFactor; // موبایل
        } else if (screenWidth < 1024) {
          factor = tabletWidthFactor; // تبلت
        } else {
          factor = desktopWidthFactor; // دسکتاپ
        }

        // محاسبه عرض نهایی با محدودیت‌ها
        double targetWidth = screenWidth * factor;
        targetWidth = targetWidth.clamp(minWidth, maxWidth);

        return Center(
          child: SizedBox(width: targetWidth, child: child),
        );
      },
    );
  }
}
