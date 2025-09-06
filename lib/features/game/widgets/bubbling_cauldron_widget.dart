import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import '../utils/pot_scoring.dart';
import '../../../shared/theme/app_theme.dart';

class BubblingCauldronWidget extends StatefulWidget {
  final PotState potState;
  final Function(IngredientChip chip, int position)? onChipPlaced;
  final List<IngredientChip> drawnChips;
  final bool canPlaceChips;
  final double size;

  const BubblingCauldronWidget({
    super.key,
    required this.potState,
    this.onChipPlaced,
    required this.drawnChips,
    this.canPlaceChips = false,
    this.size = 320,
  });

  @override
  State<BubblingCauldronWidget> createState() => _BubblingCauldronWidgetState();
}

class _BubblingCauldronWidgetState extends State<BubblingCauldronWidget>
    with TickerProviderStateMixin {
  late AnimationController _bubbleController;
  late AnimationController _liquidController;
  late AnimationController _explosionController;
  late AnimationController _ingredientController;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _liquidAnimation;
  late Animation<double> _explosionAnimation;

  List<FloatingIngredient> _floatingIngredients = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateFloatingIngredients();
  }

  void _initializeAnimations() {
    _bubbleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _liquidController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _explosionController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _ingredientController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    _bubbleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.linear),
    );

    _liquidAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _liquidController, curve: Curves.easeInOut),
    );

    _explosionAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _explosionController, curve: Curves.elasticOut),
    );

    if (widget.potState.hasExploded) {
      _explosionController.forward();
    }
  }

  void _generateFloatingIngredients() {
    final random = math.Random();
    _floatingIngredients = widget.potState.placedChips.map((chip) {
      return FloatingIngredient(
        chip: chip,
        angle: random.nextDouble() * 2 * math.pi,
        radius: 30 + random.nextDouble() * 60,
        speed: 0.1 + random.nextDouble() * 0.2,
        size: 20 + random.nextDouble() * 10,
      );
    }).toList();
  }

  @override
  void didUpdateWidget(BubblingCauldronWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.potState.placedChips != oldWidget.potState.placedChips) {
      _generateFloatingIngredients();
    }
    if (widget.potState.hasExploded && !oldWidget.potState.hasExploded) {
      _explosionController.forward();
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _liquidController.dispose();
    _explosionController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final whiteTotal = widget.potState.whiteChipTotal;
    final riskLevel = whiteTotal / 7.0; // 0-1 risk level

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background glow
        _buildBackgroundGlow(riskLevel),

        // Main cauldron
        Container(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _CauldronPainter(
              bubbleProgress: _bubbleAnimation.value,
              liquidProgress: _liquidAnimation.value,
              explosionProgress: _explosionAnimation.value,
              floatingIngredients: _floatingIngredients,
              ingredientProgress: _ingredientController.value,
              riskLevel: riskLevel,
              isExploded: widget.potState.hasExploded,
            ),
            child: _buildInteractiveArea(),
          ),
        ),

        // Stats overlay
        _buildStatsOverlay(),

        // Risk meter
        _buildRiskMeter(riskLevel),

        // Drawn chips
        if (widget.drawnChips.isNotEmpty) _buildDrawnChipsArea(),
      ],
    );
  }

  Widget _buildBackgroundGlow(double riskLevel) {
    return AnimatedBuilder(
      animation: _liquidAnimation,
      builder: (context, child) {
        Color glowColor;
        if (widget.potState.hasExploded) {
          glowColor = Colors.red;
        } else if (riskLevel > 0.8) {
          glowColor = Colors.orange;
        } else if (riskLevel > 0.6) {
          glowColor = Colors.yellow;
        } else {
          glowColor = AppTheme.primaryColor;
        }

        return Container(
          width: widget.size * 1.2,
          height: widget.size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(0.3 * _liquidAnimation.value),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInteractiveArea() {
    return GestureDetector(
      onTapDown: widget.canPlaceChips && widget.drawnChips.isNotEmpty
          ? (details) {
              if (widget.onChipPlaced != null && widget.drawnChips.isNotEmpty) {
                final nextPosition = widget.potState.getNextPosition(
                  widget.drawnChips.first.value,
                );
                widget.onChipPlaced!(widget.drawnChips.first, nextPosition);
                HapticFeedback.lightImpact();
              }
            }
          : null,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildStatsOverlay() {
    final currentPosition = widget.potState.scoringPosition;
    final potNumber = PotScoring.getPotNumber(currentPosition);
    final points = PotScoring.getVictoryPoints(currentPosition);
    final hasRuby = PotScoring.hasRuby(currentPosition);

    return Positioned(
      top: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          children: [
            // Pot number
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.potState.hasExploded
                    ? Colors.red.withOpacity(0.2)
                    : AppTheme.primaryColor.withOpacity(0.2),
                border: Border.all(
                  color: widget.potState.hasExploded
                      ? Colors.red
                      : AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '$potNumber',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.potState.hasExploded
                        ? Colors.red
                        : Colors.white,
                    fontFamily: 'Caudex',
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ruby indicator
                if (hasRuby)
                  Row(
                    children: [
                      Icon(
                        Icons.diamond,
                        color: Colors.red.shade400,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ruby Space!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                // Victory points
                if (points > 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+$points VP',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                // Coins
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${PotScoring.getCoins(potNumber, widget.potState.hasExploded)} coins',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskMeter(double riskLevel) {
    return Positioned(
      right: 20,
      top: widget.size * 0.3,
      child: Container(
        width: 40,
        height: widget.size * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.3),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Risk level indicator
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: (widget.size * 0.4 - 4) * riskLevel,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: riskLevel > 0.8
                        ? [Colors.red, Colors.orange]
                        : riskLevel > 0.5
                            ? [Colors.orange, Colors.yellow]
                            : [Colors.green, Colors.lightGreen],
                  ),
                ),
              ),
            ),
            
            // Explosion threshold line
            Positioned(
              bottom: (widget.size * 0.4 - 4) * (7/7) - 1,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                color: Colors.red,
              ),
            ),
            
            // Current white total
            Positioned(
              top: 4,
              left: 0,
              right: 0,
              child: Text(
                '${widget.potState.whiteChipTotal}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawnChipsArea() {
    return Positioned(
      bottom: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Drop ingredients into cauldron',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.drawnChips
                  .map((chip) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _buildAnimatedChip(chip),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedChip(IngredientChip chip) {
    return AnimatedBuilder(
      animation: _bubbleAnimation,
      builder: (context, child) {
        final bounce = math.sin(_bubbleAnimation.value * math.pi * 2) * 3;
        
        return Transform.translate(
          offset: Offset(0, bounce),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: chip.color.displayColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: chip.color.darkerColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: chip.color.displayColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${chip.value}',
                style: TextStyle(
                  color: chip.color == IngredientColor.white
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FloatingIngredient {
  final IngredientChip chip;
  final double angle;
  final double radius;
  final double speed;
  final double size;

  FloatingIngredient({
    required this.chip,
    required this.angle,
    required this.radius,
    required this.speed,
    required this.size,
  });
}

class _CauldronPainter extends CustomPainter {
  final double bubbleProgress;
  final double liquidProgress;
  final double explosionProgress;
  final List<FloatingIngredient> floatingIngredients;
  final double ingredientProgress;
  final double riskLevel;
  final bool isExploded;

  _CauldronPainter({
    required this.bubbleProgress,
    required this.liquidProgress,
    required this.explosionProgress,
    required this.floatingIngredients,
    required this.ingredientProgress,
    required this.riskLevel,
    required this.isExploded,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw cauldron base
    _drawCauldron(canvas, center, radius);
    
    // Draw liquid
    _drawLiquid(canvas, center, radius);
    
    // Draw floating ingredients
    _drawFloatingIngredients(canvas, center, radius);
    
    // Draw bubbles
    _drawBubbles(canvas, center, radius);
    
    // Draw explosion effect
    if (isExploded) {
      _drawExplosion(canvas, center, radius);
    }
  }

  void _drawCauldron(Canvas canvas, Offset center, double radius) {
    // Cauldron rim
    final rimPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius, rimPaint);

    // Cauldron body gradient
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.grey.shade800,
          Colors.grey.shade600,
          Colors.grey.shade900,
        ],
        stops: const [0.7, 0.85, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius - 4, bodyPaint);
  }

  void _drawLiquid(Canvas canvas, Offset center, double radius) {
    final liquidRadius = (radius - 15) * liquidProgress;
    
    Color liquidColor;
    if (isExploded) {
      liquidColor = Colors.red;
    } else if (riskLevel > 0.8) {
      liquidColor = Colors.orange;
    } else if (riskLevel > 0.5) {
      liquidColor = Colors.yellow;
    } else {
      liquidColor = AppTheme.primaryColor;
    }

    final liquidPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          liquidColor.withOpacity(0.8),
          liquidColor.withOpacity(0.4),
          liquidColor.withOpacity(0.1),
        ],
        stops: const [0.3, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: liquidRadius));

    canvas.drawCircle(center, liquidRadius, liquidPaint);
  }

  void _drawFloatingIngredients(Canvas canvas, Offset center, double radius) {
    for (final ingredient in floatingIngredients) {
      final animatedAngle = ingredient.angle + (ingredientProgress * ingredient.speed * 2 * math.pi);
      final x = center.dx + ingredient.radius * math.cos(animatedAngle);
      final y = center.dy + ingredient.radius * math.sin(animatedAngle);
      final ingredientCenter = Offset(x, y);

      final ingredientPaint = Paint()
        ..color = ingredient.chip.color.displayColor.withOpacity(0.8);

      canvas.drawCircle(ingredientCenter, ingredient.size / 2, ingredientPaint);

      // Draw ingredient value
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${ingredient.chip.value}',
          style: TextStyle(
            color: ingredient.chip.color == IngredientColor.white
                ? Colors.black
                : Colors.white,
            fontSize: ingredient.size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        ingredientCenter - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  void _drawBubbles(Canvas canvas, Offset center, double radius) {
    final random = math.Random(42); // Fixed seed for consistent bubbles
    
    for (int i = 0; i < 15; i++) {
      final bubbleAngle = (i / 15) * 2 * math.pi;
      final bubbleRadius = 20 + random.nextDouble() * (radius - 40);
      final bubbleSize = 3 + random.nextDouble() * 8;
      
      // Animate bubble position
      final animatedRadius = bubbleRadius + math.sin(bubbleProgress * 2 * math.pi + i) * 10;
      final x = center.dx + animatedRadius * math.cos(bubbleAngle);
      final y = center.dy + animatedRadius * math.sin(bubbleAngle);
      
      final bubblePaint = Paint()
        ..color = Colors.white.withOpacity(0.3 + 0.3 * math.sin(bubbleProgress * math.pi + i));
      
      canvas.drawCircle(Offset(x, y), bubbleSize, bubblePaint);
    }
  }

  void _drawExplosion(Canvas canvas, Offset center, double radius) {
    final explosionRadius = radius * explosionProgress * 1.5;
    
    final explosionPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.red.withOpacity(0.8),
          Colors.orange.withOpacity(0.6),
          Colors.yellow.withOpacity(0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: explosionRadius));

    canvas.drawCircle(center, explosionRadius, explosionPaint);

    // Explosion particles
    final random = math.Random(123);
    for (int i = 0; i < 20; i++) {
      final particleAngle = (i / 20) * 2 * math.pi;
      final particleDistance = explosionProgress * radius * (1 + random.nextDouble());
      final particleX = center.dx + particleDistance * math.cos(particleAngle);
      final particleY = center.dy + particleDistance * math.sin(particleAngle);
      
      final particlePaint = Paint()
        ..color = Colors.red.withOpacity(1 - explosionProgress);
      
      canvas.drawCircle(Offset(particleX, particleY), 3, particlePaint);
    }
  }

  @override
  bool shouldRepaint(_CauldronPainter oldDelegate) {
    return oldDelegate.bubbleProgress != bubbleProgress ||
        oldDelegate.liquidProgress != liquidProgress ||
        oldDelegate.explosionProgress != explosionProgress ||
        oldDelegate.ingredientProgress != ingredientProgress ||
        oldDelegate.riskLevel != riskLevel ||
        oldDelegate.floatingIngredients != floatingIngredients;
  }
}