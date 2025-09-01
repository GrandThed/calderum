import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';

class PotWidget extends StatelessWidget {
  final PotState potState;
  final Function(IngredientChip chip, int position)? onChipPlaced;
  final List<IngredientChip> drawnChips;
  final bool canPlaceChips;

  const PotWidget({
    super.key,
    required this.potState,
    this.onChipPlaced,
    required this.drawnChips,
    this.canPlaceChips = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: potState.hasExploded ? Colors.red : AppTheme.primaryColor,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Pot Header with score info
          _buildPotHeader(),

          // Pot scoring track (0-33 spaces)
          Expanded(child: _buildPotTrack(context)),

          // Drawn chips area (chips ready to be placed)
          if (drawnChips.isNotEmpty) _buildDrawnChipsArea(context),
        ],
      ),
    );
  }

  Widget _buildPotHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: potState.hasExploded
            ? Colors.red.withOpacity(0.2)
            : AppTheme.primaryColor.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          // Explosion indicator
          if (potState.hasExploded)
            const Icon(Icons.warning, color: Colors.red, size: 20),

          if (potState.hasExploded) const SizedBox(width: 8),

          // Score info
          Expanded(
            child: Text(
              potState.hasExploded
                  ? 'EXPLODED!'
                  : 'Position: ${potState.scoringPosition}',
              style: TextStyle(
                color: potState.hasExploded ? Colors.red : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Victory Points
          _buildScoreChip(
            Icons.star,
            '${potState.victoryPoints} VP',
            Colors.yellow,
          ),

          const SizedBox(width: 8),

          // Rubies
          _buildScoreChip(Icons.diamond, '${potState.rubies}', Colors.red),

          const SizedBox(width: 8),

          // Coins
          _buildScoreChip(
            Icons.monetization_on,
            '${potState.coins}',
            Colors.amber,
          ),

          const SizedBox(width: 8),

          // Flask status
          Icon(
            Icons.local_drink,
            color: potState.flaskAvailable ? Colors.blue : Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPotTrack(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate spaces in a spiral or curved layout
          return _buildSpiralTrack(constraints);
        },
      ),
    );
  }

  Widget _buildSpiralTrack(BoxConstraints constraints) {
    const int totalSpaces = 34; // 0-33
    final List<Widget> spaceWidgets = [];

    for (int i = 0; i < totalSpaces; i++) {
      spaceWidgets.add(_buildPotSpace(i, constraints));
    }

    // For now, use a simple grid layout
    // TODO: Implement proper spiral layout
    return GridView.count(
      crossAxisCount: 6,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: spaceWidgets,
    );
  }

  Widget _buildPotSpace(int position, BoxConstraints constraints) {
    final bool isDropletPosition = position == potState.dropletPosition;
    final bool isRatPosition = position == potState.ratPosition;
    final bool isRubySpace = position % 5 == 0 && position > 0;

    // Find chip at this position
    final IngredientChip? chipAtPosition = potState.placedChips
        .where((chip) => chip.positionOnBoard == position)
        .firstOrNull;

    return DragTarget<IngredientChip>(
      onWillAccept: (chip) => canPlaceChips && chip != null,
      onAccept: (chip) {
        if (onChipPlaced != null) {
          onChipPlaced!(chip, position);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: _getPotSpaceColor(
              position,
              isDropletPosition,
              isRatPosition,
              isRubySpace,
            ),
            border: Border.all(
              color: candidateData.isNotEmpty
                  ? Colors.yellow
                  : Colors.white.withOpacity(0.3),
              width: candidateData.isNotEmpty ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Space number
              Positioned(
                top: 2,
                left: 2,
                child: Text(
                  '$position',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Ruby indicator
              if (isRubySpace)
                const Positioned(
                  top: 2,
                  right: 2,
                  child: Icon(Icons.diamond, color: Colors.red, size: 12),
                ),

              // Droplet indicator
              if (isDropletPosition)
                const Center(
                  child: Icon(Icons.water_drop, color: Colors.blue, size: 16),
                ),

              // Rat indicator
              if (isRatPosition)
                const Center(
                  child: Icon(Icons.pets, color: Colors.brown, size: 16),
                ),

              // Placed chip
              if (chipAtPosition != null)
                Center(child: _buildChipWidget(chipAtPosition)),
            ],
          ),
        );
      },
    );
  }

  Color _getPotSpaceColor(
    int position,
    bool isDropletPosition,
    bool isRatPosition,
    bool isRubySpace,
  ) {
    if (isDropletPosition) return Colors.blue.withOpacity(0.3);
    if (isRatPosition) return Colors.brown.withOpacity(0.3);
    if (isRubySpace) return Colors.red.withOpacity(0.2);

    // Score-based coloring
    if (position <= 10) return Colors.grey.withOpacity(0.2);
    if (position <= 15) return Colors.green.withOpacity(0.2);
    if (position <= 20) return Colors.orange.withOpacity(0.2);
    if (position <= 25) return Colors.purple.withOpacity(0.2);
    if (position <= 30) return Colors.blue.withOpacity(0.2);
    return Colors.yellow.withOpacity(0.2);
  }

  Widget _buildDrawnChipsArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(0.5),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Drawn Chips (Drag to place):',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: drawnChips
                .map((chip) => _buildDraggableChip(chip))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableChip(IngredientChip chip) {
    return Draggable<IngredientChip>(
      data: chip,
      feedback: _buildChipWidget(chip, isDragging: true),
      childWhenDragging: _buildChipWidget(chip, opacity: 0.3),
      child: _buildChipWidget(chip),
    );
  }

  Widget _buildChipWidget(
    IngredientChip chip, {
    bool isDragging = false,
    double opacity = 1.0,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: isDragging ? 32 : 28,
        height: isDragging ? 32 : 28,
        decoration: BoxDecoration(
          color: chip.color.displayColor,
          border: Border.all(color: chip.color.darkerColor, width: 2),
          borderRadius: BorderRadius.circular(14),
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
              fontSize: isDragging ? 14 : 12,
            ),
          ),
        ),
      ),
    );
  }
}
