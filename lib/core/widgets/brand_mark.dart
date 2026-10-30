import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 36, super.key});
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(size: Size.square(size), painter: _StarPainter()),
  );
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 1024, size.height / 1024);
    // Same cubic geometry as assets/brand/dreambank_symbol.svg.
    final path = Path()
      ..moveTo(512, 128)
      ..cubicTo(540, 444, 580, 484, 896, 512)
      ..cubicTo(580, 540, 540, 580, 512, 896)
      ..cubicTo(484, 580, 444, 540, 128, 512)
      ..cubicTo(444, 484, 484, 444, 512, 128)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.accent);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const BrandMark(),
      const SizedBox(width: 10),
      Flexible(
        child: Text('DreamBank', style: Theme.of(context).textTheme.titleLarge),
      ),
    ],
  );
}
