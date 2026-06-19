import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.accentColor = AppColors.red,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: accentColor, size: 34),
          ),
          const SizedBox(height: 26),
          Text(
            value,
            style: const TextStyle(
              fontSize: 40,
              height: 1,
              fontWeight: FontWeight.w900,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.muted,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 44,
            width: double.infinity,
            child: CustomPaint(
              painter: _MiniChartPainter(accentColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  _MiniChartPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path.moveTo(0, size.height * 0.65);
    path.cubicTo(
      size.width * 0.15,
      size.height * 0.45,
      size.width * 0.22,
      size.height * 0.9,
      size.width * 0.36,
      size.height * 0.62,
    );
    path.cubicTo(
      size.width * 0.50,
      size.height * 0.35,
      size.width * 0.58,
      size.height * 0.85,
      size.width * 0.72,
      size.height * 0.60,
    );
    path.cubicTo(
      size.width * 0.84,
      size.height * 0.40,
      size.width * 0.90,
      size.height * 0.35,
      size.width,
      size.height * 0.48,
    );

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _MiniChartPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}