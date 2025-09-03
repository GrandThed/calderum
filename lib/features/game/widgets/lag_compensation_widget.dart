import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_theme.dart';

/// Widget that displays network latency and lag compensation info
class LagCompensationWidget extends ConsumerStatefulWidget {
  final bool showDetailed;

  const LagCompensationWidget({
    super.key,
    this.showDetailed = false,
  });

  @override
  ConsumerState<LagCompensationWidget> createState() => _LagCompensationWidgetState();
}

class _LagCompensationWidgetState extends ConsumerState<LagCompensationWidget>
    with TickerProviderStateMixin {
  late AnimationController _latencyController;
  late Animation<Color?> _latencyColorAnimation;

  // Mock latency data (would come from actual network measurements)
  int _currentLatency = 45; // milliseconds
  List<int> _latencyHistory = [];
  Timer? _latencyTimer;

  @override
  void initState() {
    super.initState();

    _latencyController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _latencyColorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(_latencyController);

    _startLatencySimulation();
  }

  @override
  void dispose() {
    _latencyController.dispose();
    _latencyTimer?.cancel();
    super.dispose();
  }

  void _startLatencySimulation() {
    _latencyTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        setState(() {
          // Simulate network latency variation
          _currentLatency = 25 + (DateTime.now().millisecond % 100);
          _latencyHistory.add(_currentLatency);
          
          // Keep only last 30 readings
          if (_latencyHistory.length > 30) {
            _latencyHistory.removeAt(0);
          }
          
          // Update animation based on latency
          final latencyRatio = (_currentLatency / 200).clamp(0.0, 1.0);
          _latencyController.animateTo(latencyRatio);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.showDetailed 
        ? _buildDetailedView() 
        : _buildCompactView();
  }

  Widget _buildCompactView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getLatencyColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.network_ping,
            size: 12,
            color: _getLatencyColor(),
          ),
          const SizedBox(width: 4),
          Text(
            '${_currentLatency}ms',
            style: AppTheme.bodyStyle.copyWith(
              fontSize: 10,
              color: _getLatencyColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.network_ping,
                color: _getLatencyColor(),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Network Performance',
                style: AppTheme.titleStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Current latency
          _buildLatencyDisplay(),

          const SizedBox(height: 16),

          // Latency chart
          _buildLatencyChart(),

          const SizedBox(height: 16),

          // Performance metrics
          _buildPerformanceMetrics(),

          const SizedBox(height: 12),

          // Lag compensation status
          _buildLagCompensationStatus(),
        ],
      ),
    );
  }

  Widget _buildLatencyDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Latency indicator
          AnimatedBuilder(
            animation: _latencyColorAnimation,
            builder: (context, child) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _latencyColorAnimation.value?.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _latencyColorAnimation.value ?? Colors.green,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${_currentLatency}',
                    style: AppTheme.titleStyle.copyWith(
                      color: _latencyColorAnimation.value,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 16),

          // Latency info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Latency',
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_currentLatency}ms',
                  style: AppTheme.titleStyle.copyWith(
                    color: _getLatencyColor(),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getLatencyDescription(),
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // Quality indicator
          _buildQualityIndicator(),
        ],
      ),
    );
  }

  Widget _buildLatencyChart() {
    if (_latencyHistory.isEmpty) return const SizedBox();

    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        size: Size.infinite,
        painter: LatencyChartPainter(_latencyHistory),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    final avgLatency = _latencyHistory.isNotEmpty 
        ? _latencyHistory.reduce((a, b) => a + b) / _latencyHistory.length
        : 0.0;
    final maxLatency = _latencyHistory.isNotEmpty 
        ? _latencyHistory.reduce((a, b) => a > b ? a : b) 
        : 0;
    final minLatency = _latencyHistory.isNotEmpty 
        ? _latencyHistory.reduce((a, b) => a < b ? a : b) 
        : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMetricChip('Avg', '${avgLatency.toInt()}ms', Colors.blue),
        _buildMetricChip('Min', '${minLatency}ms', Colors.green),
        _buildMetricChip('Max', '${maxLatency}ms', Colors.orange),
      ],
    );
  }

  Widget _buildMetricChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTheme.bodyStyle.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLagCompensationStatus() {
    final isActive = _currentLatency > 100;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isActive ? Colors.orange : Colors.green).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isActive ? Colors.orange : Colors.green).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.speed : Icons.check_circle,
            size: 16,
            color: isActive ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isActive 
                  ? 'Lag compensation active'
                  : 'Network performance optimal',
              style: AppTheme.bodyStyle.copyWith(
                color: isActive ? Colors.orange : Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityIndicator() {
    final quality = _getConnectionQuality();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getQualityIcon(quality),
          color: _getQualityColor(quality),
          size: 16,
        ),
        const SizedBox(height: 2),
        Text(
          quality,
          style: AppTheme.bodyStyle.copyWith(
            color: _getQualityColor(quality),
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getLatencyColor() {
    if (_currentLatency < 50) return Colors.green;
    if (_currentLatency < 100) return Colors.yellow;
    if (_currentLatency < 150) return Colors.orange;
    return Colors.red;
  }

  String _getLatencyDescription() {
    if (_currentLatency < 50) return 'Excellent';
    if (_currentLatency < 100) return 'Good';
    if (_currentLatency < 150) return 'Fair';
    return 'Poor';
  }

  String _getConnectionQuality() {
    if (_currentLatency < 50) return 'Excellent';
    if (_currentLatency < 100) return 'Good';
    if (_currentLatency < 150) return 'Fair';
    return 'Poor';
  }

  Color _getQualityColor(String quality) {
    switch (quality) {
      case 'Excellent':
        return Colors.green;
      case 'Good':
        return Colors.blue;
      case 'Fair':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  IconData _getQualityIcon(String quality) {
    switch (quality) {
      case 'Excellent':
        return Icons.signal_wifi_4_bar;
      case 'Good':
        return Icons.signal_wifi_4_bar;
      case 'Fair':
        return Icons.signal_wifi_statusbar_4_bar;
      default:
        return Icons.signal_wifi_bad;
    }
  }
}

/// Custom painter for latency chart
class LatencyChartPainter extends CustomPainter {
  final List<int> latencyData;

  LatencyChartPainter(this.latencyData);

  @override
  void paint(Canvas canvas, Size size) {
    if (latencyData.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final maxLatency = latencyData.reduce((a, b) => a > b ? a : b);
    final minLatency = latencyData.reduce((a, b) => a < b ? a : b);
    final latencyRange = maxLatency - minLatency;

    if (latencyRange == 0) return;

    for (int i = 0; i < latencyData.length; i++) {
      final x = (i / (latencyData.length - 1)) * size.width;
      final normalizedLatency = (latencyData[i] - minLatency) / latencyRange;
      final y = size.height - (normalizedLatency * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw gradient fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blue.withValues(alpha: 0.3),
          Colors.blue.withValues(alpha: 0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPath = Path()..addPath(path, Offset.zero);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(LatencyChartPainter oldDelegate) {
    return latencyData != oldDelegate.latencyData;
  }
}