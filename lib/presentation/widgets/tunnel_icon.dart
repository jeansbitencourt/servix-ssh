import 'package:flutter/material.dart';

class TunnelIcon extends StatelessWidget {
  const TunnelIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    return CustomPaint(
      size: Size.square(theme.size ?? 24),
      painter: _TunnelIconPainter(theme.color ?? Colors.white),
    );
  }
}

class _TunnelIconPainter extends CustomPainter {
  const _TunnelIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    final arrows = Path()
      ..moveTo(3, 8)
      ..lineTo(21, 8)
      ..moveTo(17, 4)
      ..lineTo(21, 8)
      ..lineTo(17, 12)
      ..moveTo(21, 16)
      ..lineTo(3, 16)
      ..moveTo(7, 12)
      ..lineTo(3, 16)
      ..lineTo(7, 20);
    canvas.drawPath(
      arrows,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_TunnelIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
