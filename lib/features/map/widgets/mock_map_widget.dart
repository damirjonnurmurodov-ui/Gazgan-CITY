import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/map_place.dart';

class MockMapWidget extends StatelessWidget {
  const MockMapWidget({
    super.key,
    required this.places,
    this.selectedPlaceId,
    this.onPlaceSelected,
  });

  final List<MapPlace> places;
  final String? selectedPlaceId;
  final ValueChanged<String>? onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: const Color(0xFFEDF0F5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.7)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            return Stack(
              children: <Widget>[
                _MapBackground(w: w, h: h),
                _GridLines(w: w, h: h),
                _RoadsLayer(w: w, h: h),
                _ParksLayer(w: w, h: h),
                _BuildingsLayer(w: w, h: h),
                _WaterLayer(w: w, h: h),
                ...places.map(
                  (place) => _MapMarker(
                    place: place,
                    mapW: w,
                    mapH: h,
                    isSelected: place.id == selectedPlaceId,
                    onTap: onPlaceSelected != null
                        ? () => onPlaceSelected!(place.id)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MapBackground extends StatelessWidget {
  const _MapBackground({required this.w, required this.h});
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: Container(color: const Color(0xFFEDF0F5)));
  }
}

class _GridLines extends StatelessWidget {
  const _GridLines({required this.w, required this.h});
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _GridPainter()));
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDDE1E8)
      ..strokeWidth = 0.6;
    const step = 40.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoadsLayer extends StatelessWidget {
  const _RoadsLayer({required this.w, required this.h});
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _RoadsPainter()));
  }
}

class _RoadsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final mainRoadBorder = Paint()
      ..color = const Color(0xFFD0D5DD)
      ..strokeWidth = 30
      ..strokeCap = StrokeCap.round;
    final mainRoad = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;

    final mainRoadY = h * 0.38;
    canvas.drawLine(
      Offset(0, mainRoadY),
      Offset(w * 0.88, mainRoadY),
      mainRoadBorder,
    );
    canvas.drawLine(
      Offset(0, mainRoadY),
      Offset(w * 0.88, mainRoadY),
      mainRoad,
    );

    final mainRoadX = w * 0.32;
    canvas.drawLine(Offset(mainRoadX, 0), Offset(mainRoadX, h), mainRoadBorder);
    canvas.drawLine(Offset(mainRoadX, 0), Offset(mainRoadX, h), mainRoad);

    final secRoadBorder = Paint()
      ..color = const Color(0xFFDEE2E8)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    final secRoad = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final secRoadY = h * 0.65;
    canvas.drawLine(
      Offset(w * 0.28, secRoadY),
      Offset(w, secRoadY),
      secRoadBorder,
    );
    canvas.drawLine(Offset(w * 0.28, secRoadY), Offset(w, secRoadY), secRoad);

    final secRoadX = w * 0.70;
    canvas.drawLine(
      Offset(secRoadX, h * 0.32),
      Offset(secRoadX, h),
      secRoadBorder,
    );
    canvas.drawLine(Offset(secRoadX, h * 0.32), Offset(secRoadX, h), secRoad);

    final smallRoad = Paint()
      ..color = const Color(0xFFF8F9FB)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w * 0.1, h * 0.55),
      Offset(w * 0.32, h * 0.55),
      smallRoad,
    );
    canvas.drawLine(
      Offset(w * 0.32, h * 0.82),
      Offset(w * 0.70, h * 0.82),
      smallRoad,
    );
    canvas.drawLine(
      Offset(w * 0.70, h * 0.10),
      Offset(w * 0.70, h * 0.32),
      smallRoad,
    );
    canvas.drawLine(
      Offset(w * 0.88, h * 0.38),
      Offset(w * 0.88, h * 0.65),
      smallRoad,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ParksLayer extends StatelessWidget {
  const _ParksLayer({required this.w, required this.h});
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _ParksPainter()));
  }
}

class _ParksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final parkFill = Paint()
      ..color = const Color(0xFFC5E8C5)
      ..style = PaintingStyle.fill;
    final parkBorder = Paint()
      ..color = const Color(0xFFA8D5A8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final park = RRect.fromLTRBR(
      w * 0.04,
      h * 0.72,
      w * 0.30,
      h * 0.96,
      const Radius.circular(8),
    );
    canvas.drawRRect(park, parkFill);
    canvas.drawRRect(park, parkBorder);

    final garden = RRect.fromLTRBR(
      w * 0.82,
      h * 0.04,
      w * 0.96,
      h * 0.20,
      const Radius.circular(6),
    );
    canvas.drawRRect(garden, parkFill);
    canvas.drawRRect(garden, parkBorder);

    final treePaint = Paint()
      ..color = const Color(0xFF7BC87B)
      ..style = PaintingStyle.fill;

    final trees = <Offset>[
      Offset(w * 0.08, h * 0.76),
      Offset(w * 0.12, h * 0.80),
      Offset(w * 0.16, h * 0.77),
      Offset(w * 0.20, h * 0.83),
      Offset(w * 0.14, h * 0.87),
      Offset(w * 0.24, h * 0.80),
      Offset(w * 0.09, h * 0.90),
      Offset(w * 0.26, h * 0.90),
    ];
    for (final pos in trees) {
      canvas.drawCircle(pos, 4.5, treePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BuildingsLayer extends StatelessWidget {
  const _BuildingsLayer({required this.w, required this.h});
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _BuildingsPainter()));
  }
}

class _BuildingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fill = Paint()
      ..color = const Color(0xFFD5DAE2)
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = const Color(0xFFC5CAD4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final rects = <Rect>[
      Rect.fromLTWH(w * 0.05, h * 0.08, w * 0.08, h * 0.07),
      Rect.fromLTWH(w * 0.15, h * 0.06, w * 0.07, h * 0.09),
      Rect.fromLTWH(w * 0.05, h * 0.18, w * 0.09, h * 0.06),
      Rect.fromLTWH(w * 0.16, h * 0.18, w * 0.06, h * 0.08),
      Rect.fromLTWH(w * 0.40, h * 0.06, w * 0.08, h * 0.10),
      Rect.fromLTWH(w * 0.50, h * 0.04, w * 0.07, h * 0.09),
      Rect.fromLTWH(w * 0.42, h * 0.20, w * 0.09, h * 0.08),
      Rect.fromLTWH(w * 0.55, h * 0.18, w * 0.06, h * 0.09),
      Rect.fromLTWH(w * 0.38, h * 0.44, w * 0.08, h * 0.08),
      Rect.fromLTWH(w * 0.50, h * 0.42, w * 0.07, h * 0.10),
      Rect.fromLTWH(w * 0.38, h * 0.58, w * 0.10, h * 0.06),
      Rect.fromLTWH(w * 0.06, h * 0.44, w * 0.08, h * 0.09),
      Rect.fromLTWH(w * 0.16, h * 0.46, w * 0.06, h * 0.07),
      Rect.fromLTWH(w * 0.42, h * 0.70, w * 0.07, h * 0.08),
      Rect.fromLTWH(w * 0.52, h * 0.72, w * 0.08, h * 0.06),
      Rect.fromLTWH(w * 0.76, h * 0.70, w * 0.07, h * 0.09),
      Rect.fromLTWH(w * 0.78, h * 0.44, w * 0.07, h * 0.10),
      Rect.fromLTWH(w * 0.88, h * 0.44, w * 0.08, h * 0.07),
      Rect.fromLTWH(w * 0.76, h * 0.38, w * 0.06, h * 0.08),
    ];

    for (final r in rects) {
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(2));
      canvas.drawRRect(rr, fill);
      canvas.drawRRect(rr, border);
    }

    final specialFill = Paint()
      ..color = const Color(0xFFC8CDD6)
      ..style = PaintingStyle.fill;

    final specialRects = <Rect>[
      Rect.fromLTWH(w * 0.06, h * 0.28, w * 0.12, h * 0.08),
      Rect.fromLTWH(w * 0.40, h * 0.28, w * 0.10, h * 0.09),
      Rect.fromLTWH(w * 0.74, h * 0.22, w * 0.09, h * 0.08),
      Rect.fromLTWH(w * 0.16, h * 0.56, w * 0.10, h * 0.07),
    ];

    for (final r in specialRects) {
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(3));
      canvas.drawRRect(rr, specialFill);
      canvas.drawRRect(rr, border);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WaterLayer extends StatelessWidget {
  const _WaterLayer({required this.w, required this.h});
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _WaterPainter()));
  }
}

class _WaterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final waterFill = Paint()
      ..color = const Color(0xFFB8D8F0)
      ..style = PaintingStyle.fill;
    final waterBorder = Paint()
      ..color = const Color(0xFF9CC4E4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final waterRect = RRect.fromLTRBR(
      w * 0.72,
      h * 0.04,
      w * 0.90,
      h * 0.18,
      const Radius.circular(14),
    );
    canvas.drawRRect(waterRect, waterFill);
    canvas.drawRRect(waterRect, waterBorder);

    final wavePaint = Paint()
      ..color = const Color(0xFF9CC4E4).withValues(alpha: 0.5)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(w * 0.74, h * 0.10),
      Offset(w * 0.88, h * 0.10),
      wavePaint,
    );
    canvas.drawLine(
      Offset(w * 0.74, h * 0.13),
      Offset(w * 0.88, h * 0.13),
      wavePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.place,
    required this.mapW,
    required this.mapH,
    required this.isSelected,
    this.onTap,
  });

  final MapPlace place;
  final double mapW;
  final double mapH;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final left = place.x * mapW - 18;
    final top = place.y * mapH - 44;
    final accent = isSelected ? AppColors.primaryBlue : AppColors.redDanger;
    final bg = isSelected ? AppColors.primaryBlue : AppColors.white;

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(9),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                place.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? AppColors.white : AppColors.darkNavy,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
