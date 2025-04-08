import 'package:flutter/material.dart';
import 'fall_object.dart';

class FallPainter extends CustomPainter {
  final List<FallObject> particles;
  final bool isRunning;

  FallPainter({
    required this.isRunning,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (FallObject obj in particles) {
      final Rect srcRect = Rect.fromLTWH(0, 0, obj.image.width.toDouble(), obj.image.height.toDouble());
      final Rect dstRect = Rect.fromLTWH(-obj.size / 2, -obj.size / 2, obj.size, obj.size);

      canvas.save();
      canvas.translate(obj.x + obj.wind / 2, obj.y + obj.wind / 2);
      canvas.rotate(obj.rotation);
      canvas.drawImageRect(obj.image, srcRect, dstRect, Paint());
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(FallPainter oldDelegate) => isRunning;
}
