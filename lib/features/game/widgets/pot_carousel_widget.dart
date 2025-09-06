import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state_model.dart';
import '../models/ingredient_model.dart';
import 'pot_row_widget.dart';
import '../../../shared/theme/app_theme.dart';

class PotCarouselWidget extends ConsumerStatefulWidget {
  final List<GamePlayer> players;
  final String currentUserId;
  final Function(IngredientChip chip, int position)? onChipPlaced;
  final List<IngredientChip> drawnChips;
  final bool canPlaceChips;

  const PotCarouselWidget({
    super.key,
    required this.players,
    required this.currentUserId,
    this.onChipPlaced,
    this.drawnChips = const [],
    this.canPlaceChips = false,
  });

  @override
  ConsumerState<PotCarouselWidget> createState() => _PotCarouselWidgetState();
}

class _PotCarouselWidgetState extends ConsumerState<PotCarouselWidget>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Find current player index
    _currentIndex = widget.players.indexWhere(
      (player) => player.userId == widget.currentUserId,
    );
    if (_currentIndex == -1) _currentIndex = 0;
    
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.9, // Show slight overlap of adjacent cards
    );
    
    // Animation for smooth transitions
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start initial animation
    _transitionController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel header with navigation
        _buildCarouselHeader(),
        
        const SizedBox(height: 12),
        
        // Main carousel
        Container(
          height: 200, // Fixed height for the carousel
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _handlePageChanged,
                    itemCount: widget.players.length,
                    itemBuilder: (context, index) {
                      final player = widget.players[index];
                      final isCurrentPlayer = player.userId == widget.currentUserId;
                      final isActiveCard = index == _currentIndex;
                      
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: isActiveCard ? 0 : 8,
                        ),
                        transform: Matrix4.identity()
                          ..scale(isActiveCard ? 1.0 : 0.95),
                        child: PotRowWidget(
                          player: player,
                          isCurrentPlayer: isCurrentPlayer,
                          onChipPlaced: isCurrentPlayer ? widget.onChipPlaced : null,
                          drawnChips: isCurrentPlayer ? widget.drawnChips : [],
                          canPlaceChips: isCurrentPlayer && widget.canPlaceChips,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Page indicators
        _buildPageIndicators(),
      ],
    );
  }

  Widget _buildCarouselHeader() {
    final currentPlayer = widget.players[_currentIndex];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Previous player button
          IconButton(
            onPressed: _currentIndex > 0 ? _goToPreviousPlayer : null,
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: _currentIndex > 0 ? Colors.white : Colors.white38,
            ),
            tooltip: 'Previous Player',
          ),
          
          // Current player info
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Text(
                    currentPlayer.displayName,
                    style: AppTheme.headingStyle.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    currentPlayer.userId == widget.currentUserId ? 'Your Pot' : 'Opponent\'s Pot',
                    style: AppTheme.bodyStyle.copyWith(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Next player button
          IconButton(
            onPressed: _currentIndex < widget.players.length - 1 ? _goToNextPlayer : null,
            icon: Icon(
              Icons.keyboard_arrow_right,
              color: _currentIndex < widget.players.length - 1 ? Colors.white : Colors.white38,
            ),
            tooltip: 'Next Player',
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.players.length,
        (index) {
          final isActive = index == _currentIndex;
          final player = widget.players[index];
          final isCurrentPlayer = player.userId == widget.currentUserId;
          
          return GestureDetector(
            onTap: () => _goToPlayer(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 32 : 24,
              height: isActive ? 32 : 24,
              decoration: BoxDecoration(
                color: isCurrentPlayer 
                    ? AppTheme.primaryColor
                    : isActive
                        ? AppTheme.secondaryColor
                        : Colors.white38,
                shape: BoxShape.circle,
                border: isActive
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  player.displayName.isNotEmpty 
                      ? player.displayName[0].toUpperCase()
                      : 'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isActive ? 14 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Animate transition
    _transitionController.reset();
    _transitionController.forward();
  }

  void _goToPreviousPlayer() {
    if (_currentIndex > 0) {
      _pageController.animateToPage(
        _currentIndex - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPlayer() {
    if (_currentIndex < widget.players.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPlayer(int index) {
    if (index != _currentIndex) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}