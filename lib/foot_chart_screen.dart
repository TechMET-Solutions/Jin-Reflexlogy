import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class FootChartScreen extends StatefulWidget {
  const FootChartScreen({super.key});

  @override
  State<FootChartScreen> createState() => _FootChartScreenState();
}

class _FootChartScreenState extends State<FootChartScreen> {
  static const double _baseWidth = 500;
  static const double _baseHeight = 1134;

  late final Future<_FootChartBundle> _chartFuture = _loadChartBundle();
  bool _showLeft = true;

  Future<_FootChartBundle> _loadChartBundle() async {
    final results = await Future.wait([
      rootBundle.loadString('assets/ddimgtooltip1.js'),
      rootBundle.loadString('assets/foot-chart.html'),
      rootBundle.loadString('assets/foot-chart-right.html'),
    ]);

    final tooltips = _parseTooltips(results[0]);
    return _FootChartBundle(
      left: _ChartData(
        imageAsset: 'assets/images/Left-Foot.jpg',
        points: _parseAreas(results[1], tooltips),
      ),
      right: _ChartData(
        imageAsset: 'assets/images/Right-Foot.jpg',
        points: _parseAreas(results[2], tooltips),
      ),
    );
  }

  Map<int, _TooltipData> _parseTooltips(String js) {
    final regex = RegExp(
      r'tooltips\[(\d+)\]\s*=\s*\[baseUrl \+ "([^"]+)", "([^"]*)"',
    );
    final map = <int, _TooltipData>{};

    for (final match in regex.allMatches(js)) {
      final id = int.tryParse(match.group(1) ?? '');
      final fileName = match.group(2);
      final title = match.group(3);
      if (id == null || fileName == null || title == null) continue;

      map[id] = _TooltipData(
        title: title,
        imageUrl: 'https://jinreflexology.in/wp-content/uploads/2016/04/$fileName',
      );
    }

    return map;
  }

  List<_ChartPoint> _parseAreas(
    String html,
    Map<int, _TooltipData> tooltips,
  ) {
    final regex = RegExp(
      r'<area\s+shape="([^"]+)"\s+coords="([^"]+)"\s+rel="imgtip\[(\d+)\]"',
      caseSensitive: false,
    );

    final points = <_ChartPoint>[];

    for (final match in regex.allMatches(html)) {
      final shape = match.group(1)?.toLowerCase();
      final coordsRaw = match.group(2);
      final tooltipId = int.tryParse(match.group(3) ?? '');
      if (shape == null || coordsRaw == null || tooltipId == null) continue;

      final tooltip = tooltips[tooltipId];
      if (tooltip == null) continue;

      final coords = coordsRaw
          .split(',')
          .map((e) => double.tryParse(e.trim()))
          .whereType<double>()
          .toList();

      if (shape == 'circle' && coords.length >= 3) {
        points.add(
          _ChartPoint.circle(
            tooltip: tooltip,
            x: coords[0],
            y: coords[1],
            r: coords[2],
          ),
        );
      } else if (shape == 'rect' && coords.length >= 4) {
        points.add(
          _ChartPoint.rect(
            tooltip: tooltip,
            left: coords[0],
            top: coords[1],
            right: coords[2],
            bottom: coords[3],
          ),
        );
      }
    }

    return points;
  }

  void _showPointDetails(_TooltipData tooltip) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 80,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tooltip.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    height: 150,
                    child: Image.network(
                      tooltip.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, __, ___) => Container(
                            height: 100,
                            width: 140,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Text('Image not available'),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Foot Chart"),
      backgroundColor: const Color(0xff2f4356),
      body: FutureBuilder<_FootChartBundle>(
        future: _chartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text(
                'Foot chart load nahi zala',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final chart = _showLeft ? snapshot.data!.left : snapshot.data!.right;

          return Column(
            children: [
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _tabButton(
                        title: 'LEFT',
                        selected: _showLeft,
                        onTap: () => setState(() => _showLeft = true),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _tabButton(
                        title: 'RIGHT',
                        selected: !_showLeft,
                        onTap: () => setState(() => _showLeft = false),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Please touch point to see details and pictures',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = MediaQuery.of(context).size.width < 600;
                      final maxChartWidth = math.min(
                        isMobile ? constraints.maxWidth * 0.82 : constraints.maxWidth,
                        _baseWidth,
                      );
                      final maxChartHeight = constraints.maxHeight;

                      double chartWidth = maxChartWidth;
                      double chartHeight =
                          chartWidth * (_baseHeight / _baseWidth);

                      if (chartHeight > maxChartHeight) {
                        chartHeight = maxChartHeight;
                        chartWidth =
                            chartHeight * (_baseWidth / _baseHeight);
                      }

                      return Center(
                        child: SizedBox(
                          width: chartWidth,
                          height: chartHeight,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  chart.imageAsset,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              ...chart.points.map(
                                (point) => point.build(
                                  chartWidth: chartWidth,
                                  chartHeight: chartHeight,
                                  onTap: () => _showPointDetails(point.tooltip),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tabButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff0b0bff) : const Color(0xffffeda0),
          borderRadius: BorderRadius.circular(2),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            decoration: selected ? TextDecoration.none : TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

class _FootChartBundle {
  const _FootChartBundle({required this.left, required this.right});

  final _ChartData left;
  final _ChartData right;
}

class _ChartData {
  const _ChartData({required this.imageAsset, required this.points});

  final String imageAsset;
  final List<_ChartPoint> points;
}

class _TooltipData {
  const _TooltipData({required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;
}

class _ChartPoint {
  _ChartPoint.circle({
    required this.tooltip,
    required this.x,
    required this.y,
    required this.r,
  }) : shape = _PointShape.circle,
       left = null,
       top = null,
       right = null,
       bottom = null;

  _ChartPoint.rect({
    required this.tooltip,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  }) : shape = _PointShape.rect,
       x = null,
       y = null,
       r = null;

  final _PointShape shape;
  final _TooltipData tooltip;
  final double? x;
  final double? y;
  final double? r;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  Widget build({
    required double chartWidth,
    required double chartHeight,
    required VoidCallback onTap,
  }) {
    final scaleX = chartWidth / _FootChartScreenState._baseWidth;
    final scaleY = chartHeight / _FootChartScreenState._baseHeight;

    if (shape == _PointShape.rect) {
      final rectLeft = (left ?? 0) * scaleX;
      final rectTop = (top ?? 0) * scaleY;
      final rectWidth = ((right ?? 0) - (left ?? 0)) * scaleX;
      final rectHeight = ((bottom ?? 0) - (top ?? 0)) * scaleY;

      return Positioned(
        left: rectLeft,
        top: rectTop,
        width: math.max(rectWidth, 30),
        height: math.max(rectHeight, 20),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          color: Colors.red.withOpacity(0.12),
        ),
      ),
      );
    }

    final cx = (x ?? 0) * scaleX;
    final cy = (y ?? 0) * scaleY;
    final radius = math.max((r ?? 0) * ((scaleX + scaleY) / 2), 18);

    return Positioned(
      left: cx - radius,
      top: cy - radius,
      width: radius * 2,
      height: radius * 2,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
           // color: Colors.blue.withOpacity(0.14),
           // border: Border.all(color: Colors.blue.withOpacity(0.28), width: 1),
          ),
        ),
      ),
    );
  }
}

enum _PointShape { circle, rect }
