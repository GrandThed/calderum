import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../utils/pot_scoring.dart';
import '../../../shared/theme/app_theme.dart';

class SpiralPotWidget extends StatefulWidget {
  final PotState potState;
  final Function(IngredientChip chip, int position)? onChipPlaced;
  final List<IngredientChip> drawnChips;
  final bool canPlaceChips;
  final double size;

  const SpiralPotWidget({
    super.key,
    required this.potState,
    this.onChipPlaced,
    required this.drawnChips,
    this.canPlaceChips = false,
    this.size = 350,
  });

  @override
  State<SpiralPotWidget> createState() => _SpiralPotWidgetState();
}

class _SpiralPotWidgetState extends State<SpiralPotWidget>
    with TickerProviderStateMixin {
  late AnimationController _bubbleController;
  late AnimationController _glowController;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _bubbleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.linear,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background glow effect
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.potState.hasExploded
                        ? Colors.red.withOpacity(0.3 * _glowAnimation.value)
                        : AppTheme.primaryColor
                            .withOpacity(0.2 * _glowAnimation.value),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            );
          },
        ),

        // Main pot container
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.surfaceColor,
                AppTheme.surfaceColor.withOpacity(0.8),
                AppTheme.backgroundColor,
              ],
              stops: const [0.3, 0.6, 1.0],
            ),
            border: Border.all(
              color: widget.potState.hasExploded
                  ? Colors.red
                  : AppTheme.primaryColor,
              width: 3,
            ),
          ),
          child: CustomPaint(
            painter: _SpiralPotPainter(
              potState: widget.potState,
              maxPosition: PotScoring.getMaxPosition(),
              bubbleProgress: _bubbleAnimation.value,
            ),
            child: _buildInteractiveOverlay(),
          ),
        ),

        // Center stats display
        _buildCenterDisplay(),

        // Floating ingredient bubbles
        ..._buildFloatingBubbles(),

        // Drawn chips at bottom
        if (widget.drawnChips.isNotEmpty) _buildDrawnChipsPanel(),
      ],
    );
  }

  Widget _buildCenterDisplay() {
    final currentPosition = widget.potState.scoringPosition;
    final potNumber = PotScoring.getPotNumber(currentPosition);
    final points = PotScoring.getVictoryPoints(currentPosition);
    final hasRuby = PotScoring.hasRuby(currentPosition);

    return Container(
      width: widget.size * 0.35,
      height: widget.size * 0.35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.surfaceColor.withOpacity(0.9),
        border: Border.all(
          color: widget.potState.hasExploded
              ? Colors.red
              : AppTheme.primaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pot number
          Text(
            '$potNumber',
            style: TextStyle(
              fontSize: widget.size * 0.12,
              fontWeight: FontWeight.bold,
              color: widget.potState.hasExploded ? Colors.red : Colors.white,
              fontFamily: 'Caudex',
            ),
          ),
          
          // Ruby indicator
          if (hasRuby)
            Icon(
              Icons.diamond,
              color: Colors.red.shade400,
              size: widget.size * 0.06,
            ),
          
          // Victory points
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+$points VP',
              style: TextStyle(
                fontSize: widget.size * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Explosion warning or coins
          if (widget.potState.hasExploded)
            Text(
              'EXPLODED!',
              style: TextStyle(
                fontSize: widget.size * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                  size: widget.size * 0.05,
                ),
                Text(
                  '${PotScoring.getCoins(potNumber, widget.potState.hasExploded)}',
                  style: TextStyle(
                    fontSize: widget.size * 0.04,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInteractiveOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final center = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );

        return Stack(
          children: [
            // Place position markers
            for (int i = 0; i <= PotScoring.getMaxPosition(); i++)
              _buildPositionMarker(i, center, constraints.maxWidth / 2),
          ],
        );
      },
    );
  }

  Widget _buildPositionMarker(int position, Offset center, double radius) {
    // Calculate spiral position
    final spiralData = _calculateSpiralPosition(position, radius);
    final offset = spiralData['offset'] as Offset;
    final isCurrentPosition = position == widget.potState.scoringPosition;
    final hasChip = widget.potState.placedChips
        .any((chip) => chip.positionOnBoard == position);

    return Positioned(
      left: center.dx + offset.dx - 15,
      top: center.dy + offset.dy - 15,
      child: GestureDetector(
        onTap: widget.canPlaceChips && widget.drawnChips.isNotEmpty
            ? () {
                if (widget.onChipPlaced != null &&
                    widget.drawnChips.isNotEmpty) {
                  widget.onChipPlaced!(widget.drawnChips.first, position);
                }
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrentPosition
                ? AppTheme.primaryColor.withOpacity(0.8)
                : hasChip
                    ? _getChipColor(position).withOpacity(0.8)
                    : Colors.white.withOpacity(0.1),
            border: Border.all(
              color: isCurrentPosition
                  ? AppTheme.primaryColor
                  : Colors.white.withOpacity(0.3),
              width: isCurrentPosition ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              '${PotScoring.getPotNumber(position)}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight:
                    isCurrentPosition ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _calculateSpiralPosition(int position, double maxRadius) {
    // Spiral parameters
    const double spiralTurns = 3.5; // Number of spiral turns
    final double maxAngle = spiralTurns * 2 * math.pi;
    final int maxPosition = PotScoring.getMaxPosition();
    
    // Calculate normalized position (0 to 1)
    final double normalized = position / maxPosition;
    
    // Calculate angle and radius for spiral
    final double angle = normalized * maxAngle;
    final double spiralRadius = (0.2 + (normalized * 0.7)) * maxRadius;
    
    // Convert to Cartesian coordinates
    final double x = spiralRadius * math.cos(angle - math.pi / 2);
    final double y = spiralRadius * math.sin(angle - math.pi / 2);
    
    return {
      'offset': Offset(x, y),
      'angle': angle,
      'radius': spiralRadius,
    };
  }

  Color _getChipColor(int position) {
    final chip = widget.potState.placedChips
        .firstWhere(
          (c) => c.positionOnBoard == position,
          orElse: () => const IngredientChip(
            id: '',
            color: IngredientColor.white,
            value: 1,
          ),
        );
    return chip.color.displayColor;
  }

  List<Widget> _buildFloatingBubbles() {
    return List.generate(5, (index) {
      return AnimatedBuilder(
        animation: _bubbleAnimation,
        builder: (context, child) {
          final progress = (_bubbleAnimation.value + (index * 0.2)) % 1.0;
          final yOffset = -progress * widget.size * 0.3;
          final xOffset = math.sin(progress * math.pi * 2) * 20;
          final opacity = (1 - progress).clamp(0.0, 0.6);

          return Positioned(
            bottom: widget.size * 0.4 + yOffset,
            left: widget.size * 0.45 + xOffset + (index * 10),
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: 8 + (index * 2),
                height: 8 + (index * 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildDrawnChipsPanel() {
    return Positioned(
      bottom: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.drawnChips
              .map((chip) => Draggable<IngredientChip>(
                    data: chip,
                    feedback: _buildChipWidget(chip, isDragging: true),
                    childWhenDragging: _buildChipWidget(chip, opacity: 0.3),
                    child: _buildChipWidget(chip),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildChipWidget(IngredientChip chip,
      {bool isDragging = false, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: isDragging ? 36 : 32,
        height: isDragging ? 36 : 32,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: chip.color.displayColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: chip.color.darkerColor,
            width: 2,
          ),
          boxShadow: isDragging
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            '${chip.value}',
            style: TextStyle(
              color: chip.color == IngredientColor.white
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isDragging ? 16 : 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpiralPotPainter extends CustomPainter {
  final PotState potState;
  final int maxPosition;
  final double bubbleProgress;

  _SpiralPotPainter({
    required this.potState,
    required this.maxPosition,
    required this.bubbleProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 - 20;

    // Draw spiral track
    _drawSpiralTrack(canvas, center, maxRadius);

    // Draw special position markers
    _drawSpecialMarkers(canvas, center, maxRadius);

    // Draw liquid effect
    _drawLiquidEffect(canvas, center, maxRadius);
  }

  void _drawSpiralTrack(Canvas canvas, Offset center, double maxRadius) {
    final path = Path();
    const double spiralTurns = 3.5;
    const int segments = 200;

    for (int i = 0; i <= segments; i++) {
      final double t = i / segments;
      final double angle = t * spiralTurns * 2 * math.pi;
      final double radius = (0.2 + (t * 0.7)) * maxRadius;

      final double x = center.dx + radius * math.cos(angle - math.pi / 2);
      final double y = center.dy + radius * math.sin(angle - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, paint);
  }

  void _drawSpecialMarkers(Canvas canvas, Offset center, double maxRadius) {
    // Draw ruby positions
    for (int i = 0; i <= maxPosition; i++) {
      if (PotScoring.hasRuby(i)) {
        final position = _calculateSpiralPosition(i, maxRadius, center);
        
        final paint = Paint()
          ..color = Colors.red.withOpacity(0.3)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(position, 8, paint);
      }
    }
  }

  void _drawLiquidEffect(Canvas canvas, Offset center, double maxRadius) {
    final progress = potState.scoringPosition / maxPosition;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          potState.hasExploded
              ? Colors.red.withOpacity(0.3)
              : AppTheme.primaryColor.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: [progress * 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    canvas.drawCircle(center, maxRadius * progress, paint);
  }

  Offset _calculateSpiralPosition(int position, double maxRadius, Offset center) {
    const double spiralTurns = 3.5;
    final double maxAngle = spiralTurns * 2 * math.pi;
    final double normalized = position / maxPosition;
    final double angle = normalized * maxAngle;
    final double spiralRadius = (0.2 + (normalized * 0.7)) * maxRadius;
    
    final double x = center.dx + spiralRadius * math.cos(angle - math.pi / 2);
    final double y = center.dy + spiralRadius * math.sin(angle - math.pi / 2);
    
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(_SpiralPotPainter oldDelegate) {
    return oldDelegate.potState != potState ||
        oldDelegate.bubbleProgress != bubbleProgress;
  }
}