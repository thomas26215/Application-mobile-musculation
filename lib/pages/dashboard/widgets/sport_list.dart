import 'package:flutter/material.dart';

class InnerShadowDecoration extends Decoration {
  final Color color;
  final double blur;
  final double spread;

  const InnerShadowDecoration({
    required this.color,
    this.blur = 6,
    this.spread = -3,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _InnerShadowPainter(color: color, blur: blur, spread: spread);
  }
}

class _InnerShadowPainter extends BoxPainter {
  final Color color;
  final double blur;
  final double spread;

  _InnerShadowPainter({required this.color, required this.blur, required this.spread});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if (configuration.size == null) return;

    final rect = offset & configuration.size!;
    final paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur)
      ..style = PaintingStyle.stroke
      ..strokeWidth = spread.abs() * 2;

    final path = Path()
      ..moveTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top);

    canvas.saveLayer(rect, Paint());
    canvas.drawPath(path, paint);
    canvas.restore();
  }
}

class SportListWidget extends StatelessWidget {
  const SportListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // Hauteur fixe pour le ListView, maintenant 80px
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 80, // Largeur fixe de 80px
              height: 80, // Hauteur fixe de 80px
              decoration: BoxDecoration(
                color: const Color(0xFFBAF2D8),
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundDecoration: InnerShadowDecoration(
                color: Colors.black.withOpacity(0.3),
                blur: 3,
                spread: -10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.sports_soccer,
                    size: 30,
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

