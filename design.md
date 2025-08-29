# Calderum Design Document

## Project Vision
Calderum is a magical potion brewing board game app inspired by The Quacks of Quedlinburg, bringing the excitement of push-your-luck mechanics to a digital mystical realm where players compete as alchemists brewing powerful potions.

## Design Philosophy

### Core Principles
1. **Magical Immersion**: Every UI element reinforces the mystical potion-brewing theme
2. **Intuitive Gameplay**: Complex mechanics presented through simple, clear interfaces
3. **Visual Feedback**: Rich animations and effects for ingredient interactions
4. **Social Engagement**: Foster competition and collaboration through multiplayer features
5. **Accessible Design**: Support various skill levels and device sizes

## Visual Identity

### Color Palette
```
Primary Colors:
- Deep Purple (#6B4E96) - Magic and mystery
- Gold (#D4AF37) - Success and achievement
- Dark Background (#1A1A2E) - Mystical atmosphere
- Surface Dark (#16213E) - Card backgrounds

Secondary Colors:
- Success Green (#4CAF50) - Positive feedback
- Danger Red (#F44336) - Warnings and explosions
- Info Blue (#2196F3) - Information and tips
- Warning Amber (#FF9800) - Caution states

Gradient Overlays:
- Purple to Gold - Premium features
- Dark to Light Purple - Depth layers
- Blue to Purple - Magical effects
```

### Typography
```
Primary Font: Caudex
- Headers: Bold, 24-32px
- Body: Regular, 14-16px
- Buttons: Bold, 16px
- Labels: Regular, 12px

Decorative Font: Caveat
- Game titles: 36-48px
- Magical text: 18-24px
- Tooltips: 16px
- Achievement text: 20px
```

### Iconography
- **Style**: Line icons with magical flourishes
- **Weight**: 2px stroke for consistency
- **Animation**: Subtle pulse/glow on interaction
- **Categories**:
  - Ingredients (herbs, crystals, liquids, powders)
  - Actions (brew, stir, add, explode)
  - Navigation (back arrow, menu, settings)
  - Status (timer, score, turn indicator)

## Screen Layouts

### 1. Splash Screen
```
┌─────────────────────────┐
│                         │
│     [Cauldron Logo]     │ <- Animated bubbling effect
│                         │
│      CALDERUM          │ <- Caveat font, glowing
│   Brew Your Destiny    │ <- Subtitle fadeIn
│                         │
│    [Loading Bar]       │ <- Magical particle effects
│                         │
└─────────────────────────┘
```

### 2. Onboarding Screens (First Launch)

#### Welcome Screen 1 - Introduction
```
┌─────────────────────────┐
│                         │
│     [Cauldron Icon]     │
│                         │
│   Welcome to Calderum!  │
│                         │
│  The magical world of   │
│   potion brewing awaits │
│                         │
│ ● ○ ○ ○                 │
│                         │
│ [Skip] [Next →]         │
└─────────────────────────┘
```

#### Welcome Screen 2 - Core Mechanics
```
┌─────────────────────────┐
│   How to Play           │
│                         │
│   [Bag with Chips]      │
│                         │
│ Draw ingredient chips   │
│ from your bag and place │
│ them in your pot        │
│                         │
│ ○ ● ○ ○                 │
│                         │
│ [← Back] [Next →]       │
└─────────────────────────┘
```

#### Welcome Screen 3 - Risk vs Reward
```
┌─────────────────────────┐
│   Push Your Luck!       │
│                         │
│   ⚪⚪⚪ = 💥          │
│                         │
│ Too many white chips    │
│ (8+) and your pot       │
│ explodes! Stop early    │
│ or risk it all?         │
│                         │
│ ○ ○ ● ○                 │
│                         │
│ [← Back] [Next →]       │
└─────────────────────────┘
```

#### Welcome Screen 4 - Get Started
```
┌─────────────────────────┐
│   Ready to Brew!        │
│                         │
│     🧙‍♂️ 🆚 🧙‍♀️        │
│                         │
│ Play with friends in    │
│ private rooms. Games    │
│ save automatically!     │
│                         │
│ ○ ○ ○ ●                 │
│                         │
│ [← Back] [Get Started]  │
└─────────────────────────┘
```

### 3. Authentication Screens

#### Login View
```
┌─────────────────────────┐
│  [Background Pattern]   │
│ ┌─────────────────────┐ │
│ │   [Logo Small]      │ │
│ │   Welcome Back!     │ │
│ │                     │ │
│ │  [Email Field]      │ │
│ │  [Password Field]   │ │
│ │                     │ │
│ │  [Sign In Button]   │ │
│ │      -- OR --       │ │
│ │  [Google Sign-In]   │ │
│ │                     │ │
│ │  New? [Sign Up]     │ │
│ └─────────────────────┘ │
└─────────────────────────┘
```

### 3. Home Screen - Streamlined Room Management
```
┌─────────────────────────┐
│ [Calderum] [👤 Profile] │
│                         │
│ ┌─────────────────────┐ │
│ │   [🧪 Science Icon]  │ │
│ │   Ready to Brew?    │ │
│ │  Create or join a   │ │
│ │ magical brewing     │ │
│ │    session          │ │
│ └─────────────────────┘ │
│                         │
│ [🎯 Create Room] ←── Instant │
│                         │
│      ── OR ──           │
│                         │
│ Room Code              │
│ ┌─────────────────────┐ │
│ │ [🔑] ABC123        │ │ ← 6-char input
│ └─────────────────────┘ │
│ [🚀 Join Room] [📋 Paste] │
│                         │
└─────────────────────────┘
```

**Key Changes:**
- **Instant Room Creation**: Single button creates room immediately with defaults
- **Direct Code Input**: Room code field directly on home page
- **Paste Functionality**: Quick paste button with auto-join for valid codes  
- **Streamlined UX**: No separate join room page needed
- **6-Character Codes**: Alphanumeric room codes for easy sharing

### 4. Game Room/Lobby
```
┌─────────────────────────┐
│ Room: [Room Name]       │
│ Code: XYZABC           │
│                         │
│ Players (3/4):          │
│ ┌─────────────────────┐ │
│ │ 👤 Player 1 (Host)  │ │
│ │   🟢 Online ✓       │ │
│ │ 👤 Player 2         │ │
│ │   🟢 Online ✓       │ │
│ │ 👤 Player 3         │ │
│ │   🔴 Offline        │ │
│ │ [+ Invite Friend]    │ │
│ └─────────────────────┘ │
│                         │
│ Game Settings:          │
│ • Ingredient Set: 2     │
│ • Timer: 30s            │
│ • Test Tubes: Off       │
│                         │
│ [😊] [👍] [😮] [🎉]    │
│                         │
│ [Ready] [Start Game]    │
└─────────────────────────┘
```

### 5. Main Game Board
```
┌─────────────────────────┐
│ Round 5/9  Phase: Potions│
├─────────────────────────┤
│     [Pot View - 33 spaces]│
│   ┌─────────────────┐   │
│   │ ⚪⚪🟠🟢⚪🔵    │   │ <- Chips placed
│   │ 1 2 3 5 6 9      │   │ <- Space numbers
│   │ Flask: Full 🧪   │   │
│   │ Rubies: 3 💎     │   │
│   └─────────────────┘   │
│                         │
│ White Total: 5/7 ⚠️     │
│ Scoring Space: 9        │
│                         │
│ [Your Bag]              │
│ ┌──────────────────┐   │
│ │ Draw Chip? 🎲     │   │
│ │ [Stop Brewing]    │   │
│ └──────────────────┘   │
│                         │
│ Other Players:          │
│ P2: Space 12 | P3: 💥  │
└─────────────────────────┘
```

Ingredient Types:
⚪ White (Cherry Bomb)
🟠 Orange (Pumpkin)  
🟢 Green (Garden Spider)
🔵 Blue (Crow Skull)
🔴 Red (Toadstool)
🟡 Yellow (Mandrake)
🟣 Purple (Ghost's Breath)
⚫ Black (Locoweed)

### 6. End Game Screen
```
┌─────────────────────────┐
│   🏆 Game Complete! 🏆   │
│                         │
│ Final Rankings:         │
│ ┌─────────────────────┐ │
│ │ 🥇 Player1 - 156pts │ │
│ │ 🥈 You - 142pts     │ │
│ │ 🥉 Player3 - 128pts │ │
│ └─────────────────────┘ │
│                         │
│ Achievement Unlocked!   │
│ 🎖️ First Victory        │
│                         │
│ Add as Friends:         │
│ [+ Player1] [+ Player3] │
│                         │
│ [Rematch] [New Game]    │
│ [Back to Games]         │
└─────────────────────────┘
```

### 7. Friends Screen
```
┌─────────────────────────┐
│ [← Back]    Friends     │
├─────────────────────────┤
│ [Add Friend by Code]    │
│                         │
│ Online Friends (3)      │
│ ┌─────────────────────┐ │
│ │ 🟢 Alice            │ │
│ │ Won: 45 | Played: 89│ │
│ │ [Invite to Game]    │ │
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │
│ │ 🟢 Bob              │ │
│ │ Won: 12 | Played: 34│ │
│ │ [View Achievements] │ │
│ └─────────────────────┘ │
│                         │
│ Recent Players          │
│ ┌─────────────────────┐ │
│ │ Charlie (2 hrs ago) │ │
│ │ [+ Add Friend]      │ │
│ └─────────────────────┘ │
└─────────────────────────┘
```

## Component Design Specifications

### Buttons
```
Primary Button:
- Background: Linear gradient (#6B4E96 → #7B5EA6)
- Text: White, Caudex Bold 16px
- Border Radius: 12px
- Height: 48px
- Shadow: 0 4px 6px rgba(0,0,0,0.3)
- Hover: Scale(1.02), brightness(1.1)
- Press: Scale(0.98)

Secondary Button:
- Background: Transparent
- Border: 2px solid #6B4E96
- Text: #6B4E96, Caudex Bold 16px
- Interactions: Same as primary
```

### Cards
```
Game Card:
- Background: #16213E with subtle gradient
- Border: 1px solid rgba(107,78,150,0.3)
- Border Radius: 16px
- Padding: 16px
- Shadow: 0 8px 16px rgba(0,0,0,0.4)
- Hover: Transform translateY(-4px)
```

### Input Fields
```
Text Input:
- Background: rgba(26,26,46,0.6)
- Border: 1px solid rgba(107,78,150,0.5)
- Focus Border: 2px solid #6B4E96
- Border Radius: 12px
- Height: 48px
- Padding: 12px 16px
- Label: Above field, Caudex 12px
```

## Animation Specifications

### Ingredient Interactions
```
Drag Animation:
- Scale: 1.2x on pickup
- Rotation: Slight wobble (±5°)
- Shadow: Increase to suggest lift
- Trail: Magical particle effect

Drop Animation:
- Splash effect in cauldron
- Bubble generation
- Score popup (+5, fade up)
- Ingredient dissolve effect
```

### Cauldron Effects
```
Brewing State:
- Continuous bubble animation
- Steam particles rising
- Liquid color changes based on ingredients
- Glow intensity based on score

Explosion State:
- Screen shake effect
- Red flash overlay
- Ingredient scatter animation
- Smoke cloud effect
```

### Transitions
```
Screen Transitions:
- Fade: 300ms ease-in-out
- Slide: 400ms cubic-bezier
- Modal: Slide up with backdrop fade

Element Transitions:
- Hover: 200ms ease
- Press: 100ms ease
- Loading: Pulse animation 1.5s
```

## Responsive Design

### Breakpoints
```
Mobile: 320px - 768px
- Single column layouts
- Full-width buttons
- Simplified game board
- Touch-optimized controls

Tablet: 768px - 1024px
- Two-column where appropriate
- Larger touch targets
- Enhanced visual effects
- Landscape optimization

Desktop: 1024px+
- Multi-column layouts
- Hover states enabled
- Keyboard shortcuts
- Enhanced animations
```

### Adaptation Strategies
```
Game Board Scaling:
- Cauldron: 60% → 40% → 30% of screen
- Ingredients: 48px → 40px → 32px
- Maintain aspect ratios
- Preserve touch targets (min 44px)

Typography Scaling:
- Headers: 32px → 28px → 24px
- Body: 16px → 15px → 14px
- Maintain readability
- Line height adjustments
```

## Accessibility

### Visual Accessibility
- **Color Contrast**: WCAG AA minimum (4.5:1)
- **Color Blind Modes**: Patterns/shapes for ingredients
- **Text Size**: Scalable up to 200%
- **Focus Indicators**: Clear visible outlines
- **Motion Reduction**: Respect prefers-reduced-motion

### Interaction Accessibility
- **Touch Targets**: Minimum 44x44px
- **Keyboard Navigation**: Full support
- **Screen Reader**: Semantic HTML, ARIA labels
- **Loading States**: Clear indicators
- **Error Messages**: Descriptive and actionable

## Accessibility Enhancements

### 1. **ARIA Labels and Semantic Markup**

#### Interactive Element Patterns
```dart
// Button Labels
Semantics(
  label: 'Draw ingredient chip from bag',
  hint: 'Tap to draw a random chip and add to your potion',
  child: ElevatedButton(...)
)

// Game State Announcements
Semantics(
  label: 'Potion brewing phase active',
  liveRegion: true,
  child: Text('Round 5 - Brewing Phase')
)

// Player Turn Indicators
Semantics(
  label: 'Your turn to brew',
  hint: 'Draw chips or stop brewing to avoid explosion',
  focused: isPlayerTurn,
  child: PlayerTurnIndicator(...)
)
```

#### Complex Component Semantics
```dart
// Game Board Structure
Semantics(
  container: true,
  label: 'Potion pot with ${chipCount} chips',
  hint: 'White chip total: ${whiteTotal} of 7 maximum',
  child: GameBoard(...)
)

// Ingredient Chip Selection
Semantics(
  label: '${ingredientType} chip, value ${chipValue}',
  hint: 'Double tap to place in pot at position ${position}',
  selected: isSelected,
  child: IngredientChip(...)
)

// Room Player List
Semantics(
  container: true,
  label: 'Room players, ${readyCount} of ${totalPlayers} ready',
  child: ListView(children: playerCards)
)
```

#### Screen Reader Navigation
```dart
// Hierarchical Content Structure
Semantics(
  header: true,
  label: 'Game Room: ${roomName}',
  child: AppBar(...)
)

Semantics(
  label: 'Game settings section',
  child: ExpansionTile(...)
)

// Skip Navigation Links
Semantics(
  button: true,
  label: 'Skip to main game board',
  onTap: () => _focusGameBoard(),
  child: Container(...)
)
```

#### Focus Management for Modals
```dart
class CalderumModal extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    // Trap focus within modal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_modalFocusNode);
    });
  }

  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKey: (node, event) {
        // Handle escape key to close modal
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Semantics(
        namesRoute: true,
        scopesRoute: true,
        label: 'Settings dialog',
        child: AlertDialog(...)
      )
    );
  }
}
```

### 2. **Colorblind-Friendly Design**

#### Ingredient Pattern System
```
Ingredient Visual Patterns:
⚪ White (Cherry Bomb): Solid circle, explosion icon overlay
🟠 Orange (Pumpkin): Horizontal stripes, pumpkin icon
🟡 Yellow (Mandrake): Diagonal lines, plant icon  
🟢 Green (Garden Spider): Dots pattern, spider icon
🔵 Blue (Crow Skull): Vertical lines, skull icon
🔴 Red (Toadstool): Crosshatch pattern, mushroom icon
🟣 Purple (Ghost's Breath): Wavy lines, ghost icon
⚫ Black (Locoweed): Solid with border, leaf icon

Pattern Implementation:
- High contrast border: 3px solid white outline
- Pattern opacity: 0.4 background, 1.0 pattern
- Icon size: 24x24px centered
- Icon color: Always white for maximum contrast
```

#### High Contrast Mode Specifications
```dart
// Contrast Ratios (WCAG AAA compliant)
class HighContrastTheme {
  static const double minimumContrast = 7.0; // AAA standard
  
  static const Map<String, Color> ingredientColors = {
    'white': Color(0xFFFFFFFF),    // 21:1 contrast
    'orange': Color(0xFFFF6600),   // 8.2:1 contrast
    'yellow': Color(0xFFFFD700),   // 12.6:1 contrast
    'green': Color(0xFF00CC00),    // 9.8:1 contrast
    'blue': Color(0xFF0066FF),     // 7.4:1 contrast
    'red': Color(0xFFCC0000),      // 8.9:1 contrast
    'purple': Color(0xFF9900CC),   // 7.1:1 contrast
    'black': Color(0xFF000000),    // 21:1 contrast
  };
  
  // Background colors for ingredients in high contrast
  static const Color chipBackground = Color(0xFF1A1A1A);
  static const Color potBackground = Color(0xFF0D1117);
  static const Color borderColor = Color(0xFFFFFFFF);
}
```

#### Shape-Based Differentiation
```dart
// Ingredient Chip Shapes
enum ChipShape {
  circle,      // White - simple circle
  hexagon,     // Orange - six-sided
  triangle,    // Yellow - triangle pointing up
  square,      // Green - square rotated 45°
  diamond,     // Blue - diamond shape
  pentagon,    // Red - five-sided
  star,        // Purple - star shape
  octagon,     // Black - eight-sided
}

// Custom painter for accessible shapes
class AccessibleChipPainter extends CustomPainter {
  final ChipShape shape;
  final Color color;
  final String pattern;
  
  void paint(Canvas canvas, Size size) {
    // Draw shape outline with thick border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    
    // Draw pattern fill
    final fillPaint = Paint()
      ..color = color.withOpacity(0.8);
    
    _drawShapeWithPattern(canvas, size, shape, pattern);
  }
}
```

#### Icon-Based Information Alternatives
```dart
// Status Icons Replace Color-Only Information
class AccessibleStatusIndicator extends StatelessWidget {
  final PlayerStatus status;
  
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(_getStatusIcon(status), size: 16),
        SizedBox(width: 4),
        Text(_getStatusText(status)),
        if (status.isUrgent) 
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.priority_high, size: 14)
          ),
      ]
    );
  }
  
  IconData _getStatusIcon(PlayerStatus status) {
    switch (status.type) {
      case StatusType.online: return Icons.circle;
      case StatusType.away: return Icons.schedule;
      case StatusType.ingame: return Icons.gamepad;
      case StatusType.offline: return Icons.circle_outlined;
      default: return Icons.help_outline;
    }
  }
}
```

### 3. **Cognitive Accessibility**

#### Simplified Interface Options
```dart
class SimplifiedGameView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Reduced information density
        SimpleHeader(
          currentRound: gameState.round,
          maxRounds: 9,
          phase: gameState.phase.name,
        ),
        
        // Essential game state only
        Expanded(
          child: Column(
            children: [
              // Large, clear pot display
              SimplePotView(chips: gameState.playerPot),
              
              // Single action at a time
              CurrentActionWidget(
                action: gameState.availableActions.first,
                onTap: _performAction,
              ),
              
              // Simplified player status
              Text('Other players: ${_getSimplePlayerStatus()}'),
            ],
          ),
        ),
      ],
    );
  }
}

// Toggle for simplified mode in settings
class AccessibilitySettings {
  bool simplifiedInterface = false;
  bool reducedAnimations = false;
  bool largerText = false;
  bool highContrast = false;
  
  // Auto-detect cognitive load preferences
  void detectCognitivePreferences() {
    final mediaQuery = MediaQueryData.fromWindow(window);
    if (mediaQuery.accessibleNavigation) {
      simplifiedInterface = true;
    }
    if (mediaQuery.disableAnimations) {
      reducedAnimations = true;
    }
  }
}
```

#### Progressive Disclosure Patterns
```dart
class ProgressiveGameRules extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      children: [
        ExpansionPanelRadio(
          value: 'basic',
          headerBuilder: (context, isExpanded) => ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text('Basic Rules'),
            subtitle: Text('Essential gameplay mechanics'),
          ),
          body: BasicRulesContent(),
        ),
        ExpansionPanelRadio(
          value: 'advanced',
          headerBuilder: (context, isExpanded) => ListTile(
            leading: Icon(Icons.settings),
            title: Text('Advanced Rules'),
            subtitle: Text('Complex ingredient interactions'),
          ),
          body: AdvancedRulesContent(),
        ),
        ExpansionPanelRadio(
          value: 'strategy',
          headerBuilder: (context, isExpanded) => ListTile(
            leading: Icon(Icons.psychology),
            title: Text('Strategy Tips'),
            subtitle: Text('Expert brewing techniques'),
          ),
          body: StrategyContent(),
        ),
      ],
    );
  }
}
```

#### Clear Visual Hierarchy
```dart
// Typography Scale for Cognitive Clarity
class CognitiveTextTheme {
  static const TextStyle primaryHeading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  static const TextStyle secondaryHeading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    height: 1.6,
    letterSpacing: 0.2,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w500,
  );
}

// Spacing Scale for Clear Separation
class CognitiveSpacing {
  static const double minimal = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double section = 32.0;
  static const double page = 48.0;
}
```

#### Reduced Cognitive Load Strategies
```dart
// Chunking Complex Information
class GameSummaryCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primary information only
            Text('Round ${game.currentRound} of 9'),
            SizedBox(height: 8),
            
            // Current status
            StatusChip(
              icon: _getCurrentPhaseIcon(),
              label: _getCurrentPhaseLabel(),
              color: _getCurrentPhaseColor(),
            ),
            
            SizedBox(height: 16),
            
            // Single call-to-action
            if (game.isPlayerTurn)
              PrimaryButton(
                onPressed: _continueGame,
                child: Text('Continue Playing'),
              ),
          ],
        ),
      ),
    );
  }
}

// Error Prevention Through Confirmation
class SafeActionButton extends StatelessWidget {
  final String action;
  final VoidCallback onConfirm;
  final bool requiresConfirmation;
  
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: requiresConfirmation ? _showConfirmation : onConfirm,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (requiresConfirmation) Icon(Icons.warning_amber, size: 16),
          SizedBox(width: 4),
          Text(action),
        ],
      ),
    );
  }
  
  void _showConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Action'),
        content: Text('Are you sure you want to $action?'),
        actions: [
          TextButton(onPressed: Navigator.of(context).pop, child: Text('Cancel')),
          ElevatedButton(onPressed: onConfirm, child: Text('Confirm')),
        ],
      ),
    );
  }
}
```

### 4. **Motor Accessibility**

#### Enhanced Touch Targets
```dart
// Minimum Touch Target Implementation
class AccessibleTouchTarget extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double minSize;
  
  const AccessibleTouchTarget({
    required this.child,
    required this.onTap,
    this.minSize = 48.0, // Exceeds 44px minimum
  });
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minWidth: minSize,
          minHeight: minSize,
        ),
        child: Center(child: child),
      ),
    );
  }
}

// Ingredient Chip with Enhanced Touch
class AccessibleIngredientChip extends StatelessWidget {
  Widget build(BuildContext context) {
    return AccessibleTouchTarget(
      minSize: 56.0, // Extra large for game pieces
      onTap: _selectIngredient,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ingredientColor,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(ingredientIcon, color: Colors.white),
      ),
    );
  }
}
```

#### Keyboard Navigation Shortcuts
```dart
// Global Keyboard Shortcuts
class GameKeyboardShortcuts extends StatelessWidget {
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        // Navigation shortcuts
        LogicalKeySet(LogicalKeyboardKey.escape): DismissIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): ConfirmIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): DrawChipIntent(),
        LogicalKeySet(LogicalKeyboardKey.backspace): UndoIntent(),
        
        // Game action shortcuts
        LogicalKeySet(LogicalKeyboardKey.keyD): DrawChipIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyS): StopBrewingIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyR): ReadyUpIntent(),
        
        // Navigation within pot
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): MoveFocusLeftIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): MoveFocusRightIntent(),
        
        // Quick access
        LogicalKeySet(LogicalKeyboardKey.f1): HelpIntent(),
        LogicalKeySet(LogicalKeyboardKey.tab): NextPlayerIntent(),
      },
      child: Actions(
        actions: {
          DrawChipIntent: CallbackAction<DrawChipIntent>(
            onInvoke: (intent) => _drawChip(),
          ),
          StopBrewingIntent: CallbackAction<StopBrewingIntent>(
            onInvoke: (intent) => _stopBrewing(),
          ),
          // ... other actions
        },
        child: child,
      ),
    );
  }
}

// Focus Management for Game Board
class FocusableGameBoard extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Focus(
      onKey: (node, event) {
        if (event is RawKeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.space:
              _drawNextChip();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.enter:
              _placeFocusedChip();
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: GameBoardWidget(),
    );
  }
}
```

#### Voice Control Considerations
```dart
// Voice Command Integration
class VoiceControlSupport {
  static const Map<String, GameAction> voiceCommands = {
    'draw chip': GameAction.drawChip,
    'stop brewing': GameAction.stopBrewing,
    'ready up': GameAction.ready,
    'show rules': GameAction.showRules,
    'show status': GameAction.showStatus,
    'next player': GameAction.nextPlayer,
    'previous player': GameAction.previousPlayer,
  };
  
  // Voice feedback for actions
  static void announceAction(GameAction action) {
    String announcement;
    switch (action) {
      case GameAction.drawChip:
        announcement = 'Drew ${_lastChipType} chip';
        break;
      case GameAction.stopBrewing:
        announcement = 'Stopped brewing, scored ${_currentScore} points';
        break;
      case GameAction.explosion:
        announcement = 'Pot exploded! Too many white chips';
        break;
    }
    
    // Use TTS or system announcements
    _announceToUser(announcement);
  }
}
```

#### Alternative Input Method Support
```dart
// Switch Control Support
class SwitchControlGameplay extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return SwitchControlListener(
      onPrimarySwitch: _handlePrimaryAction,
      onSecondarySwitch: _handleSecondaryAction,
      child: Column(
        children: [
          // Highlight current selectable element
          SwitchHighlight(
            isActive: _currentSelection == GameElement.drawButton,
            child: DrawChipButton(),
          ),
          SwitchHighlight(
            isActive: _currentSelection == GameElement.stopButton,
            child: StopBrewingButton(),
          ),
        ],
      ),
    );
  }
  
  void _handlePrimaryAction() {
    switch (_currentSelection) {
      case GameElement.drawButton:
        _drawChip();
        break;
      case GameElement.stopButton:
        _stopBrewing();
        break;
    }
  }
  
  void _handleSecondaryAction() {
    _moveToNextSelection();
  }
}

// Head Tracking Support
class HeadTrackingInterface extends StatelessWidget {
  Widget build(BuildContext context) {
    return GazeTracker(
      dwellTime: Duration(milliseconds: 800),
      onDwell: (position) {
        final element = _getElementAtPosition(position);
        if (element != null) {
          _activateElement(element);
        }
      },
      child: GameInterface(),
    );
  }
}
```

### 5. **Screen Reader Support**

#### Detailed Visual Descriptions
```dart
// Game Board Description
Semantics(
  label: '''Potion brewing pot with 33 numbered spaces. 
    Currently contains ${chipCount} ingredient chips. 
    White chip total is ${whiteTotal} out of maximum 7 before explosion. 
    Current scoring position is space ${currentSpace}.
    ${_getPotContentsDescription()}''',
  hint: 'Navigate with arrow keys to explore pot contents',
  child: PotWidget(),
)

String _getPotContentsDescription() {
  final chips = pot.chips;
  if (chips.isEmpty) return 'Pot is empty, ready for first ingredient.';
  
  return chips.map((chip) => 
    '${chip.type.name} chip at position ${chip.position}'
  ).join(', ');
}

// Player Status Description  
Semantics(
  label: '''${player.name} - ${_getPlayerStatusDescription()}''',
  child: PlayerCard(),
)

String _getPlayerStatusDescription() {
  final status = player.gameStatus;
  switch (status.phase) {
    case GamePhase.brewing:
      return '''Currently brewing. 
        Pot contains ${status.chipCount} chips, 
        scoring ${status.currentScore} points. 
        ${status.canDraw ? 'Can draw more chips' : 'Must stop or risk explosion'}.''';
    case GamePhase.evaluation:
      return '''Evaluation phase. 
        Scored ${status.roundScore} points this round. 
        Total score: ${status.totalScore} points.''';
    case GamePhase.buying:
      return '''Buying phase. 
        Has ${status.rubies} rubies to spend on new ingredients.''';
  }
}
```

#### Live Region Announcements
```dart
// Game State Changes
class GameStateAnnouncer extends StatefulWidget {
  @override
  void didUpdateWidget(GameStateAnnouncer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Announce significant state changes
    if (widget.gameState.phase != oldWidget.gameState.phase) {
      _announcePhaseChange(widget.gameState.phase);
    }
    
    if (widget.gameState.currentPlayer != oldWidget.gameState.currentPlayer) {
      _announceTurnChange(widget.gameState.currentPlayer);
    }
    
    if (widget.gameState.hasExplosion && !oldWidget.gameState.hasExplosion) {
      _announceExplosion();
    }
  }
  
  void _announcePhaseChange(GamePhase phase) {
    final announcement = _getPhaseAnnouncement(phase);
    _liveAnnounce(announcement);
  }
  
  void _liveAnnounce(String message) {
    // Create invisible live region for announcements
    setState(() {
      _currentAnnouncement = message;
    });
    
    // Clear after announced
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        _currentAnnouncement = '';
      });
    });
  }
  
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Live region for announcements
        Semantics(
          liveRegion: true,
          child: Text(_currentAnnouncement),
        ),
        
        // Main game content
        GameContent(),
      ],
    );
  }
}
```

#### Structured Content Organization
```dart
// Hierarchical Screen Reader Navigation
class AccessibleGameLayout extends StatelessWidget {
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Column(
        children: [
          // Main heading
          Semantics(
            header: true,
            label: 'Calderum - Round ${game.round} of 9',
            child: GameHeader(),
          ),
          
          // Navigation landmarks
          Semantics(
            label: 'Game navigation',
            child: Row(children: navigationButtons),
          ),
          
          // Main game region
          Semantics(
            label: 'Main game area',
            child: Expanded(
              child: Row(
                children: [
                  // Player's pot section
                  Semantics(
                    label: 'Your potion pot',
                    child: PlayerPotSection(),
                  ),
                  
                  // Game actions section  
                  Semantics(
                    label: 'Available actions',
                    child: GameActionsSection(),
                  ),
                  
                  // Other players section
                  Semantics(
                    label: 'Other players status',
                    child: OtherPlayersSection(),
                  ),
                ],
              ),
            ),
          ),
          
          // Status bar
          Semantics(
            label: 'Game status information',
            child: GameStatusBar(),
          ),
        ],
      ),
    );
  }
}
```

#### Alternative Text Patterns
```dart
// Decorative vs Informative Images
class AccessibleImage extends StatelessWidget {
  final String imagePath;
  final String? semanticLabel;
  final bool isDecorative;
  
  Widget build(BuildContext context) {
    Widget image = Image.asset(imagePath);
    
    if (isDecorative) {
      // Hide decorative images from screen readers
      return ExcludeSemantics(child: image);
    }
    
    // Provide meaningful descriptions for informative images
    return Semantics(
      image: true,
      label: semanticLabel ?? _generateImageDescription(imagePath),
      child: image,
    );
  }
  
  String _generateImageDescription(String path) {
    // Generate contextual descriptions based on game state
    if (path.contains('ingredient')) {
      return 'Ingredient chip illustration';
    } else if (path.contains('cauldron')) {
      return 'Magical brewing cauldron with bubbling potion';
    }
    return 'Game illustration';
  }
}

// Icon Descriptions
class AccessibleIcon extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final bool isButton;
  
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: isButton,
      child: Icon(icon),
    );
  }
}

// Usage examples
AccessibleIcon(
  icon: Icons.casino,
  semanticLabel: 'Draw random ingredient chip',
  isButton: true,
)

AccessibleIcon(
  icon: Icons.stop,
  semanticLabel: 'Stop brewing to avoid explosion',
  isButton: true,
)
```

### 6. **Implementation Guidelines**

#### Flutter Accessibility Widget Recommendations
```dart
// Comprehensive Accessibility Widget Set
class CalderumAccessibilityWidgets {
  
  // Enhanced Button with Full Accessibility
  static Widget accessibleButton({
    required String label,
    required VoidCallback onPressed,
    String? hint,
    bool isDestructive = false,
    bool isLoading = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: !isLoading,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? Colors.red : null,
          minimumSize: Size(88, 48), // Exceed minimum touch target
        ),
        child: isLoading 
          ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
          : Text(label),
      ),
    );
  }
  
  // Game Chip with Rich Semantics
  static Widget accessibleGameChip({
    required IngredientType type,
    required int value,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Semantics(
      label: '${type.displayName} ingredient chip, value $value',
      hint: 'Double tap to add to your potion',
      selected: isSelected,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: type.accessibleColor,
            border: Border.all(
              color: isSelected ? Colors.gold : Colors.white,
              width: isSelected ? 4 : 2,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(type.accessibleIcon, color: Colors.white, size: 20),
                Text('$value', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Accessible Form Field
  static Widget accessibleTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? errorText,
    bool isRequired = false,
  }) {
    return Semantics(
      label: label + (isRequired ? ', required field' : ''),
      hint: hint,
      textField: true,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          hintText: hint,
          errorText: errorText,
          border: OutlineInputBorder(),
        ),
        validator: isRequired 
          ? (value) => value?.isEmpty ?? true ? '$label is required' : null
          : null,
      ),
    );
  }
}
```

#### Testing Procedures with Screen Readers
```dart
// Automated Accessibility Testing
class AccessibilityTester {
  static void runAccessibilityTests() {
    testWidgets('Game board is accessible', (tester) async {
      await tester.pumpWidget(GameApp());
      
      // Test semantic labels
      expect(find.bySemanticsLabel('Potion brewing pot'), findsOneWidget);
      
      // Test keyboard navigation
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      expect(tester.binding.focusedNode, isNotNull);
      
      // Test screen reader announcements
      await tester.pumpAndSettle();
      final announcement = find.byType(Semantics).evaluate().first.widget as Semantics;
      expect(announcement.properties.liveRegion, isTrue);
    });
    
    // Test touch target sizes
    testWidgets('All interactive elements meet size requirements', (tester) async {
      await tester.pumpWidget(GameApp());
      
      final buttons = find.byType(ElevatedButton);
      for (final button in buttons.evaluate()) {
        final renderBox = button.renderObject as RenderBox;
        expect(renderBox.size.width, greaterThanOrEqualTo(44));
        expect(renderBox.size.height, greaterThanOrEqualTo(44));
      }
    });
  }
}

// Manual Testing Checklist
class AccessibilityChecklist {
  static const List<String> screenReaderTests = [
    'Navigate entire game using only screen reader',
    'Verify all game states are announced',
    'Check ingredient descriptions are clear',
    'Confirm player status updates are audible',
    'Test modal focus management',
    'Verify error messages are descriptive',
  ];
  
  static const List<String> keyboardTests = [
    'Navigate all screens using only keyboard',
    'Test all game actions via keyboard shortcuts',
    'Verify focus indicators are visible',
    'Check tab order is logical',
    'Test escape key functionality',
    'Verify no keyboard traps exist',
  ];
  
  static const List<String> motorAccessibilityTests = [
    'Test with switch control enabled',
    'Verify voice control commands work',
    'Test with head tracking (if available)',
    'Check touch target sizes on actual devices',
    'Test with reduced dexterity simulation',
    'Verify sticky keys support',
  ];
}
```

#### Accessibility Developer Checklist
```dart
// Pre-release Accessibility Audit
class AccessibilityAudit {
  static const Map<String, List<String>> auditCategories = {
    'Visual': [
      'Color contrast ratio ≥ 4.5:1 (AA) or ≥ 7:1 (AAA)',
      'Text scales up to 200% without horizontal scrolling',
      'Focus indicators visible and high contrast',
      'Motion can be disabled via system settings',
      'Content works without color alone',
    ],
    
    'Motor': [
      'All touch targets ≥ 44x44px',
      'Keyboard navigation covers all functionality',  
      'No time limits or limits can be extended',
      'Gestures have keyboard/button alternatives',
      'Voice control supported where possible',
    ],
    
    'Auditory': [
      'Visual alternatives for audio cues',
      'Captions for any video content',
      'Sound can be controlled independently',
      'No auto-playing audio > 3 seconds',
    ],
    
    'Cognitive': [
      'Clear headings and page structure',
      'Consistent navigation patterns',
      'Error prevention and correction',
      'Help and documentation available',
      'Complex tasks can be paused/saved',
    ],
    
    'Screen Reader': [
      'All content accessible via screen reader',
      'Semantic markup used correctly',
      'Live regions announce status changes',
      'Images have appropriate alt text',
      'Form fields properly labeled',
    ],
  };
}
```

#### WCAG 2.1 AA Compliance Verification
```dart
// Compliance Verification Tools
class WCAGCompliance {
  // Perceivable Guidelines
  static bool verifyColorContrast(Color foreground, Color background) {
    final ratio = _calculateContrastRatio(foreground, background);
    return ratio >= 4.5; // AA standard
  }
  
  static bool verifyTextScaling() {
    // Verify text scales to 200% without loss of functionality
    final mediaQuery = MediaQueryData.fromWindow(window);
    return mediaQuery.textScaleFactor <= 2.0;
  }
  
  // Operable Guidelines  
  static bool verifyTouchTargets(List<Widget> interactiveElements) {
    return interactiveElements.every((element) {
      if (element is! GestureDetector) return true;
      final renderBox = element.renderObject as RenderBox?;
      if (renderBox == null) return true;
      return renderBox.size.width >= 44 && renderBox.size.height >= 44;
    });
  }
  
  // Understandable Guidelines
  static bool verifyConsistentNavigation(List<Screen> screens) {
    final navigationPatterns = screens.map((s) => s.navigationPattern);
    return navigationPatterns.toSet().length == 1; // All consistent
  }
  
  // Robust Guidelines
  static bool verifySemanticMarkup(Widget widget) {
    // Check for proper semantic structure
    return _hasSemanticLabels(widget) && _hasProperHierarchy(widget);
  }
}
```

This comprehensive accessibility enhancement maintains the magical theme while ensuring the Calderum design system is fully inclusive and accessible to users with diverse abilities. All specifications are actionable and can be directly implemented in Flutter with the provided code examples.

## Sound Design Guidelines

### Sound Categories
```
UI Sounds:
- Button tap: Soft magical chime
- Navigation: Whoosh transition
- Success: Crystalline ring
- Error: Low rumble

Game Sounds:
- Ingredient pickup: Pop
- Ingredient drop: Splash
- Brewing: Bubbling loop
- Explosion: Boom with reverb
- Timer warning: Ticking clock
- Round complete: Fanfare

Ambient:
- Menu: Mystical atmosphere
- Game: Cauldron bubbling
- Victory: Triumphant orchestral
- Defeat: Melancholic strings
```

## Micro-interactions

### Hover States
- Buttons: Slight lift and glow
- Cards: Shadow expansion
- Ingredients: Pulse effect
- Links: Underline animation

### Loading States
- Skeleton screens for content
- Pulsing placeholder elements
- Progress indicators for actions
- Animated logo for long waits

### Feedback Animations
- Success: Checkmark draw animation
- Error: Shake effect
- Points: Number counter animation
- Achievement: Badge flip animation

## Platform-Specific Considerations

### iOS
- Safe area considerations
- Haptic feedback for actions
- iOS-style navigation gestures
- App icon with gradient

### Android
- Material Design influences
- Back button handling
- Status bar theming
- Adaptive icon support

### Web
- Responsive to all screen sizes
- Keyboard shortcuts
- Right-click context menus
- Progressive Web App support

## Future Design Considerations

### Planned Features
1. **Onboarding Flow**: Traditional welcome screens explaining game basics
2. **Achievement Gallery**: Visual display of all 11 achievements
3. **Statistics Dashboard**: Detailed game history and stats (currently backend-only)
4. **Additional Ingredient Sets**: Sets 5+ with new mechanics
5. **Advanced Notifications**: Customizable turn reminders
6. **Friend Profiles**: Detailed view of friends' achievements and stats
7. **Seasonal Events**: Special limited-time game modes

### Scalability
- Modular component system
- Theme switching capability
- Localization support
- Performance optimization for 60fps
- Offline mode considerations

## Additional UI Component Specifications

### Navigation Components

#### App Bar / Navigation Bar
```
Standard App Bar:
- Background: #16213E with subtle gradient overlay
- Height: 56px (mobile), 64px (tablet+)
- Shadow: 0 2px 8px rgba(0,0,0,0.3)
- Title: Caudex Bold 20px, centered
- Back Button: 24x24px icon, left aligned (16px margin)
- Action Icons: 24x24px, right aligned (16px spacing)

Game App Bar:
- Background: Linear gradient (#1A1A2E → #16213E)
- Room info overlay: Semi-transparent card
- Turn indicator: Pulsing gold dot when active
- Timer: Caveat 18px in warning amber when < 10s
- Exit confirmation required for active games

Profile App Bar:
- Background: Same as standard
- Profile image: 32x32px circular, right side
- Notification badge: Gold circle with white text
- Settings gear icon: 24x24px, accessible via profile
```

#### Breadcrumbs
```
Style:
- Font: Caudex Regular 14px
- Color: rgba(255,255,255,0.7)
- Separator: ">" with 8px spacing
- Active: #D4AF37 (Gold)
- Hover: Scale(1.05), color brightens

Layout:
- Height: 32px
- Padding: 8px 16px
- Background: rgba(107,78,150,0.1)
- Border radius: 8px

Navigation paths:
- Home > Friends
- Home > Active Games > Room Lobby
- Game > Round 5 > Evaluation Phase
```

### Feedback Components

#### Snackbars / Toast Notifications
```
Standard Snackbar:
- Background: #16213E with 95% opacity
- Border: 1px solid rgba(107,78,150,0.5)
- Border radius: 12px
- Height: 48px minimum
- Width: 90% max-width 400px
- Position: Bottom center, 16px from edge
- Shadow: 0 4px 12px rgba(0,0,0,0.4)

Variants:
Success Snackbar:
- Left border: 4px solid #4CAF50
- Icon: Checkmark (green)
- Auto dismiss: 3 seconds

Error Snackbar:
- Left border: 4px solid #F44336
- Icon: Warning triangle (red)
- Auto dismiss: 5 seconds
- Action button: "Retry" if applicable

Info Snackbar:
- Left border: 4px solid #2196F3
- Icon: Info circle (blue)
- Auto dismiss: 4 seconds

Game Action Snackbar:
- Left border: 4px solid #D4AF37
- Background: Gradient (#1A1A2E → #16213E)
- Text: Caveat 16px
- Examples: "Ingredient added!", "Pot exploded!", "Round complete!"
```

#### Alert Dialogs
```
Dialog Container:
- Background: #16213E
- Border: 2px solid #6B4E96
- Border radius: 20px
- Width: 90% max-width 400px
- Padding: 24px
- Shadow: 0 8px 24px rgba(0,0,0,0.5)
- Backdrop: rgba(0,0,0,0.6) with blur

Header:
- Icon: 32x32px, centered
- Title: Caudex Bold 20px, centered
- Spacing: 16px below icon

Content:
- Text: Caudex Regular 16px
- Color: rgba(255,255,255,0.9)
- Line height: 1.5
- Text align: Center
- Max 3 lines for mobile

Actions:
- Button layout: Horizontal on tablet+, vertical on mobile
- Primary action: Gold button (right/bottom)
- Secondary: Outlined button (left/top)
- Spacing: 12px between buttons

Variants:
- Confirmation: Warning icon, yellow accent
- Error: Error icon, red accent  
- Success: Checkmark icon, green accent
- Info: Info icon, blue accent
```

#### Loading Spinners and Progress Indicators
```
Primary Spinner:
- Size: 32x32px (default), 24px (small), 48px (large)
- Style: Circular arc with gradient (#6B4E96 → #D4AF37)
- Animation: 360° rotation, 1.2s linear infinite
- Stroke width: 3px
- Background: Transparent arc rgba(107,78,150,0.3)

Magical Spinner:
- Base: Primary spinner
- Particle effects: 6 small dots orbiting
- Glow effect: Subtle outer shadow
- Use for: Game actions, room joining

Progress Bar:
- Height: 8px
- Background: rgba(107,78,150,0.3)
- Fill: Linear gradient (#6B4E96 → #D4AF37)
- Border radius: 4px
- Animation: Smooth fill transition 300ms ease

Loading States:
- Skeleton cards: Shimmer effect, same dimensions as content
- Button loading: Spinner replaces text, maintains size
- Page loading: Full screen spinner with logo
- Content loading: Inline spinners with placeholder text
```

#### Empty States
```
Layout:
- Centered vertically and horizontally
- Illustration: 120x120px
- Spacing: 24px between elements
- Max width: 300px

No Games State:
- Illustration: Empty cauldron with sad bubbles
- Title: Caveat 24px "No Active Games"
- Description: Caudex 16px "Create your first magical brew!"
- Action: Primary button "Create New Game"

No Friends State:
- Illustration: Lonely wizard figure
- Title: Caveat 24px "No Friends Yet"
- Description: Caudex 16px "Add friends to start brewing together"
- Actions: "Add by Code" & "Find Recent Players"

Connection Lost State:
- Illustration: Broken crystal ball
- Title: Caveat 24px "Connection Lost"
- Description: Caudex 16px "Trying to reconnect..."
- Spinner: Small magical spinner
- Action: "Retry Connection" button after 10s

Search No Results:
- Illustration: Magnifying glass over empty space
- Title: Caveat 20px "No Results Found"
- Description: Caudex 14px "Try different search terms"
- Action: "Clear Search" if filter applied
```

### Modal Components

#### Modal Dialogs
```
Modal Container:
- Full screen overlay with backdrop blur
- Backdrop: rgba(0,0,0,0.7)
- Content: Centered, 90% width max 500px
- Entry animation: Slide up 400ms ease-out
- Exit animation: Fade out 200ms ease-in

Content Area:
- Background: #16213E
- Border: 2px solid #6B4E96
- Border radius: 20px
- Padding: 32px 24px
- Shadow: 0 16px 32px rgba(0,0,0,0.6)

Header:
- Close button: Top right, 24x24px X icon
- Title: Caudex Bold 24px, left aligned
- Subtitle: Caudex Regular 16px, muted
- Divider: 1px solid rgba(107,78,150,0.3)

Body:
- Scrollable if content exceeds viewport
- Form fields: Same styling as input specifications
- Lists: Custom styling per content type

Footer:
- Actions aligned right
- Primary + Secondary button pattern
- Cancel always dismisses modal
```

#### Confirmation Dialogs
```
Destructive Actions:
- Red accent color (#F44336)
- Warning icon (triangle with exclamation)
- Clear consequence description
- Primary button: "Delete" / "Leave" / "End" (red)
- Secondary button: "Cancel" (outlined)

Leave Game Confirmation:
- Title: "Leave Game?"
- Content: "You'll lose your progress in this round"
- Primary: "Leave Game" (red)
- Secondary: "Stay" (outlined)

End Game Confirmation:
- Title: "End Game?"
- Content: "This will end the game for all players"
- Primary: "End for Everyone" (red)
- Secondary: "Cancel" (outlined)

Delete Account:
- Title: "Delete Account?"
- Content: "This action cannot be undone. All game data will be lost."
- Input: "Type DELETE to confirm"
- Primary: "Delete Forever" (red, disabled until typed)
- Secondary: "Cancel" (outlined)
```

#### Settings Panels
```
Settings Modal:
- Larger modal: 90% width max 600px
- Tab navigation at top
- Sections: Account, Game, Audio, About

Tab Navigation:
- Background: rgba(107,78,150,0.2)
- Active tab: Solid background #6B4E96
- Tab text: Caudex 16px
- Underline animation for active state

Setting Categories:
Account Settings:
- Profile picture upload
- Display name edit
- Privacy settings
- Account deletion

Game Settings:
- Default timer duration (15s/30s/45s/60s)
- Ingredient set preference (1-4)
- Auto-ready toggle
- Tutorial replay

Audio Settings:
- Master volume slider
- Sound effects toggle
- Background music toggle
- Haptic feedback (mobile)

About:
- Version number
- Developer credits
- Privacy policy link
- Terms of service link

Setting Controls:
- Toggle switches: iOS-style, gold accent
- Sliders: Gold track, white thumb
- Dropdowns: Custom styled, magical theme
- Text inputs: Standard input styling
```

### Status Components

#### Online/Offline Indicators
```
Status Dot:
- Size: 12px diameter
- Position: Bottom right of avatar
- Border: 2px solid background color
- Glow effect for online state

Online Status:
- Color: #4CAF50 (Success Green)
- Glow: 0 0 8px rgba(76,175,80,0.5)
- Pulse animation: 2s ease-in-out infinite

Offline Status:  
- Color: #757575 (Gray)
- No glow or animation
- Semi-transparent (0.7 opacity)

Away Status:
- Color: #FF9800 (Warning Amber)
- Subtle glow: 0 0 4px rgba(255,152,0,0.3)
- No animation

In Game Status:
- Color: #2196F3 (Info Blue)
- Rapid pulse: 1s ease-in-out infinite
- Text label: "In Game" below avatar
```

#### Turn Status Indicators
```
Active Turn:
- Pulsing gold ring around player avatar
- Text: "Your Turn!" in Caveat 16px gold
- Timer: Circular countdown if enabled
- Glow effect: 0 0 12px rgba(212,175,55,0.6)

Waiting Turn:
- Muted avatar border
- Text: "Waiting..." in Caudex 14px muted
- Optional hourglass icon
- Opacity: 0.7

Completed Turn:
- Green checkmark overlay on avatar
- Text: "Ready" in Caudex 14px green
- Border: 2px solid #4CAF50

Disconnected:
- Red warning icon overlay
- Text: "Reconnecting..." in Caudex 14px red
- Blinking animation every 2 seconds
```

#### Achievement Badges
```
Badge Container:
- Size: 64x64px (large), 48x48px (medium), 32x32px (small)
- Background: Circular gradient (#6B4E96 → #D4AF37)
- Border: 2px solid #D4AF37
- Shadow: 0 4px 8px rgba(0,0,0,0.3)

Badge States:
Unlocked:
- Full color and opacity
- Subtle glow effect
- Icon: White or gold
- Animation on unlock: Scale bounce

Locked:
- Grayscale filter
- Opacity: 0.4
- No glow effect
- Icon: Outlined version

Progress Badge:
- Partial fill effect showing progress
- Progress ring: Gold on muted background
- Text: "3/10" in small font below

Badge Categories:
- Victory badges: Trophy icons
- Ingredient badges: Ingredient symbols
- Game milestone badges: Cauldron variations
- Social badges: People icons
- Rare badges: Special magical symbols
```

#### Player Status Indicators
```
Player Card Status:
- Avatar: 48x48px circular
- Status dot: 12x12px bottom right
- Name: Caudex 16px below avatar
- Stats: Wins/Games in Caudex 12px muted

Host Indicator:
- Crown icon: 16x16px gold above avatar
- Text: "Host" in Caveat 12px gold
- Special border: Gold accent on card

Ready Status:
- Green checkmark: 16x16px top right of avatar
- Background tint: rgba(76,175,80,0.1)
- Border: 1px solid #4CAF50

Spectator Mode:
- Eye icon: 16x16px replacing status dot
- Muted appearance: 0.6 opacity
- Label: "Watching" in italics

AFK (Away From Keyboard):
- Clock icon: 16x16px amber
- Auto-timer: Shows remaining time
- Background: rgba(255,152,0,0.1)
- Auto-kick after 5 minutes in active games
```

### List Components

#### List Items for Friends/Games
```
Friend List Item:
- Height: 72px
- Padding: 12px 16px
- Background: rgba(22,33,62,0.6)
- Border bottom: 1px solid rgba(107,78,150,0.2)
- Hover: Background brightens to rgba(22,33,62,0.8)

Layout:
- Avatar: 48x48px left
- Status dot: On avatar
- Name: Caudex 16px, primary position
- Stats: "Won 12 | Played 45" Caudex 12px muted
- Action button: Right aligned, 32px icon
- Last seen: Below stats if offline

Game List Item:
- Height: 96px  
- Same background and hover as friends
- Room name: Caudex Bold 16px
- Game info: "Round 3/9" Caudex 14px
- Player count: "3/4 players" with avatars
- Status: "Your turn!" or "Waiting..." with colored dot
- Join/Resume button: Primary button small size

Interaction States:
- Press: Scale(0.98) 100ms
- Loading: Skeleton placeholder animation
- Disabled: 0.5 opacity, no hover
- Selected: Border left 4px gold
```

#### Player List Items
```
Game Lobby Player:
- Height: 64px
- Avatar: 40x40px
- Ready checkbox: Right side
- Kick button: Host only, confirmation required
- Invite button: Empty slots only

In-Game Player Status:
- Compact height: 48px
- Score display: Current round points
- Turn indicator: Pulsing border
- Quick stats: Chips drawn, pot total
- Explosion indicator: Red tint if exploded

Leaderboard Item:  
- Height: 56px
- Rank: Large number left (1st, 2nd, 3rd)
- Medal icons: Gold/Silver/Bronze
- Final score: Bold right aligned
- Achievement count: Small text below name
```

#### Game History Items
```
History Item:
- Height: 80px
- Game outcome: Win/Loss indicator
- Date: "2 days ago" format
- Players: Participant avatars (max 4 shown)
- Final rank: "#2 of 4"
- Rematch button: If friends still available

Expandable Details:
- Tap to expand full game stats
- Round by round scoring
- Ingredients used counts
- Play time duration
- Screenshot of final board (if available)

List Behaviors:
- Infinite scroll: Load more on bottom reach
- Pull to refresh: Sync latest games
- Search filter: By player name or date range
- Sort options: Recent, Best rank, Longest games
```

## Implementation Guidelines for Flutter

### Widget Hierarchy
```dart
// Navigation Components
CalderumAppBar extends AppBar
CalderumBreadcrumbs extends StatelessWidget

// Feedback Components  
CalderumSnackBar extends SnackBar
CalderumDialog extends Dialog
CalderumLoader extends StatelessWidget
CalderumEmptyState extends StatelessWidget

// Modal Components
CalderumModal extends StatefulWidget
CalderumConfirmDialog extends CalderumDialog
CalderumSettingsPanel extends CalderumModal

// Status Components
StatusDot extends StatelessWidget
TurnIndicator extends AnimatedWidget
AchievementBadge extends StatelessWidget
PlayerStatusCard extends StatelessWidget

// List Components
CalderumListItem extends ListTile
FriendListItem extends CalderumListItem
GameListItem extends CalderumListItem
```

### Theme Extensions
```dart
extension CalderumColors on ColorScheme {
  Color get magicPurple => Color(0xFF6B4E96);
  Color get mysticalGold => Color(0xFFD4AF37);
  Color get darkSurface => Color(0xFF16213E);
  Color get darkBackground => Color(0xFF1A1A2E);
}

extension CalderumTextStyles on TextTheme {
  TextStyle get caudexHeading => GoogleFonts.caudex(
    fontSize: 24, fontWeight: FontWeight.bold);
  TextStyle get caveatMagical => GoogleFonts.caveat(
    fontSize: 20, fontWeight: FontWeight.w500);
}
```

### Accessibility Implementation
```dart
// Semantic labels for all interactive elements
// Custom focus management for complex widgets
// High contrast mode support
// Screen reader announcements for status changes
// Reduced motion support for animations
```

## Design System Maintenance

### Documentation
- This design.md file serves as the primary design reference
- Component specifications defined in code comments
- Animation timings documented inline with implementations
- Accessibility guidelines followed during development

### Design Updates
- Design changes tracked through Git commits
- Major design updates documented in this file
- Component changes communicated through code reviews

This design document serves as the single source of truth for all UI/UX decisions in Calderum, ensuring consistency and quality across the entire gaming experience.

## Mobile Game Board Optimization

### 1. **Responsive Game Board Design**

The 33-space cauldron presents a significant challenge for mobile devices. Our solution employs multiple adaptive strategies to maintain gameplay clarity while ensuring usability.

#### Adaptive Cauldron Layouts

```dart
// Breakpoint-specific game board configurations
class GameBoardConfig {
  static const Map<ScreenSize, BoardLayout> layouts = {
    ScreenSize.small: BoardLayout(
      potSize: Size(280, 320),
      chipSize: 28.0,
      spacingRatio: 0.8,
      layout: BoardLayoutType.compactSpiral,
    ),
    ScreenSize.medium: BoardLayout(
      potSize: Size(340, 380),
      chipSize: 32.0,
      spacingRatio: 1.0,
      layout: BoardLayoutType.standardCircular,
    ),
    ScreenSize.large: BoardLayout(
      potSize: Size(400, 450),
      chipSize: 36.0,
      spacingRatio: 1.2,
      layout: BoardLayoutType.expandedCircular,
    ),
  };
}

enum BoardLayoutType {
  compactSpiral,     // Tight spiral for small screens
  standardCircular,  // Traditional circular arrangement
  expandedCircular,  // Spacious circular for tablets
  linearSegmented,   // Alternative linear arrangement
}
```

#### Alternative Compact Layouts for Mobile (320px-768px)

```
Compact Spiral Layout (320-480px):
┌─────────────────────────┐
│   Cauldron Pot View     │
│ ┌─────────────────────┐ │
│ │    🔵 Start (0)     │ │
│ │  ⚪①→🟠②→🟡③→⚪④   │ │
│ │  ↑                ↓ │ │
│ │ 🟣⑫              🟢⑤ │ │
│ │  ↑    Center     ↓  │ │
│ │ ⚫⑪←🔴⑩←🟡⑨←🔵⑥  │ │
│ │   🟠⑧←⚪⑦         │ │
│ │                     │ │
│ │ Continue 13→33...   │ │
│ │ [View More Spaces]  │ │
│ └─────────────────────┘ │
│                         │
│ Current: Space 9 (🔵6)  │
│ White Total: 5/7        │
│ [Draw] [Stop] [Expand]  │
└─────────────────────────┘

Segmented Linear Layout (Alternative):
┌─────────────────────────┐
│ Spaces 1-11: Early Game │
│ ⚪①🟠②🟡③⚪④🟢⑤🔵⑥⚪⑦🟠⑧🟡⑨🔴⑩⚫⑪ │
│                         │
│ Spaces 12-22: Mid Game  │
│ 🟣⑫⚪⑬🟠⑭🟡⑮⚪⑯🟢⑰🔵⑱⚪⑲🟠⑳🟡㉑🔴㉒ │
│                         │
│ Spaces 23-33: End Game  │
│ ⚫㉓🟣㉔⚪㉕🟠㉖🟡㉗⚪㉘🟢㉙🔵㉚⚪㉛🟠㉜🔴㉝ │
│                         │
│ Current Section: Mid    │
│ Auto-scroll to position │
└─────────────────────────┘
```

#### Dynamic Space Arrangement Strategies

```dart
class AdaptiveGameBoard extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final config = _getOptimalConfig(screenSize);
    
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: _buildBoardLayout(config),
    );
  }
  
  Widget _buildBoardLayout(BoardConfig config) {
    switch (config.layoutType) {
      case BoardLayoutType.compactSpiral:
        return CompactSpiralBoard(config: config);
      case BoardLayoutType.linearSegmented:
        return LinearSegmentedBoard(config: config);
      case BoardLayoutType.standardCircular:
        return CircularBoard(config: config);
    }
  }
}

// Compact spiral implementation for smallest screens
class CompactSpiralBoard extends StatelessWidget {
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main pot container
        Container(
          width: config.potSize.width,
          height: config.potSize.height,
          child: CustomPaint(
            painter: SpiralPathPainter(
              spaces: gameState.potSpaces,
              chipSize: config.chipSize,
              currentSpace: gameState.currentSpace,
            ),
          ),
        ),
        
        // Expandable overlay for detailed view
        if (showExpandedView)
          ExpandedBoardOverlay(
            onCollapse: () => setState(() => showExpandedView = false),
          ),
        
        // Quick access to current section
        Positioned(
          bottom: 8,
          right: 8,
          child: FloatingActionButton.small(
            onPressed: _showExpandedView,
            child: Icon(Icons.zoom_in),
            tooltip: 'View full board',
          ),
        ),
      ],
    );
  }
}
```

#### Collapsible/Expandable Sections for Complex Information

```dart
class ExpandableGameInfo extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Always visible essential info
        EssentialInfoBar(
          currentSpace: gameState.currentSpace,
          whiteTotal: gameState.whiteChipTotal,
          canDraw: gameState.canDrawMore,
        ),
        
        // Expandable detailed sections
        ExpansionTile(
          title: Text('Pot Contents'),
          leading: Icon(Icons.list),
          children: [
            PotContentsGrid(chips: gameState.potChips),
          ],
        ),
        
        ExpansionTile(
          title: Text('Other Players'),
          leading: Icon(Icons.people),
          children: [
            for (final player in gameState.otherPlayers)
              PlayerStatusTile(player: player),
          ],
        ),
        
        ExpansionTile(
          title: Text('Round Info'),
          leading: Icon(Icons.info),
          children: [
            RoundInfoPanel(round: gameState.currentRound),
          ],
        ),
      ],
    );
  }
}

// Essential info always visible
class EssentialInfoBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InfoChip(
            icon: Icons.location_on,
            label: 'Space $currentSpace',
            color: Colors.blue,
          ),
          InfoChip(
            icon: Icons.warning,
            label: 'White: $whiteTotal/7',
            color: whiteTotal >= 6 ? Colors.red : Colors.orange,
          ),
          InfoChip(
            icon: canDraw ? Icons.casino : Icons.stop,
            label: canDraw ? 'Can Draw' : 'Must Stop',
            color: canDraw ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
```

#### Portrait vs Landscape Mode Optimizations

```dart
class OrientationAwareGameBoard extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
          ? PortraitGameLayout()
          : LandscapeGameLayout();
      },
    );
  }
}

// Portrait: Vertical stack layout
class PortraitGameLayout extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Compact header
        GameHeaderCompact(),
        
        // Main pot view (60% of screen)
        Expanded(
          flex: 3,
          child: Center(
            child: AdaptiveGameBoard(),
          ),
        ),
        
        // Player actions (25% of screen)
        Expanded(
          flex: 2,
          child: GameActionsPanel(),
        ),
        
        // Status bar (15% of screen)
        Expanded(
          flex: 1,
          child: GameStatusBar(),
        ),
      ],
    );
  }
}

// Landscape: Horizontal split layout
class LandscapeGameLayout extends StatelessWidget {
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Pot and status (70% width)
        Expanded(
          flex: 7,
          child: Column(
            children: [
              GameHeaderCompact(),
              Expanded(child: AdaptiveGameBoard()),
              GameStatusBar(),
            ],
          ),
        ),
        
        // Actions and info sidebar (30% width)
        Expanded(
          flex: 3,
          child: GameSidebar(),
        ),
      ],
    );
  }
}
```

### 2. **Touch Interaction Improvements**

#### Enhanced Touch Targets for Small Ingredient Chips

```dart
class TouchOptimizedIngredientChip extends StatelessWidget {
  final double visualSize;    // Actual chip appearance
  final double touchSize;     // Minimum touch target
  
  const TouchOptimizedIngredientChip({
    required this.ingredient,
    this.visualSize = 28.0,
    this.touchSize = 48.0,  // Exceeds accessibility minimum
  });
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Container(
        width: touchSize,
        height: touchSize,
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          width: _isPressed ? visualSize * 0.9 : visualSize,
          height: _isPressed ? visualSize * 0.9 : visualSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ingredient.color,
            border: Border.all(
              color: _isPressed ? Colors.gold : Colors.white,
              width: _isPressed ? 3 : 2,
            ),
            boxShadow: [
              if (_isPressed)
                BoxShadow(
                  color: Colors.gold.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Icon(
            ingredient.icon,
            size: visualSize * 0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  
  void _handleTapDown(TapDownDetails details) {
    // Haptic feedback
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
  }
}
```

#### Gesture-Based Interactions for Game Elements

```dart
class GestureEnhancedGameBoard extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Pan gestures for board navigation
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      
      // Scale gestures for zoom
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      
      // Long press for detailed info
      onLongPress: _showSpaceDetails,
      
      child: InteractiveViewer(
        minScale: 0.8,
        maxScale: 2.5,
        boundaryMargin: EdgeInsets.all(20),
        constrained: false,
        child: GameBoardWidget(),
      ),
    );
  }
  
  void _handlePanUpdate(DragUpdateDetails details) {
    // Scroll through pot spaces with finger drag
    final delta = details.delta.dx;
    if (delta.abs() > 10) {
      final direction = delta > 0 ? 1 : -1;
      _scrollToSpace(_currentViewSpace + direction);
      HapticFeedback.selectionClick();
    }
  }
  
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    // Zoom in/out on game board
    final scale = details.scale;
    if (scale != 1.0) {
      _updateBoardScale(scale);
      // Provide haptic feedback at zoom thresholds
      if (_shouldProvideScaleHaptic(scale)) {
        HapticFeedback.mediumImpact();
      }
    }
  }
}

// Drag and drop for ingredient placement
class DraggableIngredientChip extends StatefulWidget {
  Widget build(BuildContext context) {
    return Draggable<IngredientData>(
      data: ingredient,
      feedback: DragFeedbackWidget(ingredient: ingredient),
      childWhenDragging: DragPlaceholderWidget(),
      onDragStarted: () {
        HapticFeedback.mediumImpact();
        _showDropTargets();
      },
      onDragEnd: (details) {
        _hideDropTargets();
        if (!details.wasAccepted) {
          HapticFeedback.heavyImpact(); // Feedback for failed drop
        }
      },
      child: IngredientChipWidget(ingredient: ingredient),
    );
  }
}

class PotDropTarget extends StatefulWidget {
  Widget build(BuildContext context) {
    return DragTarget<IngredientData>(
      onWillAccept: (data) => _canAcceptIngredient(data),
      onAccept: (data) {
        HapticFeedback.mediumImpact();
        _addIngredientToPot(data);
        _showAdditionAnimation();
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            border: Border.all(
              color: candidateData.isNotEmpty 
                ? Colors.green 
                : Colors.transparent,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: PotSpaceWidget(),
        );
      },
    );
  }
}
```

#### Conflict Resolution Between Game and System Gestures

```dart
class GestureConflictResolver extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        // Custom recognizer that doesn't conflict with system gestures
        CustomPanGestureRecognizer: GestureRecognizerFactoryWithHandlers<
          CustomPanGestureRecognizer>(
          () => CustomPanGestureRecognizer(),
          (instance) {
            instance.onStart = _handleGamePanStart;
            instance.onUpdate = _handleGamePanUpdate;
            instance.onEnd = _handleGamePanEnd;
          },
        ),
        
        // Delayed long press to avoid conflicts with scroll
        DelayedLongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<
          DelayedLongPressGestureRecognizer>(
          () => DelayedLongPressGestureRecognizer(
            duration: Duration(milliseconds: 600), // Longer than system
          ),
          (instance) {
            instance.onLongPress = _handleGameLongPress;
          },
        ),
      },
      child: GameContent(),
    );
  }
}

// Custom pan recognizer that works within game bounds
class CustomPanGestureRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    // Only accept gestures within game area
    if (_isWithinGameBounds(event.localPosition)) {
      super.addAllowedPointer(event);
    }
  }
  
  @override
  void handleEvent(PointerEvent event) {
    // Prevent conflicts with system back gesture
    if (_isSystemBackGesture(event)) {
      return;
    }
    super.handleEvent(event);
  }
  
  bool _isSystemBackGesture(PointerEvent event) {
    // Check if gesture starts from edge and moves right (Android back)
    return event is PointerMoveEvent &&
           event.localPosition.dx < 20 &&
           event.delta.dx > 0;
  }
}
```

#### Haptic Feedback Patterns for Game Actions

```dart
class GameHapticFeedback {
  // Different haptic patterns for different game actions
  static const Map<GameAction, HapticPattern> patterns = {
    GameAction.drawChip: HapticPattern.light,
    GameAction.placeChip: HapticPattern.medium,
    GameAction.potExplosion: HapticPattern.heavy,
    GameAction.roundComplete: HapticPattern.success,
    GameAction.turnStart: HapticPattern.notification,
    GameAction.warningState: HapticPattern.warning,
  };
  
  static void performHaptic(GameAction action) {
    if (!_hapticEnabled) return;
    
    switch (patterns[action]) {
      case HapticPattern.light:
        HapticFeedback.lightImpact();
        break;
      case HapticPattern.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticPattern.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticPattern.success:
        _playSuccessPattern();
        break;
      case HapticPattern.warning:
        _playWarningPattern();
        break;
    }
  }
  
  // Custom haptic patterns
  static void _playSuccessPattern() async {
    HapticFeedback.lightImpact();
    await Future.delayed(Duration(milliseconds: 100));
    HapticFeedback.mediumImpact();
  }
  
  static void _playWarningPattern() async {
    for (int i = 0; i < 3; i++) {
      HapticFeedback.lightImpact();
      await Future.delayed(Duration(milliseconds: 150));
    }
  }
}

// Haptic settings in preferences
class HapticSettings extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text('Haptic Feedback'),
          subtitle: Text('Vibration for game actions'),
          value: settings.hapticEnabled,
          onChanged: (value) => settings.setHapticEnabled(value),
        ),
        
        if (settings.hapticEnabled)
          SliderListTile(
            title: Text('Haptic Intensity'),
            min: 0.2,
            max: 1.0,
            value: settings.hapticIntensity,
            onChanged: (value) => settings.setHapticIntensity(value),
          ),
      ],
    );
  }
}
```

### 3. **Information Hierarchy on Small Screens**

#### Progressive Disclosure for Game Information

```dart
class ProgressiveGameInformation extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Level 1: Critical information always visible
        CriticalInfoBar(
          whiteChipCount: gameState.whiteChips,
          currentSpace: gameState.position,
          canDraw: gameState.canDrawMore,
        ),
        
        // Level 2: Important info, collapsible on small screens
        if (MediaQuery.of(context).size.width > 400)
          ImportantInfoPanel()
        else
          CollapsibleInfoPanel(
            title: 'Game Details',
            child: ImportantInfoPanel(),
          ),
        
        // Level 3: Detailed info, accessible via modal
        InfoDisclosureButton(
          onPressed: _showDetailedInfo,
          label: 'View All Details',
        ),
      ],
    );
  }
}

// Critical info that's always visible
class CriticalInfoBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Space indicator with visual progress
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Space $currentSpace', 
                     style: Theme.of(context).textTheme.titleSmall),
                LinearProgressIndicator(
                  value: currentSpace / 33.0,
                  backgroundColor: Colors.grey[700],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              ],
            ),
          ),
          
          SizedBox(width: 16),
          
          // White chip warning
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getWhiteChipWarningColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, size: 16, color: Colors.white),
                SizedBox(width: 4),
                Text('$whiteChipCount/7', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
          ),
          
          SizedBox(width: 16),
          
          // Action status
          Icon(
            canDraw ? Icons.casino : Icons.stop,
            color: canDraw ? Colors.green : Colors.red,
            size: 24,
          ),
        ],
      ),
    );
  }
  
  Color _getWhiteChipWarningColor() {
    if (whiteChipCount >= 6) return Colors.red;
    if (whiteChipCount >= 4) return Colors.orange;
    return Colors.grey[600]!;
  }
}
```

#### Contextual Overlays and Bottom Sheets

```dart
class ContextualGameOverlay extends StatelessWidget {
  final OverlayType type;
  final Widget child;
  
  Widget build(BuildContext context) {
    switch (type) {
      case OverlayType.spaceDetails:
        return SpaceDetailsOverlay();
      case OverlayType.playerStatus:
        return PlayerStatusOverlay();
      case OverlayType.gameRules:
        return GameRulesOverlay();
    }
  }
}

// Bottom sheet for detailed game information
class GameDetailsBottomSheet extends StatelessWidget {
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar for dragging
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Content tabs
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: 'Pot', icon: Icon(Icons.local_drink)),
                          Tab(text: 'Players', icon: Icon(Icons.people)),
                          Tab(text: 'Rules', icon: Icon(Icons.help)),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            PotDetailsView(controller: scrollController),
                            PlayersStatusView(controller: scrollController),
                            GameRulesView(controller: scrollController),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Space-specific overlay for detailed information
class SpaceDetailsOverlay extends StatelessWidget {
  final int spaceNumber;
  
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _dismissOverlay,
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent dismissal when tapping content
              child: Container(
                margin: EdgeInsets.all(32),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Space number and type
                    Text('Space $spaceNumber',
                         style: Theme.of(context).textTheme.headlineSmall),
                    
                    SizedBox(height: 16),
                    
                    // Visual representation of space
                    SpaceVisualization(spaceNumber: spaceNumber),
                    
                    SizedBox(height: 16),
                    
                    // Space effects and scoring
                    SpaceEffectsDescription(spaceNumber: spaceNumber),
                    
                    SizedBox(height: 24),
                    
                    // Close button
                    ElevatedButton(
                      onPressed: _dismissOverlay,
                      child: Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

#### Simplified Turn Indicators and Status Displays

```dart
class SimplifiedTurnIndicator extends StatelessWidget {
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: _buildCurrentIndicator(),
    );
  }
  
  Widget _buildCurrentIndicator() {
    switch (gameState.turnStatus) {
      case TurnStatus.yourTurn:
        return YourTurnIndicator();
      case TurnStatus.waiting:
        return WaitingIndicator();
      case TurnStatus.evaluating:
        return EvaluatingIndicator();
    }
  }
}

class YourTurnIndicator extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.gold, Colors.amber],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.gold.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_circle_fill, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text('Your Turn!', style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
          if (gameState.hasTimer) ...[
            SizedBox(width: 12),
            CircularProgressIndicator(
              value: gameState.timerProgress,
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          ],
        ],
      ),
    );
  }
}

class WaitingIndicator extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          SizedBox(width: 8),
          Text('Waiting for ${gameState.activePlayerName}...', 
               style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
```

#### Smart Hiding/Showing of Secondary Information

```dart
class AdaptiveInformationDisplay extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine information priority based on available space
        final infoLevel = _determineInformationLevel(constraints);
        
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _buildInformationForLevel(infoLevel),
        );
      },
    );
  }
  
  InformationLevel _determineInformationLevel(BoxConstraints constraints) {
    final availableSpace = constraints.maxWidth * constraints.maxHeight;
    
    if (availableSpace < 200000) return InformationLevel.minimal;      // <320x625
    if (availableSpace < 350000) return InformationLevel.essential;    // <375x933
    if (availableSpace < 500000) return InformationLevel.standard;     // <414x1208
    return InformationLevel.comprehensive;                             // Larger screens
  }
  
  Widget _buildInformationForLevel(InformationLevel level) {
    switch (level) {
      case InformationLevel.minimal:
        return MinimalInfoDisplay();       // Only critical game state
      case InformationLevel.essential:
        return EssentialInfoDisplay();     // Critical + player status
      case InformationLevel.standard:
        return StandardInfoDisplay();      // Essential + round info
      case InformationLevel.comprehensive:
        return ComprehensiveInfoDisplay(); // All information visible
    }
  }
}

class MinimalInfoDisplay extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Only the most critical information
        CriticalInfoBar(),
        
        // Quick access to hidden information
        GestureDetector(
          onTap: () => _showExpandedInfo(context),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.expand_more, size: 16),
                SizedBox(width: 4),
                Text('More Info', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Auto-hide secondary info during active gameplay
class AutoHidingSecondaryInfo extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameEvent>(
      stream: gameState.eventStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _handleGameEvent(snapshot.data!);
        }
        
        return AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _shouldShowSecondaryInfo ? 1.0 : 0.0,
          child: SecondaryInfoPanel(),
        );
      },
    );
  }
  
  void _handleGameEvent(GameEvent event) {
    switch (event.type) {
      case GameEventType.turnStart:
        // Show all info at turn start
        _shouldShowSecondaryInfo = true;
        _startAutoHideTimer();
        break;
      case GameEventType.chipDrawn:
        // Hide secondary info during active drawing
        _shouldShowSecondaryInfo = false;
        break;
      case GameEventType.turnEnd:
        // Show info again at turn end
        _shouldShowSecondaryInfo = true;
        break;
    }
  }
  
  void _startAutoHideTimer() {
    Timer(Duration(seconds: 5), () {
      if (gameState.isPlayerTurn && gameState.isActivelyPlaying) {
        setState(() => _shouldShowSecondaryInfo = false);
      }
    });
  }
}
```

### 4. **Mobile-First Component Variations**

#### Condensed Player Status Displays

```dart
class CondensedPlayerStatus extends StatelessWidget {
  final List<Player> players;
  
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: players.length,
        itemBuilder: (context, index) {
          return CondensedPlayerCard(player: players[index]);
        },
      ),
    );
  }
}

class CondensedPlayerCard extends StatelessWidget {
  final Player player;
  
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getPlayerStatusColor().withOpacity(0.2),
        border: Border.all(color: _getPlayerStatusColor()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Avatar with status overlay
          Stack(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(player.avatarUrl),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getPlayerStatusColor(),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 4),
          
          // Name (truncated if too long)
          Text(
            player.displayName,
            style: TextStyle(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Essential status info only
          if (player.isCurrentTurn)
            Icon(Icons.play_arrow, size: 12, color: Colors.gold)
          else if (player.hasExploded)
            Icon(Icons.warning, size: 12, color: Colors.red)
          else
            Text('${player.currentSpace}', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
  
  Color _getPlayerStatusColor() {
    if (player.isCurrentTurn) return Colors.gold;
    if (player.hasExploded) return Colors.red;
    if (player.isOnline) return Colors.green;
    return Colors.grey;
  }
}
```

#### Compact Game Card Layouts

```dart
class CompactGameCard extends StatelessWidget {
  final GameRoom room;
  
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => _joinGame(room),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Game status icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getGameStatusColor(),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getGameStatusIcon(),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              
              SizedBox(width: 12),
              
              // Game information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room name and round
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            room.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'Round ${room.currentRound}/9',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 2),
                    
                    // Players and status
                    Row(
                      children: [
                        // Player avatars (max 3 visible)
                        SizedBox(
                          width: 60,
                          height: 20,
                          child: Stack(
                            children: [
                              for (int i = 0; i < math.min(3, room.players.length); i++)
                                Positioned(
                                  left: i * 15.0,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundImage: NetworkImage(room.players[i].avatarUrl),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        SizedBox(width: 8),
                        
                        // Player count and status
                        Expanded(
                          child: Text(
                            '${room.players.length}/${room.maxPlayers} • ${_getGameStatusText()}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 8),
              
              // Action button/indicator
              _buildActionWidget(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionWidget() {
    if (room.isPlayerTurn) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.gold,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Your Turn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[600],
      );
    }
  }
}
```

#### Simplified Navigation Patterns

```dart
class MobileNavigationShell extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(),
          FriendsPage(),
          GamesPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.gold,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Theme.of(context).cardColor,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.people),
                if (_hasUnreadFriendRequests)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.gamepad),
                if (_hasActiveGames)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Simplified app bar for mobile
class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBackButton 
        ? BackButton()
        : null,
      title: Text(
        title,
        style: GoogleFonts.caudex(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: actions?.map((action) => 
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: action,
        ),
      ).toList(),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
```

#### Touch-Optimized Button and Control Sizes

```dart
class TouchOptimizedControls {
  static const double minTouchTarget = 48.0;
  static const double comfortableTouchTarget = 56.0;
  static const double largeTouchTarget = 64.0;
  
  // Button size based on importance and frequency of use
  static Size getButtonSize(ButtonImportance importance) {
    switch (importance) {
      case ButtonImportance.critical:
        return Size(200, largeTouchTarget);      // Main game actions
      case ButtonImportance.primary:
        return Size(160, comfortableTouchTarget); // Secondary actions
      case ButtonImportance.secondary:
        return Size(120, minTouchTarget);        // Utility actions
    }
  }
}

class TouchOptimizedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonImportance importance;
  final IconData? icon;
  
  Widget build(BuildContext context) {
    final size = TouchOptimizedControls.getButtonSize(importance);
    
    return Container(
      width: size.width,
      height: size.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: importance == ButtonImportance.critical ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Game-specific touch controls
class GameActionControls extends StatelessWidget {
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary game action (largest)
          TouchOptimizedButton(
            label: gameState.canDraw ? 'Draw Chip' : 'Cannot Draw',
            icon: gameState.canDraw ? Icons.casino : Icons.block,
            importance: ButtonImportance.critical,
            onPressed: gameState.canDraw ? _drawChip : null,
          ),
          
          SizedBox(height: 12),
          
          // Secondary actions row
          Row(
            children: [
              Expanded(
                child: TouchOptimizedButton(
                  label: 'Stop Brewing',
                  icon: Icons.stop,
                  importance: ButtonImportance.primary,
                  onPressed: _stopBrewing,
                ),
              ),
              
              SizedBox(width: 12),
              
              Expanded(
                child: TouchOptimizedButton(
                  label: 'View Details',
                  icon: Icons.info,
                  importance: ButtonImportance.secondary,
                  onPressed: _showDetails,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### 5. **Performance Considerations**

#### Optimized Rendering for Complex Game Boards

```dart
class OptimizedGameBoardRenderer extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: GameBoardPainter(
          gameState: gameState,
          config: boardConfig,
          // Only repaint when essential data changes
          repaint: gameState.renderingNotifier,
        ),
        child: GameBoardInteractionLayer(),
      ),
    );
  }
}

class GameBoardPainter extends CustomPainter {
  final GameState gameState;
  final BoardConfig config;
  
  @override
  void paint(Canvas canvas, Size size) {
    // Use efficient rendering techniques
    _paintWithOptimizations(canvas, size);
  }
  
  void _paintWithOptimizations(Canvas canvas, Size size) {
    // Cache frequently used paint objects
    final chipPaint = Paint()..isAntiAlias = false; // Disable for performance
    final shadowPaint = Paint()..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    
    // Batch similar drawing operations
    _paintAllChipsOfSameType(canvas, chipPaint);
    _paintShadowsInBatch(canvas, shadowPaint);
    
    // Use layers for complex effects only when necessary
    if (_needsComplexEffects()) {
      _paintWithLayers(canvas, size);
    } else {
      _paintDirectly(canvas, size);
    }
  }
  
  @override
  bool shouldRepaint(GameBoardPainter oldDelegate) {
    // Only repaint when visual state actually changes
    return gameState.visualStateHash != oldDelegate.gameState.visualStateHash;
  }
}

// Efficient ingredient chip rendering
class IngredientChipCache {
  static final Map<String, ui.Picture> _chipCache = {};
  
  static ui.Picture getChip(IngredientType type, double size) {
    final key = '${type.name}_$size';
    
    if (!_chipCache.containsKey(key)) {
      _chipCache[key] = _renderChip(type, size);
    }
    
    return _chipCache[key]!;
  }
  
  static ui.Picture _renderChip(IngredientType type, double size) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Render chip once and cache
    _drawIngredientChip(canvas, type, size);
    
    return recorder.endRecording();
  }
  
  // Clear cache when memory pressure is high
  static void clearCache() {
    _chipCache.clear();
  }
}
```

#### Efficient Scrolling and Panning Mechanisms

```dart
class EfficientGameBoardScroller extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(), // Prevent over-scroll
        controller: _scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: GameBoardContent(),
        ),
      ),
    );
  }
  
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      // Optimize rendering during scroll
      _updateVisibleRegion(notification.metrics.pixels);
      
      // Reduce animation frame rate during heavy scrolling
      if (notification.dragDetails?.delta.distance.abs() ?? 0 > 10) {
        _setReducedFrameRate(true);
      }
    } else if (notification is ScrollEndNotification) {
      // Restore full frame rate when scrolling stops
      _setReducedFrameRate(false);
    }
    
    return false;
  }
  
  void _updateVisibleRegion(double scrollOffset) {
    // Only render game elements in visible area + buffer
    final visibleTop = scrollOffset - 100;
    final visibleBottom = scrollOffset + MediaQuery.of(context).size.height + 100;
    
    gameState.setVisibleRegion(visibleTop, visibleBottom);
  }
}

// Viewport-based culling for off-screen elements
class ViewportCulledGameElement extends StatelessWidget {
  final Widget child;
  final Rect elementBounds;
  
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Rect.fromLTWH(0, 0, constraints.maxWidth, constraints.maxHeight);
        
        // Only render if element intersects with viewport
        if (!viewport.overlaps(elementBounds)) {
          return SizedBox.shrink(); // Render nothing for off-screen elements
        }
        
        return child;
      },
    );
  }
}
```

#### Battery-Conscious Animations and Effects

```dart
class BatteryOptimizedAnimations {
  static bool _reducedAnimations = false;
  
  static void initialize() {
    // Check device battery level and power mode
    _checkBatteryStatus();
    
    // Listen for power mode changes
    _listenToPowerModeChanges();
  }
  
  static Duration getAnimationDuration(Duration standard) {
    if (_reducedAnimations) {
      return Duration(milliseconds: (standard.inMilliseconds * 0.5).round());
    }
    return standard;
  }
  
  static bool shouldPlayParticleEffects() {
    return !_reducedAnimations && _batteryLevel > 0.3;
  }
  
  static bool shouldUseShadowEffects() {
    return !_reducedAnimations && !_isLowPowerMode;
  }
}

class OptimizedGameAnimation extends StatefulWidget {
  final Widget child;
  final AnimationType type;
  
  @override
  Widget build(BuildContext context) {
    final duration = BatteryOptimizedAnimations.getAnimationDuration(
      _getStandardDuration(),
    );
    
    // Skip expensive animations on low battery
    if (!_shouldAnimate()) {
      return child;
    }
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
  
  bool _shouldAnimate() {
    switch (type) {
      case AnimationType.critical:
        return true; // Always animate critical feedback
      case AnimationType.feedback:
        return BatteryOptimizedAnimations.shouldPlayParticleEffects();
      case AnimationType.decorative:
        return !BatteryOptimizedAnimations._reducedAnimations;
    }
  }
}

// Smart frame rate adjustment
class AdaptiveFrameRateManager {
  static int _currentTargetFPS = 60;
  
  static void adjustFrameRate(GamePerformanceMetrics metrics) {
    if (metrics.averageFrameTime > 16.67) { // Dropping below 60fps
      _reduceFrameRate();
    } else if (metrics.memoryPressure > 0.8) {
      _reduceFrameRate();
    } else if (_canIncreaseFrameRate(metrics)) {
      _increaseFrameRate();
    }
  }
  
  static void _reduceFrameRate() {
    if (_currentTargetFPS > 30) {
      _currentTargetFPS = math.max(30, _currentTargetFPS - 15);
      _applyFrameRateLimit();
    }
  }
  
  static void _applyFrameRateLimit() {
    // Use Flutter's frame rate limiting when available
    if (Platform.isAndroid || Platform.isIOS) {
      // Platform-specific frame rate adjustment
      _platformFrameRateControl(_currentTargetFPS);
    }
  }
}
```

#### Memory Management for Game State Visualization

```dart
class GameStateMemoryManager {
  static final int maxCachedStates = 10;
  static final Queue<GameStateSnapshot> _stateHistory = Queue();
  static final Map<String, ui.Image> _imageCache = {};
  
  static void addGameState(GameStateSnapshot state) {
    _stateHistory.addLast(state);
    
    // Keep only recent states to limit memory usage
    while (_stateHistory.length > maxCachedStates) {
      final oldState = _stateHistory.removeFirst();
      oldState.dispose(); // Clean up resources
    }
  }
  
  // Efficient image caching for game assets
  static Future<ui.Image> getCachedImage(String assetPath) async {
    if (_imageCache.containsKey(assetPath)) {
      return _imageCache[assetPath]!;
    }
    
    final image = await _loadImage(assetPath);
    
    // Limit cache size to prevent memory issues
    if (_imageCache.length >= 50) {
      _evictOldestImages(10);
    }
    
    _imageCache[assetPath] = image;
    return image;
  }
  
  static void _evictOldestImages(int count) {
    final keysToRemove = _imageCache.keys.take(count).toList();
    for (final key in keysToRemove) {
      _imageCache[key]?.dispose();
      _imageCache.remove(key);
    }
  }
  
  // Memory pressure handling
  static void handleMemoryPressure() {
    // Clear non-essential caches
    _imageCache.clear();
    IngredientChipCache.clearCache();
    
    // Force garbage collection
    Future.delayed(Duration.zero, () {
      // This helps trigger garbage collection
      List.generate(100, (i) => Object()).clear();
    });
  }
}

// Lazy loading for complex game elements
class LazyLoadedGameElement extends StatefulWidget {
  final Widget Function() builder;
  final bool isVisible;
  
  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return SizedBox.shrink();
    }
    
    return FutureBuilder<Widget>(
      future: _loadElement(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        return LoadingPlaceholder();
      },
    );
  }
  
  Future<Widget> _loadElement() async {
    // Load heavy elements asynchronously
    await Future.delayed(Duration(milliseconds: 1));
    return builder();
  }
}
```

### 6. **User Experience Patterns**

#### Mobile-Specific Onboarding Flows

```dart
class MobileOnboardingFlow extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        OnboardingScreen(
          title: 'Welcome to Calderum!',
          illustration: MobileGameIllustration(),
          content: Column(
            children: [
              Text('Brew magical potions with friends in this exciting board game adaptation.'),
              SizedBox(height: 20),
              // Interactive demo button optimized for touch
              ElevatedButton(
                onPressed: _startInteractiveTutorial,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 56),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Try It Now!'),
              ),
            ],
          ),
        ),
        
        TouchTutorialScreen(
          title: 'Touch Controls',
          content: TouchControlsDemo(),
        ),
        
        GameBasicsScreen(
          title: 'Game Basics',
          content: InteractiveGameBasics(),
        ),
        
        ReadyToPlayScreen(
          title: 'Ready to Brew!',
          content: GetStartedOptions(),
        ),
      ],
    );
  }
}

class TouchControlsDemo extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Learn the touch gestures:', style: TextStyle(fontSize: 18)),
        SizedBox(height: 20),
        
        // Interactive gesture demonstrations
        GestureDemo(
          gesture: 'Tap',
          description: 'Draw ingredient chips',
          animation: TapGestureAnimation(),
        ),
        
        GestureDemo(
          gesture: 'Long Press',
          description: 'View detailed information',
          animation: LongPressGestureAnimation(),
        ),
        
        GestureDemo(
          gesture: 'Drag',
          description: 'Place chips in your pot',
          animation: DragGestureAnimation(),
        ),
        
        GestureDemo(
          gesture: 'Pinch',
          description: 'Zoom in/out on game board',
          animation: PinchGestureAnimation(),
        ),
        
        // Practice area
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text('Practice Area', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              PracticeGameBoard(),
            ],
          ),
        ),
      ],
    );
  }
}
```

#### Touch Tutorials and Gesture Guides

```dart
class InteractiveTouchTutorial extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return TutorialOverlay(
      steps: [
        TutorialStep(
          target: 'draw_button',
          title: 'Draw Ingredients',
          description: 'Tap here to draw ingredient chips from your bag',
          gestureType: GestureType.tap,
          onCompleted: _markStepCompleted,
        ),
        
        TutorialStep(
          target: 'game_board',
          title: 'View Your Pot',
          description: 'Long press any space to see detailed information',
          gestureType: GestureType.longPress,
          onCompleted: _markStepCompleted,
        ),
        
        TutorialStep(
          target: 'game_board',
          title: 'Navigate the Board',
          description: 'Pinch to zoom, drag to pan around your pot',
          gestureType: GestureType.pinchAndDrag,
          onCompleted: _markStepCompleted,
        ),
        
        TutorialStep(
          target: 'stop_button',
          title: 'Stop Brewing',
          description: 'Tap when you want to stop and score points',
          gestureType: GestureType.tap,
          onCompleted: _markStepCompleted,
        ),
      ],
      child: GameScreen(),
    );
  }
}

class TutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        
        if (_showTutorial)
          TutorialHighlightOverlay(
            currentStep: _currentStep,
            onStepCompleted: _nextStep,
          ),
      ],
    );
  }
}

class TutorialHighlightOverlay extends StatelessWidget {
  final TutorialStep step;
  
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Stack(
        children: [
          // Highlight the target element
          _buildHighlightHole(),
          
          // Gesture animation
          _buildGestureAnimation(),
          
          // Instruction popup
          _buildInstructionPopup(),
          
          // Skip tutorial button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _skipTutorial,
              child: Text('Skip Tutorial', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGestureAnimation() {
    switch (step.gestureType) {
      case GestureType.tap:
        return TapAnimationWidget(targetPosition: step.targetPosition);
      case GestureType.longPress:
        return LongPressAnimationWidget(targetPosition: step.targetPosition);
      case GestureType.drag:
        return DragAnimationWidget(
          startPosition: step.targetPosition,
          endPosition: step.dragEndPosition,
        );
      case GestureType.pinchAndDrag:
        return PinchDragAnimationWidget(centerPosition: step.targetPosition);
    }
  }
}

class TapAnimationWidget extends StatefulWidget {
  final Offset targetPosition;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: targetPosition.dx - 25,
          top: targetPosition.dy - 25,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

#### Error Recovery on Small Screens

```dart
class MobileErrorHandler extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Error illustration
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red,
                ),
              ),
              
              SizedBox(height: 16),
              
              // Error title
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 8),
              
              // Error description (simplified for mobile)
              Text(
                _getSimplifiedErrorMessage(error),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 24),
              
              // Action buttons
              Column(
                children: [
                  if (onRetry != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onRetry,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(0, 48),
                        ),
                        child: Text('Try Again'),
                      ),
                    ),
                  
                  if (onRetry != null) SizedBox(height: 12),
                  
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onDismiss ?? () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(0, 48),
                      ),
                      child: Text('Close'),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Additional help options
                  TextButton(
                    onPressed: _showDetailedError,
                    child: Text('View Details'),
                  ),
                  
                  TextButton(
                    onPressed: _contactSupport,
                    child: Text('Contact Support'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getSimplifiedErrorMessage(String error) {
    // Simplify technical errors for mobile users
    if (error.contains('network') || error.contains('connection')) {
      return 'Check your internet connection and try again.';
    } else if (error.contains('timeout')) {
      return 'The request took too long. Please try again.';
    } else if (error.contains('permission')) {
      return 'Permission denied. Please check your account settings.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}

// Contextual error recovery based on game state
class GameStateErrorRecovery extends StatelessWidget {
  final GameError error;
  
  Widget build(BuildContext context) {
    return Column(
      children: [
        MobileErrorHandler(
          error: error.message,
          onRetry: _getContextualRetryAction(),
        ),
        
        if (_canRecoverFromError())
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.auto_fix_high, color: Colors.blue),
                  SizedBox(height: 8),
                  Text(
                    'Auto Recovery Available',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'We can try to restore your game state automatically.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _attemptAutoRecovery,
                    child: Text('Auto Recover'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  
  VoidCallback? _getContextualRetryAction() {
    switch (error.context) {
      case ErrorContext.gameLoad:
        return _retryGameLoad;
      case ErrorContext.turnSubmission:
        return _retryTurnSubmission;
      case ErrorContext.roomJoin:
        return _retryRoomJoin;
      default:
        return null;
    }
  }
}
```

#### Offline Mobile Gameplay Considerations

```dart
class OfflineModeManager extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final isOnline = snapshot.data != ConnectivityResult.none;
        
        return Column(
          children: [
            if (!isOnline)
              OfflineBanner(),
            
            Expanded(
              child: isOnline 
                ? OnlineGameInterface()
                : OfflineGameInterface(),
            ),
          ],
        );
      },
    );
  }
}

class OfflineGameInterface extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Offline mode indicator
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.offline_pin, color: Colors.orange),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offline Mode',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Your moves will sync when connection is restored',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 16),
        
        // Available offline features
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                OfflineGameCard(
                  title: 'Practice Mode',
                  description: 'Play against AI to improve your skills',
                  icon: Icons.psychology,
                  onTap: _startPracticeMode,
                ),
                
                OfflineGameCard(
                  title: 'Game Rules',
                  description: 'Learn the rules and strategies',
                  icon: Icons.menu_book,
                  onTap: _showGameRules,
                ),
                
                OfflineGameCard(
                  title: 'Statistics',
                  description: 'View your cached game statistics',
                  icon: Icons.bar_chart,
                  onTap: _showCachedStats,
                ),
                
                OfflineGameCard(
                  title: 'Pending Games',
                  description: 'Resume games when back online',
                  icon: Icons.sync,
                  onTap: _showPendingGames,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Offline game state management
class OfflineGameState {
  static final List<PendingGameAction> _pendingActions = [];
  static final Map<String, dynamic> _cachedData = {};
  
  static void queueAction(PendingGameAction action) {
    _pendingActions.add(action);
    _savePendingActionsToStorage();
  }
  
  static Future<void> syncWhenOnline() async {
    if (_pendingActions.isEmpty) return;
    
    try {
      for (final action in _pendingActions) {
        await _syncAction(action);
      }
      
      _pendingActions.clear();
      _savePendingActionsToStorage();
      
      _showSyncSuccessMessage();
    } catch (e) {
      _showSyncErrorMessage();
    }
  }
  
  // Cache essential game data for offline access
  static void cacheGameData(String key, dynamic data) {
    _cachedData[key] = data;
    _saveCacheToStorage();
  }
  
  static T? getCachedData<T>(String key) {
    return _cachedData[key] as T?;
  }
}

class PracticeGameMode extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice Mode'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _showPracticeSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // Practice difficulty selection
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose Difficulty:', style: TextStyle(fontSize: 18)),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DifficultyButton(
                        level: DifficultyLevel.easy,
                        isSelected: _selectedDifficulty == DifficultyLevel.easy,
                        onSelected: _selectDifficulty,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DifficultyButton(
                        level: DifficultyLevel.medium,
                        isSelected: _selectedDifficulty == DifficultyLevel.medium,
                        onSelected: _selectDifficulty,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DifficultyButton(
                        level: DifficultyLevel.hard,
                        isSelected: _selectedDifficulty == DifficultyLevel.hard,
                        onSelected: _selectDifficulty,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Game interface (adapted for single player)
          Expanded(
            child: OfflinePracticeGameBoard(),
          ),
          
          // Practice-specific controls
          PracticeGameControls(),
        ],
      ),
    );
  }
}
```

This comprehensive mobile optimization specification addresses the key challenge of fitting complex game board information onto small screens while maintaining excellent usability. The solutions include adaptive layouts, enhanced touch interactions, progressive information disclosure, and performance optimizations specifically designed for mobile devices.

The specifications provide concrete Flutter implementation guidelines with detailed code examples that can be directly integrated into the Calderum codebase. Each solution is designed to maintain the magical theme while solving real usability challenges on mobile devices.

## Error States and Offline Handling

### 1. **Network Error States**

#### Connection Lost Scenarios

**Visual Design:**
- **Primary Color**: `#E74C3C` (Crimson Red) for critical connection issues
- **Secondary Color**: `#F39C12` (Orange) for warnings and degraded connectivity  
- **Background**: Semi-transparent overlay with blur effect
- **Typography**: Caudex for headers, system font for body text

**Connection Lost Banner:**
```dart
class ConnectionLostBanner extends StatelessWidget {
  final bool isReconnecting;
  final VoidCallback? onRetry;

  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isReconnecting ? 60 : 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE74C3C),
            Color(0xFFC0392B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              isReconnecting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Icon(
                    Icons.cloud_off,
                    color: Colors.white,
                    size: 24,
                    semanticLabel: 'Connection lost',
                  ),
              
              SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isReconnecting ? 'Reconnecting...' : 'Connection Lost',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Caudex',
                      ),
                    ),
                    if (!isReconnecting)
                      Text(
                        'Your magical connection has been disrupted',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              
              if (!isReconnecting && onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: Text('Retry'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### Firebase/Firestore Unavailable States

**Full-Screen Error State:**
```dart
class FirebaseUnavailableScreen extends StatelessWidget {
  final VoidCallback onRetry;
  final bool isRetrying;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C1810), // Deep mystical brown
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Magical cauldron with smoke animation
              AnimatedContainer(
                duration: Duration(seconds: 2),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Cauldron icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xFF8B4513).withOpacity(0.3),
                            Color(0xFF654321).withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.local_fire_department,
                        size: 60,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    
                    // Animated smoke particles
                    if (isRetrying)
                      Positioned(
                        top: -20,
                        child: SmokeParticleEffect(),
                      ),
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              Text(
                'The Mystical Realm is Unreachable',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Caudex',
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 16),
              
              Text(
                'Our magical servers seem to be experiencing some turbulence. '
                'The alchemists are working to restore the connection.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: isRetrying ? null : onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD4AF37),
                  foregroundColor: Color(0xFF2C1810),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isRetrying
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF2C1810),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Casting Reconnection Spell...'),
                      ],
                    )
                  : Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
              
              SizedBox(height: 16),
              
              TextButton(
                onPressed: () => _showOfflineMode(context),
                child: Text(
                  'Continue in Offline Mode',
                  style: TextStyle(
                    color: Color(0xFFD4AF37).withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### Slow Network Indicators and Timeout Handling

**Progressive Loading States:**
```dart
class NetworkProgressIndicator extends StatefulWidget {
  final Duration timeout;
  final VoidCallback onTimeout;
  final String operation;

  @override
  _NetworkProgressIndicatorState createState() => _NetworkProgressIndicatorState();
}

class _NetworkProgressIndicatorState extends State<NetworkProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  Timer? _timeoutTimer;
  bool _showSlowWarning = false;
  
  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: widget.timeout,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _progressController.forward();
    
    // Show slow network warning after 3 seconds
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSlowWarning = true;
        });
      }
    });
    
    // Trigger timeout callback
    _timeoutTimer = Timer(widget.timeout, widget.onTimeout);
  }
  
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated progress indicator
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse ring
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 60 + (_pulseController.value * 20),
                    height: 60 + (_pulseController.value * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFD4AF37).withOpacity(0.3 - (_pulseController.value * 0.3)),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
              
              // Progress circle
              SizedBox(
                width: 50,
                height: 50,
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return CircularProgressIndicator(
                      value: _progressController.value,
                      strokeWidth: 4,
                      color: _showSlowWarning ? Color(0xFFF39C12) : Color(0xFFD4AF37),
                      backgroundColor: Colors.white.withOpacity(0.2),
                    );
                  },
                ),
              ),
              
              // Center icon
              Icon(
                _showSlowWarning ? Icons.hourglass_empty : Icons.sync,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          Text(
            widget.operation,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Caudex',
            ),
            textAlign: TextAlign.center,
          ),
          
          if (_showSlowWarning) ...[
            SizedBox(height: 8),
            Text(
              'This is taking longer than usual...',
              style: TextStyle(
                color: Color(0xFFF39C12),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _timeoutTimer?.cancel();
    super.dispose();
  }
}
```

#### Retry Mechanisms with Exponential Backoff UI

**Smart Retry Component:**
```dart
class RetryMechanism extends StatefulWidget {
  final Future<void> Function() operation;
  final String operationName;
  final int maxRetries;
  final Duration initialDelay;

  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final retryState = ref.watch(retryProvider);
        
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Retry attempt indicator
              Row(
                children: List.generate(maxRetries, (index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < retryState.attempts
                        ? (retryState.isSuccess ? Colors.green : Color(0xFFE74C3C))
                        : index == retryState.attempts && retryState.isRetrying
                          ? Color(0xFFF39C12)
                          : Colors.grey.withOpacity(0.3),
                    ),
                    child: index == retryState.attempts && retryState.isRetrying
                      ? SizedBox(
                          width: 8,
                          height: 8,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.white,
                          ),
                        )
                      : null,
                  );
                }),
              ),
              
              SizedBox(height: 16),
              
              Text(
                retryState.isRetrying
                  ? 'Attempting ${operationName}...'
                  : retryState.hasError
                    ? 'Failed to ${operationName}'
                    : '${operationName} Ready',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: retryState.hasError ? Color(0xFFE74C3C) : Color(0xFF2C1810),
                ),
                textAlign: TextAlign.center,
              ),
              
              if (retryState.hasError) ...[
                SizedBox(height: 8),
                Text(
                  'Attempt ${retryState.attempts} of $maxRetries',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                
                if (retryState.nextRetryIn > 0) ...[
                  SizedBox(height: 8),
                  Text(
                    'Next attempt in ${retryState.nextRetryIn}s',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFF39C12),
                    ),
                  ),
                ],
              ],
              
              SizedBox(height: 16),
              
              Row(
                children: [
                  if (!retryState.isRetrying && retryState.attempts < maxRetries)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => ref.read(retryProvider.notifier).retryNow(),
                        child: Text('Retry Now'),
                      ),
                    ),
                  
                  if (!retryState.isRetrying && retryState.attempts >= maxRetries) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => ref.read(retryProvider.notifier).reset(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD4AF37),
                        ),
                        child: Text('Start Over'),
                      ),
                    ),
                  ],
                  
                  if (retryState.isRetrying)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => ref.read(retryProvider.notifier).cancel(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFE74C3C),
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### 2. **Authentication Errors**

#### Login/Signup Failure States

**Visual Design:**
- **Error Color**: `#E74C3C` for validation errors
- **Warning Color**: `#F39C12` for temporary issues
- **Success Color**: `#27AE60` for successful recovery
- **Background**: White with subtle red tint for error states

**Login Error Component:**
```dart
class AuthErrorHandler extends StatelessWidget {
  final AuthError error;
  final VoidCallback onRetry;
  final VoidCallback? onForgotPassword;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getErrorBackgroundColor(error.type),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getErrorBorderColor(error.type),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getErrorIcon(error.type),
                color: _getErrorIconColor(error.type),
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  _getErrorTitle(error.type),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C1810),
                    fontFamily: 'Caudex',
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          Text(
            _getErrorMessage(error.type),
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2C1810).withOpacity(0.8),
              height: 1.4,
            ),
          ),
          
          if (_getErrorSuggestion(error.type).isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              _getErrorSuggestion(error.type),
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF2C1810).withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          
          SizedBox(height: 16),
          
          Row(
            children: [
              if (_showRetryButton(error.type))
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD4AF37),
                      foregroundColor: Color(0xFF2C1810),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Try Again'),
                  ),
                ),
              
              if (_showForgotPasswordButton(error.type) && onForgotPassword != null) ...[
                if (_showRetryButton(error.type)) SizedBox(width: 12),
                Expanded(
                  flex: _showRetryButton(error.type) ? 2 : 1,
                  child: OutlinedButton(
                    onPressed: onForgotPassword,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF8B4513),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Forgot Password?'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
  
  Color _getErrorBackgroundColor(AuthErrorType type) {
    switch (type) {
      case AuthErrorType.invalidCredentials:
      case AuthErrorType.userNotFound:
        return Color(0xFFE74C3C).withOpacity(0.1);
      case AuthErrorType.networkError:
      case AuthErrorType.timeout:
        return Color(0xFFF39C12).withOpacity(0.1);
      case AuthErrorType.accountDisabled:
        return Color(0xFF95A5A6).withOpacity(0.1);
      default:
        return Color(0xFFF8F9FA);
    }
  }
  
  String _getErrorTitle(AuthErrorType type) {
    switch (type) {
      case AuthErrorType.invalidCredentials:
        return 'Invalid Spell Components';
      case AuthErrorType.userNotFound:
        return 'Unknown Alchemist';
      case AuthErrorType.networkError:
        return 'Mystical Connection Disrupted';
      case AuthErrorType.timeout:
        return 'Spell Casting Timeout';
      case AuthErrorType.accountDisabled:
        return 'Account Temporarily Sealed';
      case AuthErrorType.emailAlreadyExists:
        return 'Alchemist Registry Conflict';
      default:
        return 'Magical Mishap';
    }
  }
  
  String _getErrorMessage(AuthErrorType type) {
    switch (type) {
      case AuthErrorType.invalidCredentials:
        return 'The email and password combination you provided doesn\'t match our records. Please double-check your credentials and try again.';
      case AuthErrorType.userNotFound:
        return 'We couldn\'t find an account with that email address. Would you like to create a new alchemist profile instead?';
      case AuthErrorType.networkError:
        return 'We\'re having trouble connecting to our servers. Please check your internet connection and try again.';
      case AuthErrorType.timeout:
        return 'The login process took too long to complete. This usually happens with slow connections.';
      case AuthErrorType.accountDisabled:
        return 'Your account has been temporarily disabled. Please contact support if you believe this is an error.';
      case AuthErrorType.emailAlreadyExists:
        return 'An account with this email already exists. Try logging in instead, or use a different email address.';
      default:
        return 'Something unexpected happened during authentication. Please try again.';
    }
  }
}
```

#### Google Sign-In Specific Errors

**Google Auth Error States:**
```dart
class GoogleSignInErrorHandler extends StatelessWidget {
  final GoogleSignInError error;
  final VoidCallback onRetry;

  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Google logo with error indicator
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Image.asset(
                    'assets/images/google_logo.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE74C3C),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            Text(
              _getGoogleErrorTitle(error.type),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C1810),
                fontFamily: 'Caudex',
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 12),
            
            Text(
              _getGoogleErrorMessage(error.type),
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2C1810).withOpacity(0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Cancel'),
                  ),
                ),
                
                SizedBox(width: 12),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRetry();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4285F4), // Google Blue
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Try Again'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _getGoogleErrorTitle(GoogleSignInErrorType type) {
    switch (type) {
      case GoogleSignInErrorType.cancelled:
        return 'Sign-in Cancelled';
      case GoogleSignInErrorType.networkError:
        return 'Connection Problem';
      case GoogleSignInErrorType.accountRestricted:
        return 'Account Restricted';
      case GoogleSignInErrorType.serviceDisabled:
        return 'Service Temporarily Unavailable';
      default:
        return 'Google Sign-in Error';
    }
  }
}
```

#### Session Expiration Handling

**Session Expiry Modal:**
```dart
class SessionExpiryHandler extends StatefulWidget {
  final Duration timeUntilExpiry;
  final VoidCallback onExtendSession;
  final VoidCallback onLogout;

  @override
  _SessionExpiryHandlerState createState() => _SessionExpiryHandlerState();
}

class _SessionExpiryHandlerState extends State<SessionExpiryHandler>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _pulseController;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.timeUntilExpiry.inSeconds;
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
        if (_secondsRemaining <= 0) {
          timer.cancel();
          widget.onLogout();
        }
      });
    });
  }

  Widget build(BuildContext context) {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    final isUrgent = _secondsRemaining <= 30;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated hourglass icon
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: isUrgent ? (1.0 + _pulseController.value * 0.1) : 1.0,
                  child: Icon(
                    Icons.hourglass_bottom,
                    size: 60,
                    color: isUrgent ? Color(0xFFE74C3C) : Color(0xFFF39C12),
                  ),
                );
              },
            ),
            
            SizedBox(height: 20),
            
            Text(
              'Session Expiring Soon',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C1810),
                fontFamily: 'Caudex',
              ),
            ),
            
            SizedBox(height: 12),
            
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C1810).withOpacity(0.8),
                ),
                children: [
                  TextSpan(text: 'Your magical session will expire in '),
                  TextSpan(
                    text: '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isUrgent ? Color(0xFFE74C3C) : Color(0xFFF39C12),
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(text: '. Would you like to extend it?'),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onLogout,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Logout'),
                  ),
                ),
                
                SizedBox(width: 12),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onExtendSession();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD4AF37),
                      foregroundColor: Color(0xFF2C1810),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Extend Session'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3. **Game-Specific Errors**

#### Room Creation/Joining Failures

**Room Error Toast:**
```dart
class RoomErrorToast extends StatelessWidget {
  final RoomError error;
  final VoidCallback? onRetry;

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2C1810),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getErrorAccentColor(error.type),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getErrorAccentColor(error.type).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            _getRoomErrorIcon(error.type),
            color: _getErrorAccentColor(error.type),
            size: 24,
          ),
          
          SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getRoomErrorTitle(error.type),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Caudex',
                  ),
                ),
                
                if (_getRoomErrorMessage(error.type).isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    _getRoomErrorMessage(error.type),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: _getErrorAccentColor(error.type),
              ),
              child: Text('Retry'),
            ),
        ],
      ),
    );
  }
  
  Color _getErrorAccentColor(RoomErrorType type) {
    switch (type) {
      case RoomErrorType.roomFull:
        return Color(0xFFF39C12);
      case RoomErrorType.roomNotFound:
        return Color(0xFFE74C3C);
      case RoomErrorType.invalidCode:
        return Color(0xFFE74C3C);
      case RoomErrorType.gameInProgress:
        return Color(0xFF8E44AD);
      case RoomErrorType.networkError:
        return Color(0xFFF39C12);
      default:
        return Color(0xFFD4AF37);
    }
  }
  
  String _getRoomErrorTitle(RoomErrorType type) {
    switch (type) {
      case RoomErrorType.roomFull:
        return 'Cauldron at Capacity';
      case RoomErrorType.roomNotFound:
        return 'Mystical Chamber Not Found';
      case RoomErrorType.invalidCode:
        return 'Invalid Spell Code';
      case RoomErrorType.gameInProgress:
        return 'Ritual in Progress';
      case RoomErrorType.networkError:
        return 'Connection Disrupted';
      default:
        return 'Unknown Chamber Error';
    }
  }
}
```

#### Player Disconnection Handling

**Player Disconnect Status:**
```dart
class PlayerDisconnectHandler extends StatefulWidget {
  final List<DisconnectedPlayer> disconnectedPlayers;
  final Duration reconnectionTimeout;

  @override
  Widget build(BuildContext context) {
    if (disconnectedPlayers.isEmpty) return SizedBox.shrink();
    
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF39C12).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFF39C12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wifi_off,
                color: Color(0xFFF39C12),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Alchemists Disconnected',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C1810),
                  fontFamily: 'Caudex',
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          ...disconnectedPlayers.map((player) => Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  backgroundImage: player.avatarUrl != null
                    ? NetworkImage(player.avatarUrl!)
                    : null,
                  child: player.avatarUrl == null
                    ? Icon(Icons.person, size: 16)
                    : null,
                ),
                
                SizedBox(width: 12),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2C1810),
                        ),
                      ),
                      Text(
                        'Reconnecting... ${_getTimeRemaining(player.disconnectedAt, reconnectionTimeout)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Connection status indicator
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFF39C12),
                  ),
                ),
              ],
            ),
          )).toList(),
          
          SizedBox(height: 8),
          
          Text(
            'The game will continue automatically when they reconnect.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
```

#### Game State Sync Errors

**Sync Error Recovery:**
```dart
class GameStateSyncError extends StatefulWidget {
  final SyncError error;
  final VoidCallback onResyncGame;
  final VoidCallback onReconnect;

  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sync error animation
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.sync_problem,
                  size: 60,
                  color: Color(0xFFE74C3C),
                ),
                
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF39C12),
                    ),
                    child: Icon(
                      Icons.warning,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            Text(
              'Game State Mismatch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C1810),
                fontFamily: 'Caudex',
              ),
            ),
            
            SizedBox(height: 12),
            
            Text(
              'Your game state appears to be out of sync with other players. '
              'This can happen due to connection issues.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2C1810).withOpacity(0.8),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 20),
            
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFD4AF37).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xFFD4AF37).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFF8B4513),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your progress is safely stored and will not be lost.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onResyncGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD4AF37),
                      foregroundColor: Color(0xFF2C1810),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Refresh Game State',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                
                SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onReconnect,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF8B4513),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Reconnect to Game'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### 4. **Offline Mode Design**

#### Offline Capability Banner

**Persistent Offline Indicator:**
```dart
class OfflineModeBanner extends StatelessWidget {
  final bool hasQueuedActions;
  final int queuedActionsCount;
  final VoidCallback onViewQueue;

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF8E44AD),
            Color(0xFF9B59B6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8E44AD).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(
              Icons.cloud_off,
              color: Colors.white,
              size: 20,
            ),
            
            SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offline Mode Active',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Caudex',
                    ),
                  ),
                  
                  Text(
                    hasQueuedActions
                      ? '$queuedActionsCount actions queued for sync'
                      : 'Your progress will sync when reconnected',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            
            if (hasQueuedActions)
              TextButton(
                onPressed: onViewQueue,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View Queue',
                  style: TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

#### Offline Game Interface

**Offline-Specific Features:**
```dart
class OfflineGameInterface extends StatelessWidget {
  final OfflineGameState gameState;

  Widget build(BuildContext context) {
    return Column(
      children: [
        // Offline capabilities header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2C1810),
                Color(0xFF3D2317),
              ],
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.local_library,
                size: 60,
                color: Color(0xFFD4AF37),
              ),
              
              SizedBox(height: 16),
              
              Text(
                'Offline Alchemist\'s Laboratory',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                  fontFamily: 'Caudex',
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 8),
              
              Text(
                'Practice your brewing skills while disconnected',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildOfflineFeatureCard(
                  title: 'Practice Mode',
                  description: 'Play against AI opponents',
                  icon: Icons.psychology,
                  color: Color(0xFF27AE60),
                  onTap: () => _startPracticeMode(context),
                  available: true,
                ),
                
                _buildOfflineFeatureCard(
                  title: 'Tutorial',
                  description: 'Learn game mechanics',
                  icon: Icons.school,
                  color: Color(0xFF3498DB),
                  onTap: () => _startTutorial(context),
                  available: true,
                ),
                
                _buildOfflineFeatureCard(
                  title: 'Ingredient Guide',
                  description: 'Browse all ingredients',
                  icon: Icons.menu_book,
                  color: Color(0xFF9B59B6),
                  onTap: () => _showIngredientGuide(context),
                  available: true,
                ),
                
                _buildOfflineFeatureCard(
                  title: 'Statistics',
                  description: 'View cached stats',
                  icon: Icons.bar_chart,
                  color: Color(0xFFF39C12),
                  onTap: () => _showCachedStats(context),
                  available: gameState.hasCachedStats,
                ),
                
                _buildOfflineFeatureCard(
                  title: 'Resume Game',
                  description: 'Continue paused games',
                  icon: Icons.play_circle,
                  color: Color(0xFFE67E22),
                  onTap: () => _resumeGame(context),
                  available: gameState.hasPausedGames,
                ),
                
                _buildOfflineFeatureCard(
                  title: 'Achievements',
                  description: 'View unlocked rewards',
                  icon: Icons.emoji_events,
                  color: Color(0xFFD4AF37),
                  onTap: () => _showAchievements(context),
                  available: gameState.hasAchievements,
                ),
              ],
            ),
          ),
        ),
        
        // Sync status footer
        _buildSyncStatusFooter(context),
      ],
    );
  }
  
  Widget _buildOfflineFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool available,
  }) {
    return Card(
      elevation: available ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: available ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: available
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.1),
                    color.withOpacity(0.05),
                  ],
                )
              : null,
            border: available
              ? Border.all(color: color.withOpacity(0.3))
              : Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: available ? color : Colors.grey,
              ),
              
              SizedBox(height: 12),
              
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: available ? Color(0xFF2C1810) : Colors.grey[600],
                  fontFamily: 'Caudex',
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 4),
              
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: available ? Colors.grey[600] : Colors.grey[400],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              if (!available) ...[
                SizedBox(height: 8),
                Text(
                  'Requires internet',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSyncStatusFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.sync_disabled,
                color: Colors.grey[600],
                size: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Offline - Changes will sync automatically when connected',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          
          if (gameState.hasQueuedActions) ...[
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: null,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(Color(0xFFD4AF37)),
            ),
            SizedBox(height: 4),
            Text(
              '${gameState.queuedActionsCount} actions ready to sync',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

### 5. **Error Recovery Patterns**

#### Automatic Retry with User Feedback

**Smart Recovery System:**
```dart
class AutoRetryHandler extends StatefulWidget {
  final Future<T> Function<T>() operation;
  final String operationName;
  final List<Duration> retryDelays;
  final Widget Function(AutoRetryState state) builder;

  @override
  _AutoRetryHandlerState createState() => _AutoRetryHandlerState();
}

class _AutoRetryHandlerState extends State<AutoRetryHandler> {
  AutoRetryState _state = AutoRetryState.idle;
  int _currentAttempt = 0;
  String? _errorMessage;
  Timer? _retryTimer;

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      AutoRetryState(
        isRetrying: _state == AutoRetryState.retrying,
        hasError: _state == AutoRetryState.error,
        isSuccess: _state == AutoRetryState.success,
        attempt: _currentAttempt,
        maxAttempts: widget.retryDelays.length,
        errorMessage: _errorMessage,
        nextRetryIn: _retryTimer?.isActive == true ? _getTimeUntilRetry() : null,
        onManualRetry: _manualRetry,
        onCancel: _cancelRetry,
      ),
    );
  }

  Widget _buildRetryAnimation() {
    return Container(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotating ring
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * pi,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFD4AF37),
                      width: 3,
                    ),
                    gradient: SweepGradient(
                      colors: [
                        Color(0xFFD4AF37).withOpacity(0.1),
                        Color(0xFFD4AF37),
                        Color(0xFFD4AF37).withOpacity(0.1),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Inner pulse
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.5 + (_pulseController.value * 0.3),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD4AF37).withOpacity(0.8 - (_pulseController.value * 0.3)),
                  ),
                ),
              );
            },
          ),
          
          // Center icon
          Icon(
            Icons.refresh,
            color: Color(0xFF2C1810),
            size: 24,
          ),
        ],
      ),
    );
  }
}
```

#### Manual Retry Options

**Retry Control Panel:**
```dart
class RetryControlPanel extends StatelessWidget {
  final RetryState state;
  final VoidCallback onRetryNow;
  final VoidCallback onRetryLater;
  final VoidCallback onCancel;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Error summary
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFE74C3C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.error_outline,
                  color: Color(0xFFE74C3C),
                  size: 20,
                ),
              ),
              
              SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.operationName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1810),
                      ),
                    ),
                    
                    Text(
                      'Failed after ${state.attempts} attempts',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (state.errorMessage != null) ...[
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                state.errorMessage!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
          
          SizedBox(height: 24),
          
          // Retry options
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.isRetrying ? null : onRetryNow,
                  icon: state.isRetrying
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(Icons.refresh),
                  label: Text(state.isRetrying ? 'Retrying...' : 'Try Again Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD4AF37),
                    foregroundColor: Color(0xFF2C1810),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRetryLater,
                      icon: Icon(Icons.schedule),
                      label: Text('Retry Later'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF8B4513),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 12),
                  
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onCancel,
                      icon: Icon(Icons.close),
                      label: Text('Cancel'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 8),
          
          // Helpful suggestions
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFD4AF37).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF8B4513),
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getRetryTip(state.errorType),
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getRetryTip(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.network:
        return 'Check your internet connection and try again';
      case ErrorType.timeout:
        return 'This might work better with a faster connection';
      case ErrorType.serverError:
        return 'Our servers might be busy - trying again often helps';
      case ErrorType.authError:
        return 'You might need to log in again';
      default:
        return 'Sometimes these issues resolve themselves quickly';
    }
  }
}
```

### 6. **Feedback and Communication**

#### Toast Notifications for Transient Errors

**Smart Error Toast System:**
```dart
class ErrorToastManager {
  static final GlobalKey<ScaffoldMessengerState> _scaffoldKey = 
      GlobalKey<ScaffoldMessengerState>();
  
  static void showErrorToast({
    required BuildContext context,
    required String title,
    required String message,
    ErrorSeverity severity = ErrorSeverity.medium,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final color = _getSeverityColor(severity);
    final icon = _getSeverityIcon(severity);
    
    final toast = SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.all(16),
      content: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            
            SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Caudex',
                    ),
                  ),
                  
                  if (message.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            if (onAction != null && actionLabel != null) ...[
              SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onAction();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
      action: severity == ErrorSeverity.high
        ? SnackBarAction(
            label: 'DISMISS',
            textColor: Colors.white.withOpacity(0.8),
            onPressed: () {},
          )
        : null,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(toast);
    
    // Auto-hide for low severity errors
    if (severity == ErrorSeverity.low) {
      Timer(Duration(seconds: 2), () {
        try {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        } catch (e) {
          // Context might be disposed
        }
      });
    }
  }
  
  static Color _getSeverityColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return Color(0xFF95A5A6);
      case ErrorSeverity.medium:
        return Color(0xFFF39C12);
      case ErrorSeverity.high:
        return Color(0xFFE74C3C);
    }
  }
  
  static IconData _getSeverityIcon(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return Icons.info_outline;
      case ErrorSeverity.medium:
        return Icons.warning_amber;
      case ErrorSeverity.high:
        return Icons.error_outline;
    }
  }
}
```

#### Progress Indicators During Recovery

**Recovery Progress Widget:**
```dart
class RecoveryProgressIndicator extends StatefulWidget {
  final RecoveryOperation operation;
  final Duration estimatedDuration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recovery animation
          Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD4AF37).withOpacity(0.1),
                  border: Border.all(
                    color: Color(0xFFD4AF37).withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
              
              // Animated progress
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: operation.progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(Color(0xFFD4AF37)),
                ),
              ),
              
              // Center content
              Column(
                children: [
                  Icon(
                    _getOperationIcon(operation.type),
                    color: Color(0xFF2C1810),
                    size: 32,
                  ),
                  
                  SizedBox(height: 4),
                  
                  Text(
                    '${(operation.progress * 100).round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C1810),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          Text(
            _getOperationTitle(operation.type),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
              fontFamily: 'Caudex',
            ),
          ),
          
          SizedBox(height: 8),
          
          Text(
            operation.currentStep,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2C1810).withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 16),
          
          // Progress steps
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(operation.totalSteps, (index) {
              final isCompleted = index < operation.currentStepIndex;
              final isCurrent = index == operation.currentStepIndex;
              
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                    ? Color(0xFFD4AF37)
                    : isCurrent
                      ? Color(0xFFF39C12)
                      : Colors.grey.withOpacity(0.3),
                ),
              );
            }),
          ),
          
          SizedBox(height: 20),
          
          // Estimated time remaining
          if (operation.estimatedTimeRemaining != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFD4AF37).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'About ${_formatDuration(operation.estimatedTimeRemaining!)} remaining',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8B4513),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  IconData _getOperationIcon(RecoveryOperationType type) {
    switch (type) {
      case RecoveryOperationType.reconnecting:
        return Icons.wifi;
      case RecoveryOperationType.syncing:
        return Icons.sync;
      case RecoveryOperationType.restoring:
        return Icons.restore;
      case RecoveryOperationType.refreshing:
        return Icons.refresh;
    }
  }
  
  String _getOperationTitle(RecoveryOperationType type) {
    switch (type) {
      case RecoveryOperationType.reconnecting:
        return 'Reconnecting to Realm';
      case RecoveryOperationType.syncing:
        return 'Synchronizing Progress';
      case RecoveryOperationType.restoring:
        return 'Restoring Game State';
      case RecoveryOperationType.refreshing:
        return 'Refreshing Connection';
    }
  }
}
```

## Accessibility Considerations for Error States

### Screen Reader Support

All error components include:
- **Semantic labels** for error types and severity
- **Live region announcements** for dynamic error updates  
- **Detailed descriptions** of error causes and solutions
- **Alternative text** for visual error indicators

### Keyboard Navigation

Error dialogs and recovery interfaces support:
- **Tab navigation** through all interactive elements
- **Escape key** to dismiss non-critical errors
- **Enter key** to activate primary recovery actions
- **Arrow keys** for navigating error queues

### High Contrast Support

Error states adapt to system accessibility settings:
- **Enhanced borders** and contrast ratios in high contrast mode
- **Pattern-based indicators** in addition to color coding
- **Larger touch targets** for motor accessibility
- **Simplified layouts** for cognitive accessibility

### Voice Control Integration

Error recovery supports voice commands:
- "Retry" for manual retry attempts
- "Cancel" for dismissing error states  
- "Help" for additional error information
- "Offline mode" for switching to offline functionality

This comprehensive error handling and offline design system ensures that Calderum provides excellent user experience even when things go wrong, maintaining the magical theme while offering clear, helpful guidance for error recovery.

## Design System Expansion

### 1. Light Theme Variant

#### Complete Light Theme Color Palette

```dart
class CalderumLightTheme {
  // Primary Colors - Light Theme
  static const Color primaryPurple = Color(0xFF8B5FBF);     // Lighter mystical purple
  static const Color primaryGold = Color(0xFFF4C542);       // Brighter gold
  static const Color lightBackground = Color(0xFFF5F3F0);   // Warm off-white
  static const Color lightSurface = Color(0xFFFFFFFF);      // Pure white cards
  static const Color lightSurfaceVariant = Color(0xFFF8F6F4); // Subtle warm tint
  
  // Secondary Colors - Light Adaptations
  static const Color successGreen = Color(0xFF2E7D32);      // Darker for contrast
  static const Color dangerRed = Color(0xFFD32F2F);         // Adjusted red
  static const Color infoBlue = Color(0xFF1976D2);          // Deeper blue
  static const Color warningAmber = Color(0xFFF57C00);      // Rich orange
  
  // Text Colors
  static const Color onBackground = Color(0xFF2D2D2D);      // Dark grey text
  static const Color onSurface = Color(0xFF1C1C1C);        // Near black
  static const Color onSurfaceVariant = Color(0xFF5F5F5F);  // Medium grey
  static const Color outline = Color(0xFFD0D0D0);          // Light borders
  
  // Magical Ingredient Colors - Light Adapted
  static const Map<String, Color> ingredients = {
    'white': Color(0xFFF8F8FF),     // Ghost white with hint of purple
    'orange': Color(0xFFFF8C42),    // Vibrant orange
    'yellow': Color(0xFFFFC107),    // Rich yellow
    'green': Color(0xFF4CAF50),     // Forest green
    'blue': Color(0xFF2196F3),      // Azure blue
    'red': Color(0xFFF44336),       // Cardinal red
    'purple': Color(0xFF9C27B0),    // Royal purple
    'black': Color(0xFF424242),     // Charcoal (not pure black)
  };
  
  // Gradient Overlays - Light Theme
  static const LinearGradient purpleToGold = LinearGradient(
    colors: [Color(0xFF8B5FBF), Color(0xFFF4C542)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient lightToMediumPurple = LinearGradient(
    colors: [Color(0xFFE1BEE7), Color(0xFF8B5FBF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient blueToLightPurple = LinearGradient(
    colors: [Color(0xFF81C784), Color(0xFFCE93D8)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
```

#### Accessibility-Compliant Contrast Ratios

```dart
class CalderumContrastRatios {
  // All combinations meet WCAG 2.1 AA standards (4.5:1 minimum)
  static const Map<String, double> lightThemeContrast = {
    'primaryOnLight': 5.2,        // Purple on light background
    'goldOnLight': 6.1,           // Gold on light background  
    'textOnLight': 8.9,           // Dark text on light background
    'textOnCards': 12.1,          // Text on white cards
    'secondaryOnLight': 4.8,      // Secondary colors on light
  };
  
  static const Map<String, double> darkThemeContrast = {
    'primaryOnDark': 4.7,         // Current dark theme ratios
    'goldOnDark': 5.8,
    'textOnDark': 7.2,
    'textOnCards': 6.4,
    'secondaryOnDark': 4.9,
  };
}
```

#### Component Adaptations for Light Theme

```dart
// Light Theme Button Variations
class LightThemeComponents {
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: CalderumLightTheme.primaryPurple,
    foregroundColor: Colors.white,
    elevation: 2,
    shadowColor: CalderumLightTheme.primaryPurple.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
  
  static ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    foregroundColor: CalderumLightTheme.primaryPurple,
    side: BorderSide(color: CalderumLightTheme.primaryPurple, width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
  
  // Light Theme Card Styling
  static BoxDecoration cardDecoration = BoxDecoration(
    color: CalderumLightTheme.lightSurface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: CalderumLightTheme.outline, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );
  
  // Light Theme Input Fields
  static InputDecoration inputDecoration = InputDecoration(
    fillColor: CalderumLightTheme.lightSurfaceVariant,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: CalderumLightTheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: CalderumLightTheme.primaryPurple, width: 2),
    ),
  );
}
```

### 2. Design Token System

#### Comprehensive Spacing Tokens (4px Grid System)

```dart
class CalderumSpacing {
  // Base unit: 4px
  static const double unit = 4.0;
  
  // Spacing Scale
  static const double xs = unit;           // 4px
  static const double sm = unit * 2;       // 8px
  static const double md = unit * 3;       // 12px
  static const double lg = unit * 4;       // 16px
  static const double xl = unit * 5;       // 20px
  static const double xxl = unit * 6;      // 24px
  static const double xxxl = unit * 8;     // 32px
  static const double huge = unit * 10;    // 40px
  static const double massive = unit * 12; // 48px
  
  // Component-Specific Spacing
  static const double cardPadding = lg;
  static const double buttonPadding = md;
  static const double modalPadding = xl;
  static const double screenPadding = lg;
  static const double listItemPadding = md;
  
  // Layout Spacing
  static const double sectionGap = xxl;
  static const double componentGap = lg;
  static const double elementGap = sm;
  static const double tightGap = xs;
}
```

#### Typography Tokens with rem/dp Conversions

```dart
class CalderumTypography {
  // Font Sizes (with dp and rem equivalents)
  static const Map<String, double> fontSize = {
    'xs': 10.0,    // 0.625rem, ~7dp
    'sm': 12.0,    // 0.75rem,  ~8dp  
    'md': 14.0,    // 0.875rem, ~10dp
    'lg': 16.0,    // 1rem,     ~11dp
    'xl': 18.0,    // 1.125rem, ~13dp
    'xxl': 20.0,   // 1.25rem,  ~14dp
    'xxxl': 24.0,  // 1.5rem,   ~17dp
    'huge': 32.0,  // 2rem,     ~23dp
    'massive': 48.0, // 3rem,   ~34dp
  };
  
  // Line Heights (relative to font size)
  static const Map<String, double> lineHeight = {
    'tight': 1.1,
    'normal': 1.4,
    'relaxed': 1.6,
    'loose': 1.8,
  };
  
  // Font Weights
  static const Map<String, FontWeight> fontWeight = {
    'light': FontWeight.w300,
    'regular': FontWeight.w400,
    'medium': FontWeight.w500,
    'semibold': FontWeight.w600,
    'bold': FontWeight.w700,
  };
  
  // Typography Styles
  static TextStyle get h1 => GoogleFonts.caudex(
    fontSize: fontSize['massive']!,
    fontWeight: fontWeight['bold']!,
    height: lineHeight['tight']!,
  );
  
  static TextStyle get h2 => GoogleFonts.caudex(
    fontSize: fontSize['huge']!,
    fontWeight: fontWeight['bold']!,
    height: lineHeight['normal']!,
  );
  
  static TextStyle get h3 => GoogleFonts.caudex(
    fontSize: fontSize['xxxl']!,
    fontWeight: fontWeight['semibold']!,
    height: lineHeight['normal']!,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.caudex(
    fontSize: fontSize['lg']!,
    fontWeight: fontWeight['regular']!,
    height: lineHeight['relaxed']!,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.caudex(
    fontSize: fontSize['md']!,
    fontWeight: fontWeight['regular']!,
    height: lineHeight['relaxed']!,
  );
  
  static TextStyle get labelLarge => GoogleFonts.caudex(
    fontSize: fontSize['md']!,
    fontWeight: fontWeight['medium']!,
    height: lineHeight['normal']!,
  );
  
  static TextStyle get magical => GoogleFonts.caveat(
    fontSize: fontSize['xxl']!,
    fontWeight: fontWeight['medium']!,
    height: lineHeight['normal']!,
  );
}
```

#### Color Tokens with Semantic Naming

```dart
class CalderumColorTokens {
  // Semantic Color Roles
  static const Map<String, Color> semantic = {
    // Primary Actions
    'primary': Color(0xFF6B4E96),
    'primaryVariant': Color(0xFF8B5FBF),
    'onPrimary': Color(0xFFFFFFFF),
    
    // Secondary Actions  
    'secondary': Color(0xFFD4AF37),
    'secondaryVariant': Color(0xFFF4C542),
    'onSecondary': Color(0xFF2D2D2D),
    
    // Status Colors
    'success': Color(0xFF4CAF50),
    'warning': Color(0xFFFF9800),
    'error': Color(0xFFF44336),
    'info': Color(0xFF2196F3),
    
    // Surface Colors
    'surface': Color(0xFF16213E),
    'surfaceVariant': Color(0xFF1A1A2E),
    'onSurface': Color(0xFFE1E1E1),
    'onSurfaceVariant': Color(0xFFB0B0B0),
    
    // Ingredient-Specific
    'ingredientWhite': Color(0xFFF5F5F5),
    'ingredientOrange': Color(0xFFFF8C42),
    'ingredientYellow': Color(0xFFFFC107),
    'ingredientGreen': Color(0xFF4CAF50),
    'ingredientBlue': Color(0xFF2196F3),
    'ingredientRed': Color(0xFFE53935),
    'ingredientPurple': Color(0xFF9C27B0),
    'ingredientBlack': Color(0xFF424242),
  };
  
  // Opacity Tokens
  static const Map<String, double> opacity = {
    'disabled': 0.38,
    'medium': 0.60,
    'high': 0.87,
    'overlay': 0.16,
    'divider': 0.12,
    'focus': 0.12,
    'hover': 0.04,
    'selected': 0.08,
  };
}
```

#### Elevation and Shadow Token System

```dart
class CalderumElevation {
  // Material Design 3 Shadow System
  static const List<BoxShadow> level0 = []; // No shadow
  
  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  
  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  
  static const List<BoxShadow> level3 = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];
  
  static const List<BoxShadow> level4 = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> level5 = [
    BoxShadow(
      color: Color(0x7F000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];
  
  // Magical Glow Effects
  static List<BoxShadow> magicalGlow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.3),
      blurRadius: 12,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: color.withOpacity(0.1),
      blurRadius: 20,
      spreadRadius: 4,
    ),
  ];
}
```

#### Animation Timing and Easing Tokens

```dart
class CalderumAnimations {
  // Duration Tokens
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 750);
  static const Duration slowest = Duration(milliseconds: 1000);
  
  // Easing Curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;
  
  // Custom Magical Curves
  static const Curve magical = Cubic(0.68, -0.55, 0.265, 1.55);
  static const Curve bubbling = Cubic(0.175, 0.885, 0.32, 1.275);
  static const Curve pouring = Cubic(0.23, 1, 0.32, 1);
  
  // Component-Specific Durations
  static const Duration buttonPress = fast;
  static const Duration modalEntry = normal;
  static const Duration pageTransition = normal;
  static const Duration ingredientDrop = slow;
  static const Duration cauldronBubble = slower;
  static const Duration explosion = fast;
  
  // Magical Effect Timings
  static const Duration sparkle = Duration(milliseconds: 800);
  static const Duration shimmer = Duration(milliseconds: 1200);
  static const Duration glow = Duration(milliseconds: 2000);
}
```

### 3. Theming Architecture

#### Flutter ThemeData Extensions and Custom Themes

```dart
// Custom Theme Extension
@immutable
class CalderumThemeExtension extends ThemeExtension<CalderumThemeExtension> {
  const CalderumThemeExtension({
    required this.magicPurple,
    required this.mysticalGold,
    required this.cauldronSurface,
    required this.ingredientColors,
    required this.magicalGradients,
    required this.shadowLevel,
  });

  final Color magicPurple;
  final Color mysticalGold;
  final Color cauldronSurface;
  final Map<String, Color> ingredientColors;
  final Map<String, Gradient> magicalGradients;
  final List<BoxShadow> shadowLevel;

  @override
  CalderumThemeExtension copyWith({
    Color? magicPurple,
    Color? mysticalGold,
    Color? cauldronSurface,
    Map<String, Color>? ingredientColors,
    Map<String, Gradient>? magicalGradients,
    List<BoxShadow>? shadowLevel,
  }) {
    return CalderumThemeExtension(
      magicPurple: magicPurple ?? this.magicPurple,
      mysticalGold: mysticalGold ?? this.mysticalGold,
      cauldronSurface: cauldronSurface ?? this.cauldronSurface,
      ingredientColors: ingredientColors ?? this.ingredientColors,
      magicalGradients: magicalGradients ?? this.magicalGradients,
      shadowLevel: shadowLevel ?? this.shadowLevel,
    );
  }

  @override
  CalderumThemeExtension lerp(
    ThemeExtension<CalderumThemeExtension>? other,
    double t,
  ) {
    if (other is! CalderumThemeExtension) {
      return this;
    }
    return CalderumThemeExtension(
      magicPurple: Color.lerp(magicPurple, other.magicPurple, t)!,
      mysticalGold: Color.lerp(mysticalGold, other.mysticalGold, t)!,
      cauldronSurface: Color.lerp(cauldronSurface, other.cauldronSurface, t)!,
      ingredientColors: _lerpColorMap(ingredientColors, other.ingredientColors, t),
      magicalGradients: magicalGradients, // Gradients don't interpolate simply
      shadowLevel: shadowLevel,
    );
  }
  
  Map<String, Color> _lerpColorMap(
    Map<String, Color> a, 
    Map<String, Color> b, 
    double t,
  ) {
    final result = <String, Color>{};
    for (final key in a.keys) {
      if (b.containsKey(key)) {
        result[key] = Color.lerp(a[key], b[key], t)!;
      } else {
        result[key] = a[key]!;
      }
    }
    return result;
  }
}
```

#### Dynamic Theme Switching Implementation

```dart
class CalderumThemeManager extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode {
    switch (_themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    }
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }
  
  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }
}

// Provider for theme management
final themeManagerProvider = ChangeNotifierProvider<CalderumThemeManager>(
  (ref) => CalderumThemeManager(),
);
```

#### Color Scheme Generation for Both Themes

```dart
class CalderumColorSchemes {
  // Dark Theme Color Scheme
  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: const Color(0xFF6B4E96),
    brightness: Brightness.dark,
    background: const Color(0xFF1A1A2E),
    surface: const Color(0xFF16213E),
    primary: const Color(0xFF6B4E96),
    secondary: const Color(0xFFD4AF37),
    error: const Color(0xFFF44336),
    onBackground: const Color(0xFFE1E1E1),
    onSurface: const Color(0xFFE1E1E1),
    onPrimary: const Color(0xFFFFFFFF),
    onSecondary: const Color(0xFF1A1A2E),
    onError: const Color(0xFFFFFFFF),
  );
  
  // Light Theme Color Scheme
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: const Color(0xFF8B5FBF),
    brightness: Brightness.light,
    background: const Color(0xFFF5F3F0),
    surface: const Color(0xFFFFFFFF),
    primary: const Color(0xFF8B5FBF),
    secondary: const Color(0xFFF4C542),
    error: const Color(0xFFD32F2F),
    onBackground: const Color(0xFF2D2D2D),
    onSurface: const Color(0xFF1C1C1C),
    onPrimary: const Color(0xFFFFFFFF),
    onSecondary: const Color(0xFF2D2D2D),
    onError: const Color(0xFFFFFFFF),
  );
  
  // Theme-specific extensions
  static CalderumThemeExtension get darkExtension => CalderumThemeExtension(
    magicPurple: const Color(0xFF6B4E96),
    mysticalGold: const Color(0xFFD4AF37),
    cauldronSurface: const Color(0xFF16213E),
    ingredientColors: CalderumDarkTheme.ingredients,
    magicalGradients: {
      'purpleToGold': CalderumDarkTheme.purpleToGold,
      'darkToLightPurple': CalderumDarkTheme.darkToLightPurple,
      'blueToPurple': CalderumDarkTheme.blueToPurple,
    },
    shadowLevel: CalderumElevation.level2,
  );
  
  static CalderumThemeExtension get lightExtension => CalderumThemeExtension(
    magicPurple: const Color(0xFF8B5FBF),
    mysticalGold: const Color(0xFFF4C542),
    cauldronSurface: const Color(0xFFFFFFFF),
    ingredientColors: CalderumLightTheme.ingredients,
    magicalGradients: {
      'purpleToGold': CalderumLightTheme.purpleToGold,
      'lightToMediumPurple': CalderumLightTheme.lightToMediumPurple,
      'blueToLightPurple': CalderumLightTheme.blueToLightPurple,
    },
    shadowLevel: CalderumElevation.level1,
  );
}
```

#### Component Theme Inheritance Patterns

```dart
class CalderumComponentThemes {
  // Elevated Button Theme
  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shadowColor: colorScheme.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CalderumSpacing.md),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: CalderumSpacing.lg,
          vertical: CalderumSpacing.md,
        ),
        textStyle: CalderumTypography.labelLarge,
      ),
    );
  }
  
  // Card Theme
  static CardTheme cardTheme(ColorScheme colorScheme) {
    return CardTheme(
      color: colorScheme.surface,
      shadowColor: Colors.black.withOpacity(0.1),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CalderumSpacing.lg),
      ),
      margin: EdgeInsets.all(CalderumSpacing.sm),
    );
  }
  
  // Input Decoration Theme
  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      fillColor: colorScheme.surface,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CalderumSpacing.md),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CalderumSpacing.md),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CalderumSpacing.md),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      labelStyle: CalderumTypography.labelLarge.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      contentPadding: EdgeInsets.all(CalderumSpacing.lg),
    );
  }
  
  // AppBar Theme
  static AppBarTheme appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: CalderumTypography.h3.copyWith(
        color: colorScheme.onSurface,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: CalderumSpacing.xl,
      ),
    );
  }
}
```

### 4. Seasonal and Event Theming

#### Framework for Seasonal Color Variations

```dart
enum Season { spring, summer, autumn, winter }
enum SpecialEvent { halloween, christmas, newYear, anniversary }

class CalderumSeasonalThemes {
  // Spring Theme - Fresh Growth and Renewal
  static Map<String, Color> get springColors => {
    'primary': const Color(0xFF7CB342),        // Fresh green
    'secondary': const Color(0xFFFFEB3B),      // Bright yellow
    'accent': const Color(0xFFE1BEE7),         // Soft lavender
    'surface': const Color(0xFFF1F8E9),        // Light green tint
  };
  
  // Summer Theme - Vibrant Energy
  static Map<String, Color> get summerColors => {
    'primary': const Color(0xFFFF7043),        // Coral orange
    'secondary': const Color(0xFF29B6F6),      // Sky blue
    'accent': const Color(0xFFFFC107),         // Sun yellow
    'surface': const Color(0xFFFFF3E0),        // Warm cream
  };
  
  // Autumn Theme - Rich Harvest
  static Map<String, Color> get autumnColors => {
    'primary': const Color(0xFFD84315),        // Deep orange
    'secondary': const Color(0xFF8D6E63),      // Warm brown
    'accent': const Color(0xFFFFB74D),         // Golden amber
    'surface': const Color(0xFFFBE9E7),        // Warm pink
  };
  
  // Winter Theme - Mystical Frost
  static Map<String, Color> get winterColors => {
    'primary': const Color(0xFF1976D2),        // Deep blue
    'secondary': const Color(0xFF90CAF9),      // Ice blue
    'accent': const Color(0xFFE1F5FE),         // Frost white
    'surface': const Color(0xFFF3E5F5),        // Cool lavender
  };
  
  static Map<String, Color> getSeasonalPalette(Season season) {
    switch (season) {
      case Season.spring:
        return springColors;
      case Season.summer:
        return summerColors;
      case Season.autumn:
        return autumnColors;
      case Season.winter:
        return winterColors;
    }
  }
}

// Special Event Theme Overlays
class CalderumEventThemes {
  // Halloween - Spooky Mystical
  static Map<String, Color> get halloweenColors => {
    'primary': const Color(0xFFFF6F00),        // Jack-o'-lantern orange
    'secondary': const Color(0xFF4A148C),      // Deep purple
    'accent': const Color(0xFF212121),         // Midnight black
    'surface': const Color(0xFF3E2723),        // Dark brown
    'magical': const Color(0xFF76FF03),        // Eerie green
  };
  
  // Christmas - Festive Magic
  static Map<String, Color> get christmasColors => {
    'primary': const Color(0xFFC62828),        // Christmas red
    'secondary': const Color(0xFF2E7D32),      // Evergreen
    'accent': const Color(0xFFFFD700),         // Gold star
    'surface': const Color(0xFFF8F8FF),        // Snow white
    'magical': const Color(0xFFE8F5E8),        // Mint frost
  };
  
  // New Year - Celebration Sparkle
  static Map<String, Color> get newYearColors => {
    'primary': const Color(0xFFFFD700),        // Gold celebration
    'secondary': const Color(0xFF1A237E),      // Midnight blue
    'accent': const Color(0xFFE1BEE7),         // Champagne bubble
    'surface': const Color(0xFFF3E5F5),        // Soft celebration
    'magical': const Color(0xFFFFE082),        // Sparkler gold
  };
  
  static Map<String, Color> getEventPalette(SpecialEvent event) {
    switch (event) {
      case SpecialEvent.halloween:
        return halloweenColors;
      case SpecialEvent.christmas:
        return christmasColors;
      case SpecialEvent.newYear:
        return newYearColors;
      case SpecialEvent.anniversary:
        return CalderumSeasonalThemes.springColors; // Use spring as anniversary
    }
  }
}
```

#### Holiday-Specific Magical Elements

```dart
class CalderumMagicalEffects {
  // Halloween Effects
  static List<ParticleEffect> get halloweenEffects => [
    ParticleEffect(
      type: ParticleType.floating,
      particles: ['🦇', '🕷️', '👻'],
      color: const Color(0xFFFF6F00),
      speed: 0.5,
      density: 0.3,
    ),
    ParticleEffect(
      type: ParticleType.sparkling,
      particles: ['✨', '🔮'],
      color: const Color(0xFF76FF03),
      speed: 1.2,
      density: 0.2,
    ),
  ];
  
  // Christmas Effects  
  static List<ParticleEffect> get christmasEffects => [
    ParticleEffect(
      type: ParticleType.falling,
      particles: ['❄️', '⭐', '🎄'],
      color: const Color(0xFFF8F8FF),
      speed: 0.8,
      density: 0.4,
    ),
    ParticleEffect(
      type: ParticleType.twinkling,
      particles: ['✨', '💫'],
      color: const Color(0xFFFFD700),
      speed: 1.5,
      density: 0.3,
    ),
  ];
  
  // New Year Effects
  static List<ParticleEffect> get newYearEffects => [
    ParticleEffect(
      type: ParticleType.exploding,
      particles: ['🎆', '🎇', '✨'],
      color: const Color(0xFFFFD700),
      speed: 2.0,
      density: 0.6,
    ),
    ParticleEffect(
      type: ParticleType.confetti,
      particles: ['🎊'],
      color: const Color(0xFFE1BEE7),
      speed: 1.0,
      density: 0.5,
    ),
  ];
}

enum ParticleType { floating, falling, sparkling, twinkling, exploding, confetti }

class ParticleEffect {
  final ParticleType type;
  final List<String> particles;
  final Color color;
  final double speed;
  final double density;
  
  const ParticleEffect({
    required this.type,
    required this.particles,
    required this.color,
    required this.speed,
    required this.density,
  });
}
```

#### Tournament/Competition Theming Options

```dart
class CalderumTournamentThemes {
  // Championship Gold Theme
  static Map<String, Color> get championshipColors => {
    'primary': const Color(0xFFFFD700),        // Champion gold
    'secondary': const Color(0xFFFF8F00),      // Victory amber
    'accent': const Color(0xFFFFE082),         // Highlight gold
    'surface': const Color(0xFFFFF8E1),        // Cream background
    'trophy': const Color(0xFFB8860B),         // Dark gold trophy
  };
  
  // Competitive Fire Theme
  static Map<String, Color> get competitiveColors => {
    'primary': const Color(0xFFFF3D00),        // Intense red-orange
    'secondary': const Color(0xFFFF9100),      // Energy orange
    'accent': const Color(0xFFFFAB00),         // Competitive amber
    'surface': const Color(0xFFFFE0B2),        // Warm competitive
    'flame': const Color(0xFFDD2C00),          // Fire red
  };
  
  // Master Alchemist Theme (High Rank)
  static Map<String, Color> get masterAlchemistColors => {
    'primary': const Color(0xFF6A1B9A),        // Deep mystical purple
    'secondary': const Color(0xFF8E24AA),      // Royal purple
    'accent': const Color(0xFFAB47BC),         // Light mystical
    'surface': const Color(0xFFF3E5F5),        // Soft purple
    'mastery': const Color(0xFF4A148C),        // Dark mastery
  };
  
  static Map<String, Color> getTournamentPalette(TournamentRank rank) {
    switch (rank) {
      case TournamentRank.champion:
        return championshipColors;
      case TournamentRank.competitive:
        return competitiveColors;
      case TournamentRank.master:
        return masterAlchemistColors;
      case TournamentRank.standard:
        return CalderumColorTokens.semantic;
    }
  }
}

enum TournamentRank { champion, competitive, master, standard }
```

### 5. Advanced Visual Features

#### Gradient System with Light/Dark Variants

```dart
class CalderumGradientSystem {
  // Base Gradient Patterns
  static const Map<String, List<Color>> gradientPalettes = {
    'mystical': [Color(0xFF6B4E96), Color(0xFF8E24AA), Color(0xFFAB47BC)],
    'golden': [Color(0xFFD4AF37), Color(0xFFF4C542), Color(0xFFFFE082)],
    'elemental': [Color(0xFF4CAF50), Color(0xFF2196F3), Color(0xFFFF9800)],
    'celestial': [Color(0xFF1976D2), Color(0xFF7B1FA2), Color(0xFF303F9F)],
    'ember': [Color(0xFFFF5722), Color(0xFFFF9800), Color(0xFFFFD54F)],
  };
  
  // Dark Theme Gradients
  static LinearGradient getDarkGradient(String name) {
    final colors = gradientPalettes[name] ?? gradientPalettes['mystical']!;
    return LinearGradient(
      colors: colors.map((c) => c.withOpacity(0.9)).toList(),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  // Light Theme Gradients (Softer, Higher Opacity)
  static LinearGradient getLightGradient(String name) {
    final colors = gradientPalettes[name] ?? gradientPalettes['mystical']!;
    return LinearGradient(
      colors: colors.map((c) => c.withOpacity(0.7)).toList(),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  // Radial Gradients for Cauldron Effects
  static RadialGradient getCauldronGradient(String ingredientType, bool isDark) {
    final baseColor = CalderumColorTokens.semantic['ingredient$ingredientType'] 
        ?? CalderumColorTokens.semantic['primary']!;
    
    final opacity = isDark ? 0.8 : 0.6;
    return RadialGradient(
      colors: [
        baseColor.withOpacity(opacity),
        baseColor.withOpacity(opacity * 0.5),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
      center: Alignment.center,
    );
  }
  
  // Animated Shimmer Gradients
  static LinearGradient getShimmerGradient(bool isDark, double animationValue) {
    final baseColor = isDark 
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.1);
    
    final highlightColor = isDark 
        ? Colors.white.withOpacity(0.3)
        : Colors.black.withOpacity(0.2);
    
    return LinearGradient(
      colors: [baseColor, highlightColor, baseColor],
      stops: [
        (animationValue - 0.3).clamp(0.0, 1.0),
        animationValue.clamp(0.0, 1.0),
        (animationValue + 0.3).clamp(0.0, 1.0),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }
}
```

#### Icon Theming with Adaptive Colors

```dart
class CalderumIconTheme {
  // Base Icon Styles
  static IconThemeData getIconTheme(ColorScheme colorScheme, bool isDark) {
    return IconThemeData(
      color: colorScheme.onSurface,
      size: CalderumSpacing.xl,
      opacity: isDark ? 0.87 : 0.8,
    );
  }
  
  // Ingredient-Specific Icon Colors
  static Color getIngredientIconColor(String ingredientType, bool isDark) {
    final baseColors = isDark 
        ? CalderumDarkTheme.ingredients 
        : CalderumLightTheme.ingredients;
    
    return baseColors[ingredientType] ?? 
           (isDark ? Colors.white : Colors.black);
  }
  
  // Action Icon Colors with Semantic Meaning
  static Color getActionIconColor(String actionType, ColorScheme colorScheme) {
    switch (actionType) {
      case 'success':
      case 'add':
      case 'brew':
        return colorScheme.primary;
      case 'danger':
      case 'explode':
      case 'remove':
        return CalderumColorTokens.semantic['error']!;
      case 'warning':
      case 'caution':
        return CalderumColorTokens.semantic['warning']!;
      case 'info':
      case 'help':
        return CalderumColorTokens.semantic['info']!;
      default:
        return colorScheme.onSurface;
    }
  }
  
  // Adaptive Icon Variations
  static IconData getAdaptiveIcon(String iconName, bool isDark) {
    const darkIcons = {
      'cauldron': Icons.local_fire_department_outlined,
      'ingredient': Icons.scatter_plot_outlined,
      'magic': Icons.auto_fix_high_outlined,
      'player': Icons.person_outline,
      'settings': Icons.settings_outlined,
      'help': Icons.help_outline,
    };
    
    const lightIcons = {
      'cauldron': Icons.local_fire_department,
      'ingredient': Icons.scatter_plot,
      'magic': Icons.auto_fix_high,
      'player': Icons.person,
      'settings': Icons.settings,
      'help': Icons.help,
    };
    
    final iconSet = isDark ? darkIcons : lightIcons;
    return iconSet[iconName] ?? Icons.help_outline;
  }
}
```

### 6. Implementation Guidelines

#### Flutter MaterialApp Theme Configuration

```dart
class CalderumApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeManager = ref.watch(themeManagerProvider);
    
    return MaterialApp.router(
      title: 'Calderum',
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: themeManager.themeMode,
      
      routerConfig: router,
    );
  }
  
  ThemeData _buildLightTheme() {
    final colorScheme = CalderumColorSchemes.lightColorScheme;
    final extension = CalderumColorSchemes.lightExtension;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      
      // Typography
      textTheme: _buildTextTheme(colorScheme),
      
      // Component Themes
      elevatedButtonTheme: CalderumComponentThemes.elevatedButtonTheme(colorScheme),
      cardTheme: CalderumComponentThemes.cardTheme(colorScheme),
      inputDecorationTheme: CalderumComponentThemes.inputDecorationTheme(colorScheme),
      appBarTheme: CalderumComponentThemes.appBarTheme(colorScheme),
      
      // Extensions
      extensions: [extension],
      
      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Splash and Focus
      splashFactory: InkRipple.splashFactory,
      focusColor: colorScheme.primary.withOpacity(0.12),
      hoverColor: colorScheme.primary.withOpacity(0.04),
    );
  }
  
  ThemeData _buildDarkTheme() {
    final colorScheme = CalderumColorSchemes.darkColorScheme;
    final extension = CalderumColorSchemes.darkExtension;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      
      // Typography
      textTheme: _buildTextTheme(colorScheme),
      
      // Component Themes
      elevatedButtonTheme: CalderumComponentThemes.elevatedButtonTheme(colorScheme),
      cardTheme: CalderumComponentThemes.cardTheme(colorScheme),
      inputDecorationTheme: CalderumComponentThemes.inputDecorationTheme(colorScheme),
      appBarTheme: CalderumComponentThemes.appBarTheme(colorScheme),
      
      // Extensions
      extensions: [extension],
      
      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Splash and Focus
      splashFactory: InkRipple.splashFactory,
      focusColor: colorScheme.primary.withOpacity(0.12),
      hoverColor: colorScheme.primary.withOpacity(0.04),
    );
  }
  
  TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: CalderumTypography.h1.copyWith(color: colorScheme.onBackground),
      displayMedium: CalderumTypography.h2.copyWith(color: colorScheme.onBackground),
      displaySmall: CalderumTypography.h3.copyWith(color: colorScheme.onBackground),
      bodyLarge: CalderumTypography.bodyLarge.copyWith(color: colorScheme.onSurface),
      bodyMedium: CalderumTypography.bodyMedium.copyWith(color: colorScheme.onSurface),
      labelLarge: CalderumTypography.labelLarge.copyWith(color: colorScheme.onSurface),
    );
  }
}
```

#### Custom Theme Extension Implementation

```dart
// Theme-Aware Widget Building Pattern
class CalderumThemedWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final calderumTheme = theme.extension<CalderumThemeExtension>()!;
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        gradient: calderumTheme.magicalGradients['purpleToGold'],
        borderRadius: BorderRadius.circular(CalderumSpacing.lg),
        boxShadow: calderumTheme.shadowLevel,
      ),
      child: Text(
        'Magical Content',
        style: CalderumTypography.magical.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}

// Extension Method for Easy Theme Access
extension BuildContextThemeExtensions on BuildContext {
  CalderumThemeExtension get calderumTheme {
    return Theme.of(this).extension<CalderumThemeExtension>()!;
  }
  
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }
  
  Color get magicPurple => calderumTheme.magicPurple;
  Color get mysticalGold => calderumTheme.mysticalGold;
  
  Map<String, Color> get ingredientColors => calderumTheme.ingredientColors;
  List<BoxShadow> get shadowLevel => calderumTheme.shadowLevel;
}
```

#### Theme-Aware Component Building Patterns

```dart
// Adaptive Color Builder
class AdaptiveColorBuilder extends StatelessWidget {
  final Color lightColor;
  final Color darkColor;
  final Widget Function(Color color) builder;
  
  const AdaptiveColorBuilder({
    Key? key,
    required this.lightColor,
    required this.darkColor,
    required this.builder,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final color = isDark ? darkColor : lightColor;
    return builder(color);
  }
}

// Theme-Aware Ingredient Chip
class IngredientChip extends StatelessWidget {
  final String ingredientType;
  final bool isSelected;
  final VoidCallback? onTap;
  
  const IngredientChip({
    Key? key,
    required this.ingredientType,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final ingredientColor = context.ingredientColors[ingredientType] ?? 
                           context.magicPurple;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: CalderumAnimations.fast,
        curve: CalderumAnimations.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? ingredientColor : ingredientColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(CalderumSpacing.lg),
          boxShadow: isSelected ? context.shadowLevel : null,
          border: Border.all(
            color: ingredientColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: EdgeInsets.all(CalderumSpacing.sm),
        child: Icon(
          CalderumIconTheme.getAdaptiveIcon('ingredient', context.isDarkMode),
          color: isSelected 
              ? (context.isDarkMode ? Colors.white : Colors.black87)
              : ingredientColor,
          size: CalderumSpacing.xl,
        ),
      ),
    );
  }
}
```

#### Performance Optimization for Theme Switching

```dart
class ThemeOptimizedWidget extends StatefulWidget {
  @override
  _ThemeOptimizedWidgetState createState() => _ThemeOptimizedWidgetState();
}

class _ThemeOptimizedWidgetState extends State<ThemeOptimizedWidget> 
    with TickerProviderStateMixin {
  
  late AnimationController _themeTransitionController;
  late Animation<double> _themeTransitionAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _themeTransitionController = AnimationController(
      duration: CalderumAnimations.normal,
      vsync: this,
    );
    
    _themeTransitionAnimation = CurvedAnimation(
      parent: _themeTransitionController,
      curve: CalderumAnimations.easeInOut,
    );
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Animate theme transitions
    _themeTransitionController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _themeTransitionAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.1, 0),
          end: Offset.zero,
        ).animate(_themeTransitionAnimation),
        child: _buildContent(context),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context) {
    // Cached theme-dependent content
    return const Placeholder();
  }
  
  @override
  void dispose() {
    _themeTransitionController.dispose();
    super.dispose();
  }
}

// Memoized Theme-Dependent Builders
class MemoizedThemeBuilder extends StatelessWidget {
  final Widget Function(ThemeData theme) builder;
  
  const MemoizedThemeBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return _MemoizedWrapper(
      theme: Theme.of(context),
      builder: builder,
    );
  }
}

class _MemoizedWrapper extends StatelessWidget {
  final ThemeData theme;
  final Widget Function(ThemeData theme) builder;
  
  const _MemoizedWrapper({
    required this.theme,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context) {
    return builder(theme);
  }
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
           other is _MemoizedWrapper &&
           runtimeType == other.runtimeType &&
           theme == other.theme;
  }
  
  @override
  int get hashCode => theme.hashCode;
}
```

This comprehensive design system expansion provides:

1. **Complete Light Theme** - Accessible, magical aesthetic with proper contrast ratios
2. **Comprehensive Design Tokens** - 4px grid system, semantic colors, typography scales
3. **Advanced Theming Architecture** - Extensions, dynamic switching, inheritance patterns
4. **Seasonal/Event Theming** - Framework for special occasions and tournaments
5. **Advanced Visual Features** - Gradients, adaptive icons, performance optimization
6. **Implementation Guidelines** - Complete Flutter integration with code examples

The system maintains the magical potion brewing aesthetic across both light and dark themes while providing excellent accessibility and developer experience through consistent tokens and patterns.

## User Experience Improvements for Complex Interactions

This section provides comprehensive specifications for enhancing complex user interactions within the Calderum design system, focusing on making the intricate Quacks of Quedlinburg game mechanics intuitive and enjoyable while maintaining the magical theme.

### 1. **Progressive Disclosure Patterns**

Progressive disclosure reduces cognitive load by revealing information and options gradually, allowing users to focus on immediate tasks while maintaining access to advanced features when needed.

#### Multi-step Wizards for Complex Game Setup

**Game Room Creation Wizard**

```dart
class GameSetupWizard extends StatefulWidget {
  @override
  _GameSetupWizardState createState() => _GameSetupWizardState();
}

class _GameSetupWizardState extends State<GameSetupWizard> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;
  
  final List<WizardStep> _steps = [
    WizardStep(
      title: "Basic Settings",
      description: "Choose your brewing preferences",
      icon: CalderumIcons.cauldron,
    ),
    WizardStep(
      title: "Ingredient Sets",
      description: "Select magical ingredients",
      icon: CalderumIcons.ingredients,
    ),
    WizardStep(
      title: "Advanced Rules",
      description: "Customize game mechanics",
      icon: CalderumIcons.scroll,
    ),
    WizardStep(
      title: "Review & Create",
      description: "Confirm your magical setup",
      icon: CalderumIcons.wand,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildWizardAppBar(context),
      body: Column(
        children: [
          _buildProgressIndicator(context),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _steps.length,
              itemBuilder: (context, index) => _buildStepContent(context, index),
            ),
          ),
          _buildNavigationButtons(context),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(CalderumSpacing.lg),
      child: Column(
        children: [
          // Magical progress bar with sparkle effects
          Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: context.onSurface.withOpacity(0.2),
                ),
              ),
              AnimatedContainer(
                duration: CalderumAnimations.normal,
                height: 4,
                width: MediaQuery.of(context).size.width * 
                       (_currentStep + 1) / _totalSteps * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: [context.magicPurple, context.mysticalGold],
                  ),
                ),
              ),
              // Sparkle effect at progress head
              AnimatedPositioned(
                duration: CalderumAnimations.normal,
                left: MediaQuery.of(context).size.width * 
                      (_currentStep + 1) / _totalSteps * 0.85 - 8,
                top: -4,
                child: Icon(
                  CalderumIcons.sparkle,
                  color: context.mysticalGold,
                  size: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: CalderumSpacing.md),
          Text(
            "${_currentStep + 1} of $_totalSteps: ${_steps[_currentStep].title}",
            style: context.textTheme.titleMedium?.copyWith(
              color: context.magicPurple,
              fontFamily: 'Caudex',
            ),
          ),
          Text(
            _steps[_currentStep].description,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Contextual Help and Tooltips System**

```dart
class MagicalTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final Widget? richContent;
  final TooltipPosition position;
  final bool showOnTap;
  final VoidCallback? onTooltipTap;

  const MagicalTooltip({
    Key? key,
    required this.child,
    required this.message,
    this.richContent,
    this.position = TooltipPosition.top,
    this.showOnTap = false,
    this.onTooltipTap,
  }) : super(key: key);

  @override
  _MagicalTooltipState createState() => _MagicalTooltipState();
}

class _MagicalTooltipState extends State<MagicalTooltip>
    with TickerProviderStateMixin {
  
  bool _isVisible = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: CalderumAnimations.fast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.showOnTap ? _toggleTooltip : null,
      onLongPress: !widget.showOnTap ? _showTooltip : null,
      child: Stack(
        children: [
          widget.child,
          if (_isVisible) _buildTooltip(context),
        ],
      ),
    );
  }

  Widget _buildTooltip(BuildContext context) {
    return Positioned.fill(
      child: CustomSingleChildScrollView(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  margin: EdgeInsets.only(
                    top: widget.position == TooltipPosition.bottom ? 40 : 0,
                    bottom: widget.position == TooltipPosition.top ? 40 : 0,
                  ),
                  padding: EdgeInsets.all(CalderumSpacing.md),
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.circular(CalderumSpacing.md),
                    border: Border.all(
                      color: context.magicPurple.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.magicPurple.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: widget.richContent ?? Text(
                    widget.message,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.onSurface,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

**Expandable Information Panels**

```dart
class MagicalExpansionPanel extends StatefulWidget {
  final String title;
  final Widget content;
  final IconData icon;
  final bool initiallyExpanded;
  final VoidCallback? onExpansionChanged;

  const MagicalExpansionPanel({
    Key? key,
    required this.title,
    required this.content,
    required this.icon,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  }) : super(key: key);

  @override
  _MagicalExpansionPanelState createState() => _MagicalExpansionPanelState();
}

class _MagicalExpansionPanelState extends State<MagicalExpansionPanel>
    with TickerProviderStateMixin {
  
  bool _isExpanded = false;
  late AnimationController _rotationController;
  late AnimationController _expansionController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _expansionAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    
    _rotationController = AnimationController(
      duration: CalderumAnimations.fast,
      vsync: this,
    );
    
    _expansionController = AnimationController(
      duration: CalderumAnimations.normal,
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));
    
    _expansionAnimation = CurvedAnimation(
      parent: _expansionController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _rotationController.value = 1.0;
      _expansionController.value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: CalderumSpacing.xs,
        horizontal: CalderumSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CalderumSpacing.md),
        side: BorderSide(
          color: _isExpanded 
              ? context.magicPurple.withOpacity(0.3)
              : context.onSurface.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(CalderumSpacing.md),
            child: Padding(
              padding: EdgeInsets.all(CalderumSpacing.md),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: context.magicPurple,
                    size: 20,
                  ),
                  SizedBox(width: CalderumSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontFamily: 'Caudex',
                        color: context.onSurface,
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * math.pi,
                        child: Icon(
                          Icons.expand_more,
                          color: context.onSurface.withOpacity(0.7),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expansionAnimation,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                CalderumSpacing.md,
                0,
                CalderumSpacing.md,
                CalderumSpacing.md,
              ),
              child: widget.content,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _rotationController.forward();
        _expansionController.forward();
      } else {
        _rotationController.reverse();
        _expansionController.reverse();
      }
    });
    
    widget.onExpansionChanged?.call();
  }
}
```

#### Smart Defaults and Guided Decision Making

**Intelligent Game Setup Assistant**

```dart
class GameSetupAssistant extends StatefulWidget {
  final Function(GameConfiguration) onConfigurationComplete;

  const GameSetupAssistant({
    Key? key,
    required this.onConfigurationComplete,
  }) : super(key: key);

  @override
  _GameSetupAssistantState createState() => _GameSetupAssistantState();
}

class _GameSetupAssistantState extends State<GameSetupAssistant> {
  GameConfiguration _configuration = GameConfiguration.defaultSetup();
  List<String> _playerExperience = [];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildExperienceSelector(context),
        SizedBox(height: CalderumSpacing.lg),
        _buildSmartRecommendations(context),
        SizedBox(height: CalderumSpacing.lg),
        _buildConfigurationPreview(context),
      ],
    );
  }

  Widget _buildExperienceSelector(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(CalderumSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  CalderumIcons.wizardHat,
                  color: context.magicPurple,
                ),
                SizedBox(width: CalderumSpacing.sm),
                Text(
                  "Player Experience",
                  style: context.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Caudex',
                    color: context.magicPurple,
                  ),
                ),
              ],
            ),
            SizedBox(height: CalderumSpacing.md),
            Text(
              "Tell us about the players to get personalized recommendations:",
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.onSurface.withOpacity(0.8),
              ),
            ),
            SizedBox(height: CalderumSpacing.md),
            Wrap(
              spacing: CalderumSpacing.sm,
              runSpacing: CalderumSpacing.sm,
              children: [
                _buildExperienceChip(context, "First Time", "new"),
                _buildExperienceChip(context, "Casual", "casual"),
                _buildExperienceChip(context, "Experienced", "experienced"),
                _buildExperienceChip(context, "Expert", "expert"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartRecommendations(BuildContext context) {
    final recommendations = _generateRecommendations();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(CalderumSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  CalderumIcons.lightbulb,
                  color: context.mysticalGold,
                ),
                SizedBox(width: CalderumSpacing.sm),
                Text(
                  "Magical Recommendations",
                  style: context.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Caudex',
                    color: context.mysticalGold,
                  ),
                ),
              ],
            ),
            SizedBox(height: CalderumSpacing.md),
            ...recommendations.map((recommendation) => 
              _buildRecommendationItem(context, recommendation)
            ),
            SizedBox(height: CalderumSpacing.md),
            ElevatedButton.icon(
              onPressed: _applyRecommendations,
              icon: Icon(CalderumIcons.wand),
              label: Text("Apply Recommendations"),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.mysticalGold,
                foregroundColor: context.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. **Game Mechanic Guidance**

Interactive tutorials and contextual coaching help players understand complex game mechanics without overwhelming them with information.

#### Interactive Tutorials and Onboarding Flows

**Adaptive Tutorial System**

```dart
class MagicalTutorial extends StatefulWidget {
  final List<TutorialStep> steps;
  final Function(int) onStepCompleted;
  final VoidCallback onTutorialCompleted;
  final bool allowSkip;

  const MagicalTutorial({
    Key? key,
    required this.steps,
    required this.onStepCompleted,
    required this.onTutorialCompleted,
    this.allowSkip = true,
  }) : super(key: key);

  @override
  _MagicalTutorialState createState() => _MagicalTutorialState();
}

class _MagicalTutorialState extends State<MagicalTutorial>
    with TickerProviderStateMixin {
  
  int _currentStep = 0;
  late AnimationController _pulseController;
  late AnimationController _highlightController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _highlightAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _highlightController = AnimationController(
      duration: CalderumAnimations.normal,
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _highlightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _highlightController,
      curve: Curves.easeOut,
    ));

    _highlightController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStep >= widget.steps.length) {
      return SizedBox.shrink();
    }

    final currentTutorialStep = widget.steps[_currentStep];

    return Stack(
      children: [
        // Overlay background
        Container(
          color: Colors.black.withOpacity(0.7),
        ),
        
        // Highlighted area
        if (currentTutorialStep.targetWidget != null)
          _buildHighlightedArea(context, currentTutorialStep),
        
        // Tutorial content
        Positioned(
          bottom: 120,
          left: CalderumSpacing.lg,
          right: CalderumSpacing.lg,
          child: _buildTutorialCard(context, currentTutorialStep),
        ),
        
        // Skip button
        if (widget.allowSkip)
          Positioned(
            top: 60,
            right: CalderumSpacing.lg,
            child: _buildSkipButton(context),
          ),
      ],
    );
  }

  Widget _buildHighlightedArea(BuildContext context, TutorialStep step) {
    return AnimatedBuilder(
      animation: _highlightAnimation,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Positioned(
              left: step.targetRect!.left - 8,
              top: step.targetRect!.top - 8,
              child: Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: step.targetRect!.width + 16,
                  height: step.targetRect!.height + 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      CalderumSpacing.md + 4
                    ),
                    border: Border.all(
                      color: context.mysticalGold.withOpacity(
                        _highlightAnimation.value
                      ),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.mysticalGold.withOpacity(
                          0.3 * _highlightAnimation.value
                        ),
                        blurRadius: 12,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTutorialCard(BuildContext context, TutorialStep step) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CalderumSpacing.lg),
      ),
      child: Padding(
        padding: EdgeInsets.all(CalderumSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentStep + 1) / widget.steps.length,
              backgroundColor: context.onSurface.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                context.magicPurple
              ),
            ),
            SizedBox(height: CalderumSpacing.md),
            
            // Step counter and title
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: CalderumSpacing.sm,
                    vertical: CalderumSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.magicPurple,
                    borderRadius: BorderRadius.circular(
                      CalderumSpacing.sm
                    ),
                  ),
                  child: Text(
                    "${_currentStep + 1}/${widget.steps.length}",
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: CalderumSpacing.sm),
                Expanded(
                  child: Text(
                    step.title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontFamily: 'Caudex',
                      color: context.magicPurple,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: CalderumSpacing.md),
            
            // Description
            Text(
              step.description,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.onSurface.withOpacity(0.8),
              ),
            ),
            
            if (step.interactiveContent != null) ...[
              SizedBox(height: CalderumSpacing.md),
              step.interactiveContent!,
            ],
            
            SizedBox(height: CalderumSpacing.lg),
            
            // Navigation buttons
            Row(
              children: [
                if (_currentStep > 0)
                  TextButton.icon(
                    onPressed: _previousStep,
                    icon: Icon(Icons.chevron_left),
                    label: Text("Previous"),
                  ),
                
                Spacer(),
                
                ElevatedButton.icon(
                  onPressed: _nextStep,
                  icon: Icon(_currentStep == widget.steps.length - 1
                      ? CalderumIcons.checkMark
                      : Icons.chevron_right),
                  label: Text(_currentStep == widget.steps.length - 1
                      ? "Complete"
                      : "Next"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.magicPurple,
                    foregroundColor: context.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Visual Hints and Contextual Coaching

**Dynamic Hint System**

```dart
class MagicalHintSystem extends StatefulWidget {
  final Widget child;
  final GameState gameState;
  final PlayerAction? lastAction;

  const MagicalHintSystem({
    Key? key,
    required this.child,
    required this.gameState,
    this.lastAction,
  }) : super(key: key);

  @override
  _MagicalHintSystemState createState() => _MagicalHintSystemState();
}

class _MagicalHintSystemState extends State<MagicalHintSystem>
    with TickerProviderStateMixin {
  
  List<GameHint> _activeHints = [];
  late AnimationController _hintController;
  late Animation<Offset> _slideAnimation;
  Timer? _hintTimer;

  @override
  void initState() {
    super.initState();
    
    _hintController = AnimationController(
      duration: CalderumAnimations.normal,
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _hintController,
      curve: Curves.easeOut,
    ));
    
    _analyzeGameStateForHints();
  }

  @override
  void didUpdateWidget(MagicalHintSystem oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.gameState != oldWidget.gameState ||
        widget.lastAction != oldWidget.lastAction) {
      _analyzeGameStateForHints();
    }
  }

  void _analyzeGameStateForHints() {
    _hintTimer?.cancel();
    _hintTimer = Timer(Duration(seconds: 2), () {
      final newHints = HintAnalyzer.analyzeGameState(
        widget.gameState,
        widget.lastAction,
      );
      
      if (newHints.isNotEmpty && mounted) {
        setState(() {
          _activeHints = newHints;
        });
        _hintController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        
        // Hint overlay
        if (_activeHints.isNotEmpty)
          Positioned(
            top: 100,
            right: CalderumSpacing.md,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildHintCard(context),
            ),
          ),
      ],
    );
  }

  Widget _buildHintCard(BuildContext context) {
    final primaryHint = _activeHints.first;
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Card(
        elevation: 8,
        color: context.magicPurple.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CalderumSpacing.md),
        ),
        child: Padding(
          padding: EdgeInsets.all(CalderumSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    primaryHint.icon,
                    color: context.mysticalGold,
                    size: 18,
                  ),
                  SizedBox(width: CalderumSpacing.xs),
                  Text(
                    "Magical Tip",
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.mysticalGold,
                      fontFamily: 'Caudex',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: _dismissHint,
                    icon: Icon(
                      Icons.close,
                      color: context.onPrimary.withOpacity(0.7),
                      size: 16,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              
              SizedBox(height: CalderumSpacing.xs),
              
              Text(
                primaryHint.message,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.onPrimary.withOpacity(0.9),
                ),
              ),
              
              if (primaryHint.hasAction)
                Padding(
                  padding: EdgeInsets.only(top: CalderumSpacing.sm),
                  child: TextButton.icon(
                    onPressed: primaryHint.action,
                    icon: Icon(
                      CalderumIcons.wand,
                      size: 14,
                    ),
                    label: Text(
                      primaryHint.actionLabel ?? "Show Me",
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: context.mysticalGold,
                      padding: EdgeInsets.symmetric(
                        horizontal: CalderumSpacing.sm,
                        vertical: CalderumSpacing.xs,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _dismissHint() {
    _hintController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _activeHints.clear();
        });
      }
    });
  }
}

class HintAnalyzer {
  static List<GameHint> analyzeGameState(
    GameState gameState,
    PlayerAction? lastAction,
  ) {
    List<GameHint> hints = [];
    
    // Risk analysis hints
    if (gameState.currentPlayer.chipSum >= 5 && 
        gameState.currentPlayer.chipSum < 7) {
      hints.add(GameHint(
        type: HintType.warning,
        icon: CalderumIcons.warning,
        message: "Caution! Your cauldron is getting hot. Consider stopping to avoid an explosion.",
        priority: HintPriority.high,
      ));
    }
    
    // Opportunity hints
    if (gameState.currentPlayer.canAffordPremiumChip() &&
        gameState.isEarlyInTurn()) {
      hints.add(GameHint(
        type: HintType.opportunity,
        icon: CalderumIcons.lightbulb,
        message: "You have enough rubies to buy powerful ingredients. Consider investing!",
        priority: HintPriority.medium,
      ));
    }
    
    // Strategic hints
    if (gameState.isPlayerBehind(gameState.currentPlayer)) {
      hints.add(GameHint(
        type: HintType.strategy,
        icon: CalderumIcons.target,
        message: "You're trailing. Taking calculated risks might help you catch up!",
        priority: HintPriority.medium,
      ));
    }
    
    return hints..sort((a, b) => b.priority.index.compareTo(a.priority.index));
  }
}
```

#### Risk/Reward Visualization

**Interactive Risk Calculator**

```dart
class RiskRewardVisualizer extends StatefulWidget {
  final GameState gameState;
  final List<IngredientChip> availableChips;
  final Function(IngredientChip) onChipSelected;

  const RiskRewardVisualizer({
    Key? key,
    required this.gameState,
    required this.availableChips,
    required this.onChipSelected,
  }) : super(key: key);

  @override
  _RiskRewardVisualizerState createState() => _RiskRewardVisualizerState();
}

class _RiskRewardVisualizerState extends State<RiskRewardVisualizer>
    with TickerProviderStateMixin {
  
  IngredientChip? _hoveredChip;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CalderumSpacing.lg),
      ),
      child: Padding(
        padding: EdgeInsets.all(CalderumSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: CalderumSpacing.md),
            _buildCurrentStatusDisplay(context),
            SizedBox(height: CalderumSpacing.lg),
            _buildChipAnalysis(context),
            if (_hoveredChip != null) ...[
              SizedBox(height: CalderumSpacing.md),
              _buildRiskAnalysisPanel(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Context context) {
    return Row(
      children: [
        Icon(
          CalderumIcons.scales,
          color: context.magicPurple,
        ),
        SizedBox(width: CalderumSpacing.sm),
        Text(
          "Risk & Reward Analysis",
          style: context.textTheme.titleMedium?.copyWith(
            fontFamily: 'Caudex',
            color: context.magicPurple,
          ),
        ),
        Spacer(),
        _buildRiskMeter(context),
      ],
    );
  }

  Widget _buildRiskMeter(BuildContext context) {
    final currentSum = widget.gameState.currentPlayer.chipSum;
    final riskLevel = _calculateRiskLevel(currentSum);
    
    return Container(
      width: 60,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: context.onSurface.withOpacity(0.2),
      ),
      child: Stack(
        children: [
          Container(
            width: 60 * (currentSum / 10),
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                colors: [
                  context.safeGreen,
                  context.cautionYellow,
                  context.dangerRed,
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
          // Explosion threshold marker
          Positioned(
            left: 60 * 0.7 - 1, // At sum of 7
            child: Container(
              width: 2,
              height: 8,
              color: context.dangerRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipAnalysis(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available Chips",
          style: context.textTheme.titleSmall?.copyWith(
            color: context.onSurface,
            fontFamily: 'Caudex',
          ),
        ),
        SizedBox(height: CalderumSpacing.sm),
        
        Wrap(
          spacing: CalderumSpacing.sm,
          runSpacing: CalderumSpacing.sm,
          children: widget.availableChips.map((chip) => 
            _buildAnalysisChip(context, chip)
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildAnalysisChip(BuildContext context, IngredientChip chip) {
    final analysis = _analyzeChipRisk(chip);
    final isHovered = _hoveredChip == chip;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredChip = chip),
      onExit: (_) => setState(() => _hoveredChip = null),
      child: GestureDetector(
        onTap: () => widget.onChipSelected(chip),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isHovered ? _pulseAnimation.value : 1.0,
              child: Container(
                padding: EdgeInsets.all(CalderumSpacing.sm),
                decoration: BoxDecoration(
                  color: chip.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(CalderumSpacing.sm),
                  border: Border.all(
                    color: isHovered 
                        ? context.mysticalGold 
                        : chip.color,
                    width: isHovered ? 2 : 1,
                  ),
                  boxShadow: isHovered ? [
                    BoxShadow(
                      color: context.mysticalGold.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ] : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      chip.icon,
                      color: chip.color,
                      size: 24,
                    ),
                    SizedBox(height: CalderumSpacing.xs),
                    Text(
                      chip.value.toString(),
                      style: context.textTheme.labelSmall?.copyWith(
                        color: chip.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: CalderumSpacing.xs),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: CalderumSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: analysis.riskColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        analysis.riskLabel,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: analysis.riskColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRiskAnalysisPanel(BuildContext context) {
    final analysis = _analyzeChipRisk(_hoveredChip!);
    
    return Container(
      padding: EdgeInsets.all(CalderumSpacing.md),
      decoration: BoxDecoration(
        color: context.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(CalderumSpacing.sm),
        border: Border.all(
          color: context.mysticalGold.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _hoveredChip!.icon,
                color: _hoveredChip!.color,
                size: 18,
              ),
              SizedBox(width: CalderumSpacing.xs),
              Text(
                "${_hoveredChip!.name} Analysis",
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.onSurface,
                  fontFamily: 'Caudex',
                ),
              ),
            ],
          ),
          
          SizedBox(height: CalderumSpacing.sm),
          
          _buildAnalysisRow(
            context,
            "Risk Level",
            analysis.riskLabel,
            analysis.riskColor,
          ),
          
          _buildAnalysisRow(
            context,
            "Explosion Chance",
            analysis.explosionChance,
            analysis.explosionChanceColor,
          ),
          
          _buildAnalysisRow(
            context,
            "Expected Points",
            analysis.expectedPoints,
            context.safeGreen,
          ),
          
          if (analysis.recommendation.isNotEmpty) ...[
            SizedBox(height: CalderumSpacing.sm),
            Text(
              "Recommendation:",
              style: context.textTheme.labelMedium?.copyWith(
                color: context.mysticalGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              analysis.recommendation,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.onSurface.withOpacity(0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

### 3. **Complex State Management**

Visual indicators and progress tracking help players understand multi-phase game states and complex information hierarchies.

#### Visual State Indicators for Multi-phase Turns

**Phase Progress Indicator**

```dart
class GamePhaseIndicator extends StatefulWidget {
  final GamePhase currentPhase;
  final List<GamePhase> allPhases;
  final Duration? phaseTimeRemaining;
  final bool isInteractive;

  const GamePhaseIndicator({
    Key? key,
    required this.currentPhase,
    required this.allPhases,
    this.phaseTimeRemaining,
    this.isInteractive = false,
  }) : super(key: key);

  @override
  _GamePhaseIndicatorState createState() => _GamePhaseIndicatorState();
}

class _GamePhaseIndicatorState extends State<GamePhaseIndicator>
    with TickerProviderStateMixin {
  
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: CalderumAnimations.normal,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();
    _startPhaseTimer();
  }

  void _startPhaseTimer() {
    if (widget.phaseTimeRemaining != null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        // Update would come from parent widget
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(CalderumSpacing.md),
      child: Column(
        children: [
          _buildPhaseHeader(context),
          SizedBox(height: CalderumSpacing.md),
          _buildPhaseProgress(context),
          if (widget.phaseTimeRemaining != null) ...[
            SizedBox(height: CalderumSpacing.sm),
            _buildTimeRemaining(context),
          ],
        ],
      ),
    );
  }

  Widget _buildPhaseHeader(BuildContext context) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: EdgeInsets.all(CalderumSpacing.sm),
                decoration: BoxDecoration(
                  color: widget.currentPhase.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(CalderumSpacing.lg),
                  border: Border.all(
                    color: widget.currentPhase.color,
                    width: 2,
                  ),
                ),
                child: Icon(
                  widget.currentPhase.icon,
                  color: widget.currentPhase.color,
                  size: 20,
                ),
              ),
            );
          },
        ),
        
        SizedBox(width: CalderumSpacing.md),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.currentPhase.displayName,
                style: context.textTheme.titleMedium?.copyWith(
                  fontFamily: 'Caudex',
                  color: widget.currentPhase.color,
                ),
              ),
              Text(
                widget.currentPhase.description,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseProgress(BuildContext context) {
    final currentIndex = widget.allPhases.indexOf(widget.currentPhase);
    
    return Row(
      children: [
        for (int i = 0; i < widget.allPhases.length; i++) ...[
          _buildPhaseStep(context, i, widget.allPhases[i], i == currentIndex),
          if (i < widget.allPhases.length - 1)
            _buildPhaseConnector(context, i < currentIndex),
        ],
      ],
    );
  }

  Widget _buildPhaseStep(
    BuildContext context,
    int index,
    GamePhase phase,
    bool isActive,
  ) {
    final isCompleted = index < widget.allPhases.indexOf(widget.currentPhase);
    
    return GestureDetector(
      onTap: widget.isInteractive ? () => _onPhaseStepTapped(phase) : null,
      child: AnimatedContainer(
        duration: CalderumAnimations.fast,
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isCompleted 
              ? context.safeGreen
              : isActive 
                  ? phase.color
                  : context.onSurface.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive 
                ? phase.color
                : context.onSurface.withOpacity(0.3),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Center(
          child: isCompleted
              ? Icon(
                  CalderumIcons.checkMark,
                  color: Colors.white,
                  size: 16,
                )
              : Icon(
                  phase.icon,
                  color: isActive 
                      ? Colors.white
                      : context.onSurface.withOpacity(0.5),
                  size: 16,
                ),
        ),
      ),
    );
  }

  Widget _buildPhaseConnector(BuildContext context, bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.symmetric(horizontal: CalderumSpacing.xs),
        decoration: BoxDecoration(
          color: isCompleted 
              ? context.safeGreen
              : context.onSurface.withOpacity(0.2),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildTimeRemaining(BuildContext context) {
    if (widget.phaseTimeRemaining == null) return SizedBox.shrink();
    
    final minutes = widget.phaseTimeRemaining!.inMinutes;
    final seconds = widget.phaseTimeRemaining!.inSeconds % 60;
    final isUrgent = widget.phaseTimeRemaining!.inSeconds <= 30;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: CalderumSpacing.sm,
        vertical: CalderumSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isUrgent 
            ? context.dangerRed.withOpacity(0.1)
            : context.cautionYellow.withOpacity(0.1),
        borderRadius: BorderRadius.circular(CalderumSpacing.sm),
        border: Border.all(
          color: isUrgent 
              ? context.dangerRed.withOpacity(0.3)
              : context.cautionYellow.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CalderumIcons.timer,
            color: isUrgent ? context.dangerRed : context.cautionYellow,
            size: 14,
          ),
          SizedBox(width: CalderumSpacing.xs),
          Text(
            "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
            style: context.textTheme.labelMedium?.copyWith(
              color: isUrgent ? context.dangerRed : context.cautionYellow,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

#### Status Dashboards for Complex Game Information

**Comprehensive Game Dashboard**

```dart
class MagicalGameDashboard extends StatefulWidget {
  final GameState gameState;
  final Player currentPlayer;
  final List<Player> allPlayers;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapsed;

  const MagicalGameDashboard({
    Key? key,
    required this.gameState,
    required this.currentPlayer,
    required this.allPlayers,
    this.isCollapsed = false,
    this.onToggleCollapsed,
  }) : super(key: key);

  @override
  _MagicalGameDashboardState createState() => _MagicalGameDashboardState();
}

class _MagicalGameDashboardState extends State<MagicalGameDashboard>
    with TickerProviderStateMixin {
  
  late TabController _tabController;
  late AnimationController _collapseController;
  late Animation<double> _collapseAnimation;

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
    
    _collapseController = AnimationController(
      duration: CalderumAnimations.normal,
      vsync: this,
    );
    
    _collapseAnimation = CurvedAnimation(
      parent: _collapseController,
      curve: Curves.easeInOut,
    );

    if (!widget.isCollapsed) {
      _collapseController.forward();
    }
  }

  @override
  void didUpdateWidget(MagicalGameDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isCollapsed != oldWidget.isCollapsed) {
      if (widget.isCollapsed) {
        _collapseController.reverse();
      } else {
        _collapseController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(CalderumSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CalderumSpacing.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDashboardHeader(context),
          SizeTransition(
            sizeFactor: _collapseAnimation,
            child: _buildDashboardContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(CalderumSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.magicPurple.withOpacity(0.1),
            context.mysticalGold.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(CalderumSpacing.lg),
          topRight: Radius.circular(CalderumSpacing.lg),
        ),
      ),
      child: Row(
        children: [
          Icon(
            CalderumIcons.dashboard,
            color: context.magicPurple,
          ),
          SizedBox(width: CalderumSpacing.sm),
          Text(
            "Game Overview",
            style: context.textTheme.titleMedium?.copyWith(
              fontFamily: 'Caudex',
              color: context.magicPurple,
            ),
          ),
          Spacer(),
          _buildQuickStats(context),
          SizedBox(width: CalderumSpacing.sm),
          IconButton(
            onPressed: widget.onToggleCollapsed,
            icon: AnimatedRotation(
              turns: widget.isCollapsed ? 0.0 : 0.5,
              duration: CalderumAnimations.fast,
              child: Icon(
                Icons.expand_more,
                color: context.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatChip(
          context,
          "Round",
          "${widget.gameState.currentRound}/9",
          CalderumIcons.rounds,
          context.magicPurple,
        ),
        SizedBox(width: CalderumSpacing.xs),
        _buildStatChip(
          context,
          "Score",
          "${widget.currentPlayer.score}",
          CalderumIcons.trophy,
          context.mysticalGold,
        ),
        SizedBox(width: CalderumSpacing.xs),
        _buildStatChip(
          context,
          "Rubies",
          "${widget.currentPlayer.rubies}",
          CalderumIcons.ruby,
          context.dangerRed,
        ),
      ],
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: CalderumSpacing.sm,
        vertical: CalderumSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(CalderumSpacing.sm),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          SizedBox(width: CalderumSpacing.xs),
          Text(
            value,
            style: context.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: context.magicPurple,
          labelColor: context.magicPurple,
          unselectedLabelColor: context.onSurface.withOpacity(0.6),
          tabs: [
            Tab(icon: Icon(CalderumIcons.players), text: "Players"),
            Tab(icon: Icon(CalderumIcons.ingredients), text: "Ingredients"),
            Tab(icon: Icon(CalderumIcons.achievements), text: "Progress"),
            Tab(icon: Icon(CalderumIcons.history), text: "History"),
          ],
        ),
        
        Container(
          height: 200,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPlayersTab(context),
              _buildIngredientsTab(context),
              _buildProgressTab(context),
              _buildHistoryTab(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersTab(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(CalderumSpacing.md),
      itemCount: widget.allPlayers.length,
      itemBuilder: (context, index) {
        final player = widget.allPlayers[index];
        final isCurrentPlayer = player.id == widget.currentPlayer.id;
        final isActivePlayer = player.id == widget.gameState.activePlayerId;
        
        return Container(
          margin: EdgeInsets.only(bottom: CalderumSpacing.sm),
          padding: EdgeInsets.all(CalderumSpacing.md),
          decoration: BoxDecoration(
            color: isCurrentPlayer 
                ? context.magicPurple.withOpacity(0.1)
                : null,
            borderRadius: BorderRadius.circular(CalderumSpacing.sm),
            border: Border.all(
              color: isActivePlayer
                  ? context.mysticalGold
                  : isCurrentPlayer
                      ? context.magicPurple.withOpacity(0.3)
                      : context.onSurface.withOpacity(0.1),
              width: isActivePlayer ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: player.avatarUrl != null 
                        ? NetworkImage(player.avatarUrl!)
                        : null,
                    backgroundColor: player.color,
                    child: player.avatarUrl == null
                        ? Icon(
                            CalderumIcons.player,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  if (isActivePlayer)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: context.mysticalGold,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          CalderumIcons.wand,
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                    ),
                ],
              ),
              
              SizedBox(width: CalderumSpacing.md),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: isCurrentPlayer 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Score: ${player.score} • Rubies: ${player.rubies}",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              _buildPlayerStatus(context, player),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerStatus(BuildContext context, Player player) {
    if (player.isDisconnected) {
      return Icon(
        CalderumIcons.disconnected,
        color: context.onSurface.withOpacity(0.4),
        size: 16,
      );
    }
    
    if (player.chipSum >= 7) {
      return Icon(
        CalderumIcons.explosion,
        color: context.dangerRed,
        size: 16,
      );
    }
    
    if (player.chipSum >= 5) {
      return Icon(
        CalderumIcons.warning,
        color: context.cautionYellow,
        size: 16,
      );
    }
    
    return Icon(
      CalderumIcons.checkMark,
      color: context.safeGreen,
      size: 16,
    );
  }
}
```

### 4. **Interaction Feedback Systems**

Comprehensive feedback systems provide immediate and clear responses to user actions through multiple sensory channels.

#### Micro-animations for User Actions

**Responsive Button Animation System**

```dart
class MagicalInteractiveButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final MagicalFeedbackType feedbackType;
  final bool enableHaptics;
  final bool enableSoundEffects;

  const MagicalInteractiveButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.style,
    this.feedbackType = MagicalFeedbackType.normal,
    this.enableHaptics = true,
    this.enableSoundEffects = true,
  }) : super(key: key);

  @override
  _MagicalInteractiveButtonState createState() => _MagicalInteractiveButtonState();
}

class _MagicalInteractiveButtonState extends State<MagicalInteractiveButton>
    with TickerProviderStateMixin {
  
  late AnimationController _pressController;
  late AnimationController _hoverController;
  late AnimationController _rippleController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rippleAnimation;
  
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _pressController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
    
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      child: MouseRegion(
        onEnter: _onHover,
        onExit: _onHoverExit,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pressController,
            _hoverController,
            _rippleController,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: _getGlowColor(context).withOpacity(
                        _glowAnimation.value * 0.4
                      ),
                      blurRadius: 12 * _glowAnimation.value,
                      spreadRadius: 4 * _glowAnimation.value,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Base button
                    _buildBaseButton(context),
                    
                    // Ripple effect
                    if (_rippleController.isAnimating)
                      _buildRippleEffect(context),
                    
                    // Particle effects for special buttons
                    if (widget.feedbackType == MagicalFeedbackType.magical)
                      _buildParticleEffect(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBaseButton(BuildContext context) {
    return ElevatedButton(
      onPressed: null, // Handle tap in GestureDetector
      style: widget.style?.copyWith(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: widget.child,
    );
  }

  Widget _buildRippleEffect(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CalderumSpacing.md),
        child: CustomPaint(
          painter: RipplePainter(
            animation: _rippleAnimation,
            color: _getGlowColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildParticleEffect(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: SparkleParticlePainter(
          animation: _glowAnimation,
          color: context.mysticalGold,
        ),
      ),
    );
  }

  Color _getGlowColor(BuildContext context) {
    switch (widget.feedbackType) {
      case MagicalFeedbackType.success:
        return context.safeGreen;
      case MagicalFeedbackType.warning:
        return context.cautionYellow;
      case MagicalFeedbackType.danger:
        return context.dangerRed;
      case MagicalFeedbackType.magical:
        return context.mysticalGold;
      default:
        return context.magicPurple;
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _pressController.forward();
    
    if (widget.enableHaptics) {
      HapticFeedbackService.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _onTap() {
    _rippleController.reset();
    _rippleController.forward();
    
    if (widget.enableHaptics) {
      _triggerHapticFeedback();
    }
    
    if (widget.enableSoundEffects) {
      _playSoundEffect();
    }
    
    widget.onPressed?.call();
  }

  void _onHover(PointerEnterEvent event) {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _onHoverExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  void _triggerHapticFeedback() {
    switch (widget.feedbackType) {
      case MagicalFeedbackType.success:
        HapticFeedbackService.successImpact();
        break;
      case MagicalFeedbackType.warning:
        HapticFeedbackService.warningImpact();
        break;
      case MagicalFeedbackType.danger:
        HapticFeedbackService.errorImpact();
        break;
      case MagicalFeedbackType.magical:
        HapticFeedbackService.magicalImpact();
        break;
      default:
        HapticFeedbackService.selectionClick();
        break;
    }
  }

  void _playSoundEffect() {
    switch (widget.feedbackType) {
      case MagicalFeedbackType.success:
        AudioService.playSuccessSound();
        break;
      case MagicalFeedbackType.warning:
        AudioService.playWarningSound();
        break;
      case MagicalFeedbackType.danger:
        AudioService.playErrorSound();
        break;
      case MagicalFeedbackType.magical:
        AudioService.playMagicalChime();
        break;
      default:
        AudioService.playClickSound();
        break;
    }
  }
}

enum MagicalFeedbackType {
  normal,
  success,
  warning,
  danger,
  magical,
}
```

#### Haptic Feedback Patterns for Game Actions

**Comprehensive Haptic Feedback Service**

```dart
class HapticFeedbackService {
  static bool _isHapticsEnabled = true;
  static double _hapticIntensity = 1.0;
  
  // Basic feedback patterns
  static Future<void> lightImpact() async {
    if (!_isHapticsEnabled) return;
    await HapticFeedback.lightImpact();
  }
  
  static Future<void> mediumImpact() async {
    if (!_isHapticsEnabled) return;
    await HapticFeedback.mediumImpact();
  }
  
  static Future<void> heavyImpact() async {
    if (!_isHapticsEnabled) return;
    await HapticFeedback.heavyImpact();
  }
  
  // Game-specific feedback patterns
  static Future<void> ingredientDrop() async {
    if (!_isHapticsEnabled) return;
    await Future.delayed(Duration.zero);
    await HapticFeedback.lightImpact();
  }
  
  static Future<void> chipSelection() async {
    if (!_isHapticsEnabled) return;
    await HapticFeedback.selectionClick();
  }
  
  static Future<void> cauldronBubble() async {
    if (!_isHapticsEnabled) return;
    // Custom pattern: quick double tap
    await HapticFeedback.lightImpact();
    await Future.delayed(Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }
  
  static Future<void> explosionWarning() async {
    if (!_isHapticsEnabled) return;
    // Custom pattern: warning pulse
    for (int i = 0; i < 3; i++) {
      await HapticFeedback.mediumImpact();
      await Future.delayed(Duration(milliseconds: 100));
    }
  }
  
  static Future<void> explosion() async {
    if (!_isHapticsEnabled) return;
    // Custom pattern: heavy impact with aftershocks
    await HapticFeedback.heavyImpact();
    await Future.delayed(Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
    await Future.delayed(Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }
  
  static Future<void> scoreIncrease() async {
    if (!_isHapticsEnabled) return;
    // Custom pattern: ascending intensity
    await HapticFeedback.lightImpact();
    await Future.delayed(Duration(milliseconds: 80));
    await HapticFeedback.mediumImpact();
  }
  
  static Future<void> magicalEvent() async {
    if (!_isHapticsEnabled) return;
    // Custom pattern: magical shimmer
    for (int i = 0; i < 4; i++) {
      await HapticFeedback.lightImpact();
      await Future.delayed(Duration(milliseconds: 60));
    }
  }
  
  static Future<void> turnTransition() async {
    if (!_isHapticsEnabled) return;
    // Custom pattern: transition pulse
    await HapticFeedback.mediumImpact();
    await Future.delayed(Duration(milliseconds: 200));
    await HapticFeedback.lightImpact();
  }
  
  static Future<void> gameEnd() async {
    if (!_isHapticsEnabled) return;
    // Custom pattern: celebration
    for (int i = 0; i < 5; i++) {
      await HapticFeedback.mediumImpact();
      await Future.delayed(Duration(milliseconds: 120));
    }
    await HapticFeedback.heavyImpact();
  }
  
  // Advanced patterns using platform-specific APIs
  static Future<void> customPattern(List<int> pattern) async {
    if (!_isHapticsEnabled) return;
    
    // For iOS: use Core Haptics patterns
    if (Platform.isIOS) {
      await _executeIOSPattern(pattern);
    } 
    // For Android: use Vibrator patterns
    else if (Platform.isAndroid) {
      await _executeAndroidPattern(pattern);
    }
  }
  
  static Future<void> _executeIOSPattern(List<int> pattern) async {
    // Implementation would use Core Haptics via platform channel
    // This is a simplified version
    for (int i = 0; i < pattern.length; i += 2) {
      final intensity = pattern[i] / 100.0;
      final duration = pattern[i + 1];
      
      if (intensity > 0.7) {
        await HapticFeedback.heavyImpact();
      } else if (intensity > 0.4) {
        await HapticFeedback.mediumImpact();
      } else {
        await HapticFeedback.lightImpact();
      }
      
      if (i + 1 < pattern.length - 1) {
        await Future.delayed(Duration(milliseconds: duration));
      }
    }
  }
  
  static Future<void> _executeAndroidPattern(List<int> pattern) async {
    // Implementation would use Android Vibrator via platform channel
    // This is a simplified version that falls back to basic patterns
    for (int duration in pattern) {
      if (duration > 0) {
        await HapticFeedback.mediumImpact();
      }
      await Future.delayed(Duration(milliseconds: duration));
    }
  }
  
  // Settings management
  static void setHapticsEnabled(bool enabled) {
    _isHapticsEnabled = enabled;
  }
  
  static void setHapticIntensity(double intensity) {
    _hapticIntensity = intensity.clamp(0.0, 1.0);
  }
  
  static bool get isHapticsEnabled => _isHapticsEnabled;
  static double get hapticIntensity => _hapticIntensity;
  
  // Contextual feedback based on game state
  static Future<void> contextualFeedback(GameContext context) async {
    switch (context.action) {
      case GameAction.ingredientSelect:
        await chipSelection();
        break;
      case GameAction.ingredientDrop:
        await ingredientDrop();
        break;
      case GameAction.nearExplosion:
        await explosionWarning();
        break;
      case GameAction.explosion:
        await explosion();
        break;
      case GameAction.scoreGain:
        await scoreIncrease();
        break;
      case GameAction.magicalEffect:
        await magicalEvent();
        break;
      case GameAction.turnStart:
        await turnTransition();
        break;
      case GameAction.gameComplete:
        await gameEnd();
        break;
      default:
        await lightImpact();
        break;
    }
  }
}

// Supporting classes for haptic patterns
class GameContext {
  final GameAction action;
  final int intensity;
  final Map<String, dynamic> metadata;
  
  const GameContext({
    required this.action,
    this.intensity = 50,
    this.metadata = const {},
  });
}

enum GameAction {
  ingredientSelect,
  ingredientDrop,
  nearExplosion,
  explosion,
  scoreGain,
  magicalEffect,
  turnStart,
  gameComplete,
}
```

### 5. **User Assistance and Recovery**

Comprehensive help systems and recovery mechanisms ensure users can always find their way and recover from mistakes.

#### Contextual Help Systems with Search

**Intelligent Help Assistant**

```dart
class MagicalHelpAssistant extends StatefulWidget {
  final GameState? gameState;
  final String? currentScreen;
  final Function(HelpAction)? onHelpAction;

  const MagicalHelpAssistant({
    Key? key,
    this.gameState,
    this.currentScreen,
    this.onHelpAction,
  }) : super(key: key);

  @override
  _MagicalHelpAssistantState createState() => _MagicalHelpAssistantState();
}

class _MagicalHelpAssistantState extends State<MagicalHelpAssistant>
    with TickerProviderStateMixin {
  
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  late AnimationController _fabController;
  late AnimationController _expandController;
  late Animation<double> _fabAnimation;
  late Animation<double> _expandAnimation;
  
  bool _isExpanded = false;
  List<HelpTopic> _searchResults = [];
  List<HelpTopic> _contextualHelp = [];
  HelpTopic? _selectedTopic;

  @override
  void initState() {
    super.initState();
    
    _fabController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _expandController = AnimationController(
      duration: CalderumAnimations.normal,
      vsync: this,
    );
    
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeOut,
    ));
    
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    _fabController.forward();
    _loadContextualHelp();
    
    _searchController.addListener(_onSearchChanged);
  }

  void _loadContextualHelp() {
    _contextualHelp = HelpContentProvider.getContextualHelp(
      gameState: widget.gameState,
      currentScreen: widget.currentScreen,
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = _contextualHelp;
      });
    } else {
      setState(() {
        _searchResults = HelpContentProvider.searchHelp(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop when expanded
        if (_isExpanded)
          GestureDetector(
            onTap: _collapseHelp,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        
        // Help FAB
        Positioned(
          bottom: 80,
          right: CalderumSpacing.lg,
          child: _buildHelpFAB(context),
        ),
        
        // Expanded help panel
        if (_isExpanded)
          Positioned(
            bottom: 140,
            right: CalderumSpacing.lg,
            child: _buildHelpPanel(context),
          ),
      ],
    );
  }

  Widget _buildHelpFAB(BuildContext context) {
    return ScaleTransition(
      scale: _fabAnimation,
      child: FloatingActionButton(
        onPressed: _toggleHelp,
        backgroundColor: context.mysticalGold,
        child: AnimatedSwitcher(
          duration: CalderumAnimations.fast,
          child: _isExpanded
              ? Icon(
                  Icons.close,
                  color: Colors.white,
                  key: ValueKey('close'),
                )
              : Icon(
                  CalderumIcons.help,
                  color: Colors.white,
                  key: ValueKey('help'),
                ),
        ),
      ),
    );
  }

  Widget _buildHelpPanel(BuildContext context) {
    return ScaleTransition(
      scale: _expandAnimation,
      child: Container(
        width: 320,
        height: 480,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(CalderumSpacing.lg),
          border: Border.all(
            color: context.mysticalGold.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHelpHeader(context),
            _buildSearchBar(context),
            Expanded(
              child: _selectedTopic != null
                  ? _buildTopicDetail(context)
                  : _buildTopicList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(CalderumSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.mysticalGold.withOpacity(0.1),
            context.magicPurple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(CalderumSpacing.lg),
          topRight: Radius.circular(CalderumSpacing.lg),
        ),
      ),
      child: Row(
        children: [
          Icon(
            CalderumIcons.spellbook,
            color: context.mysticalGold,
          ),
          SizedBox(width: CalderumSpacing.sm),
          Expanded(
            child: Text(
              _selectedTopic?.title ?? "Magical Assistant",
              style: context.textTheme.titleMedium?.copyWith(
                fontFamily: 'Caudex',
                color: context.mysticalGold,
              ),
            ),
          ),
          if (_selectedTopic != null)
            IconButton(
              onPressed: () => setState(() => _selectedTopic = null),
              icon: Icon(
                Icons.arrow_back,
                color: context.onSurface.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    if (_selectedTopic != null) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.all(CalderumSpacing.md),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: "Search for help...",
          prefixIcon: Icon(CalderumIcons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  },
                  icon: Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CalderumSpacing.md),
            borderSide: BorderSide(
              color: context.onSurface.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CalderumSpacing.md),
            borderSide: BorderSide(
              color: context.mysticalGold,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicList(BuildContext context) {
    final topics = _searchController.text.isEmpty 
        ? _contextualHelp 
        : _searchResults;
    
    if (topics.isEmpty) {
      return _buildEmptyState(context);
    }
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: CalderumSpacing.md),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        return _buildTopicItem(context, topic);
      },
    );
  }

  Widget _buildTopicItem(BuildContext context, HelpTopic topic) {
    return Card(
      margin: EdgeInsets.only(bottom: CalderumSpacing.sm),
      child: InkWell(
        onTap: () => _selectTopic(topic),
        borderRadius: BorderRadius.circular(CalderumSpacing.sm),
        child: Padding(
          padding: EdgeInsets.all(CalderumSpacing.md),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(CalderumSpacing.sm),
                decoration: BoxDecoration(
                  color: topic.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(CalderumSpacing.sm),
                ),
                child: Icon(
                  topic.icon,
                  color: topic.category.color,
                  size: 18,
                ),
              ),
              
              SizedBox(width: CalderumSpacing.md),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontFamily: 'Caudex',
                      ),
                    ),
                    if (topic.description.isNotEmpty)
                      Text(
                        topic.description,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              
              Icon(
                Icons.chevron_right,
                color: context.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicDetail(BuildContext context) {
    if (_selectedTopic == null) return SizedBox.shrink();
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(CalderumSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedTopic!.description.isNotEmpty) ...[
            Text(
              _selectedTopic!.description,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.onSurface.withOpacity(0.8),
              ),
            ),
            SizedBox(height: CalderumSpacing.lg),
          ],
          
          ..._selectedTopic!.content.map((section) => 
            _buildContentSection(context, section)
          ),
          
          if (_selectedTopic!.relatedActions.isNotEmpty) ...[
            SizedBox(height: CalderumSpacing.lg),
            _buildQuickActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, HelpContentSection section) {
    return Padding(
      padding: EdgeInsets.only(bottom: CalderumSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title.isNotEmpty) ...[
            Text(
              section.title,
              style: context.textTheme.titleSmall?.copyWith(
                color: context.magicPurple,
                fontFamily: 'Caudex',
              ),
            ),
            SizedBox(height: CalderumSpacing.sm),
          ],
          
          Text(
            section.content,
            style: context.textTheme.bodyMedium,
          ),
          
          if (section.image != null) ...[
            SizedBox(height: CalderumSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(CalderumSpacing.sm),
              child: Image.asset(
                section.image!,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: context.textTheme.titleSmall?.copyWith(
            color: context.magicPurple,
            fontFamily: 'Caudex',
          ),
        ),
        SizedBox(height: CalderumSpacing.sm),
        
        ..._selectedTopic!.relatedActions.map((action) =>
          Padding(
            padding: EdgeInsets.only(bottom: CalderumSpacing.xs),
            child: TextButton.icon(
              onPressed: () => _executeHelpAction(action),
              icon: Icon(action.icon, size: 16),
              label: Text(action.label),
              style: TextButton.styleFrom(
                foregroundColor: context.mysticalGold,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(CalderumSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CalderumIcons.emptyScroll,
              color: context.onSurface.withOpacity(0.4),
              size: 48,
            ),
            SizedBox(height: CalderumSpacing.md),
            Text(
              "No help topics found",
              style: context.textTheme.titleMedium?.copyWith(
                color: context.onSurface.withOpacity(0.6),
              ),
            ),
            Text(
              "Try adjusting your search terms",
              style: context.textTheme.bodySmall?.copyWith(
                color: context.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleHelp() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
        _loadContextualHelp();
      } else {
        _expandController.reverse();
        _selectedTopic = null;
        _searchController.clear();
      }
    });
  }

  void _collapseHelp() {
    setState(() {
      _isExpanded = false;
      _expandController.reverse();
      _selectedTopic = null;
    });
  }

  void _selectTopic(HelpTopic topic) {
    setState(() {
      _selectedTopic = topic;
    });
  }

  void _executeHelpAction(HelpAction action) {
    _collapseHelp();
    widget.onHelpAction?.call(action);
  }
}

// Supporting classes for help system
class HelpTopic {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final HelpCategory category;
  final List<HelpContentSection> content;
  final List<HelpAction> relatedActions;
  final List<String> searchKeywords;

  const HelpTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.content,
    this.relatedActions = const [],
    this.searchKeywords = const [],
  });
}

class HelpContentSection {
  final String title;
  final String content;
  final String? image;
  final List<String> bulletPoints;

  const HelpContentSection({
    required this.title,
    required this.content,
    this.image,
    this.bulletPoints = const [],
  });
}

class HelpAction {
  final String id;
  final String label;
  final IconData icon;
  final VoidCallback action;

  const HelpAction({
    required this.id,
    required this.label,
    required this.icon,
    required this.action,
  });
}

enum HelpCategory {
  gameRules,
  interface,
  strategy,
  troubleshooting,
}

extension HelpCategoryExtension on HelpCategory {
  Color get color {
    switch (this) {
      case HelpCategory.gameRules:
        return CalderumColors.magicPurple;
      case HelpCategory.interface:
        return CalderumColors.mysticalGold;
      case HelpCategory.strategy:
        return CalderumColors.safeGreen;
      case HelpCategory.troubleshooting:
        return CalderumColors.dangerRed;
    }
  }
}
```

### 6. **Social and Multiplayer UX**

Comprehensive multiplayer interaction patterns that handle the complex social dynamics of online gaming.

#### Turn Indication and Waiting State Management

**Dynamic Turn Management System**

```dart
class MagicalTurnIndicator extends StatefulWidget {
  final GameState gameState;
  final List<Player> players;
  final Player currentPlayer;
  final Duration? turnTimeRemaining;
  final Function(Player)? onPlayerTapped;

  const MagicalTurnIndicator({
    Key? key,
    required this.gameState,
    required this.players,
    required this.currentPlayer,
    this.turnTimeRemaining,
    this.onPlayerTapped,
  }) : super(key: key);

  @override
  _MagicalTurnIndicatorState createState() => _MagicalTurnIndicatorState();
}

class _MagicalTurnIndicatorState extends State<MagicalTurnIndicator>
    with TickerProviderStateMixin {
  
  late AnimationController _pulseController;
  late AnimationController _timerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _timerAnimation;
  Timer? _turnTimer;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _timerController = AnimationController(
      duration: widget.turnTimeRemaining ?? Duration(seconds: 30),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _timerAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _timerController,
      curve: Curves.linear,
    ));

    if (widget.turnTimeRemaining != null) {
      _timerController.forward();
      _startTurnTimer();
    }
  }

  void _startTurnTimer() {
    _turnTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Timer updates would come from parent widget
      if (widget.turnTimeRemaining != null &&
          widget.turnTimeRemaining!.inSeconds <= 10) {
        // Add urgency animations
        _pulseController.duration = Duration(milliseconds: 800);
      }
    });
  }

  @override
  void didUpdateWidget(MagicalTurnIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.gameState.activePlayerId != oldWidget.gameState.activePlayerId) {
      _resetAnimations();
    }
  }

  void _resetAnimations() {
    _timerController.reset();
    if (widget.turnTimeRemaining != null) {
      _timerController.duration = widget.turnTimeRemaining!;
      _timerController.forward();
    }
    
    _pulseController.duration = Duration(milliseconds: 1500);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(CalderumSpacing.md),
      child: Column(
        children: [
          _buildTurnHeader(context),
          SizedBox(height: CalderumSpacing.md),
          _buildPlayerIndicators(context),
          if (widget.turnTimeRemaining != null) ...[
            SizedBox(height: CalderumSpacing.md),
            _buildTurnTimer(context),
          ],
        ],
      ),
    );
  }

  Widget _buildTurnHeader(BuildContext context) {
    final activePlayer = widget.players.firstWhere(
      (p) => p.id == widget.gameState.activePlayerId,
      orElse: () => widget.currentPlayer,
    );
    
    final isCurrentPlayerTurn = activePlayer.id == widget.currentPlayer.id;
    
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isCurrentPlayerTurn ? _pulseAnimation.value : 1.0,
              child: Container(
                padding: EdgeInsets.all(CalderumSpacing.sm),
                decoration: BoxDecoration(
                  color: isCurrentPlayerTurn 
                      ? context.mysticalGold.withOpacity(0.2)
                      : context.magicPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(CalderumSpacing.lg),
                  border: Border.all(
                    color: isCurrentPlayerTurn 
                        ? context.mysticalGold
                        : context.magicPurple,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isCurrentPlayerTurn 
                      ? CalderumIcons.wand
                      : CalderumIcons.hourglass,
                  color: isCurrentPlayerTurn 
                      ? context.mysticalGold
                      : context.magicPurple,
                ),
              ),
            );
          },
        ),
        
        SizedBox(width: CalderumSpacing.md),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCurrentPlayerTurn ? "Your Turn!" : "${activePlayer.name}'s Turn",
                style: context.textTheme.titleMedium?.copyWith(
                  fontFamily: 'Caudex',
                  color: isCurrentPlayerTurn 
                      ? context.mysticalGold
                      : context.magicPurple,
                ),
              ),
              Text(
                isCurrentPlayerTurn 
                    ? "Brew your magical potion"
                    : "Waiting for ${activePlayer.name}",
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        
        if (!isCurrentPlayerTurn)
          _buildWaitingIndicator(context),
      ],
    );
  }

  Widget _buildWaitingIndicator(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          context.magicPurple.withOpacity(0.6)
        ),
        backgroundColor: context.onSurface.withOpacity(0.1),
      ),
    );
  }

  Widget _buildPlayerIndicators(BuildContext context) {
    return Wrap(
      spacing: CalderumSpacing.sm,
      runSpacing: CalderumSpacing.sm,
      children: widget.players.map((player) => 
        _buildPlayerIndicator(context, player)
      ).toList(),
    );
  }

  Widget _buildPlayerIndicator(BuildContext context, Player player) {
    final isActive = player.id == widget.gameState.activePlayerId;
    final isCurrentPlayer = player.id == widget.currentPlayer.id;
    final hasCompleted = widget.gameState.hasPlayerCompleted(player.id);
    
    return GestureDetector(
      onTap: () => widget.onPlayerTapped?.call(player),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isActive ? _pulseAnimation.value * 0.95 + 0.05 : 1.0,
            child: Container(
              padding: EdgeInsets.all(CalderumSpacing.sm),
              decoration: BoxDecoration(
                color: _getPlayerIndicatorColor(
                  context, player, isActive, isCurrentPlayer, hasCompleted
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(CalderumSpacing.md),
                border: Border.all(
                  color: _getPlayerIndicatorColor(
                    context, player, isActive, isCurrentPlayer, hasCompleted
                  ),
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: player.avatarUrl != null 
                            ? NetworkImage(player.avatarUrl!)
                            : null,
                        backgroundColor: player.color,
                        child: player.avatarUrl == null
                            ? Icon(
                                CalderumIcons.player,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                      
                      // Status indicators
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              context, player, isActive, hasCompleted
                            ),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: context.surface,
                              width: 1,
                            ),
                          ),
                          child: _getStatusIcon(
                            context, player, isActive, hasCompleted
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(width: CalderumSpacing.sm),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        player.name,
                        style: context.textTheme.labelMedium?.copyWith(
                          fontWeight: isCurrentPlayer 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                          color: isCurrentPlayer
                              ? context.mysticalGold
                              : context.onSurface,
                        ),
                      ),
                      Text(
                        _getPlayerStatusText(
                          player, isActive, hasCompleted
                        ),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTurnTimer(BuildContext context) {
    if (widget.turnTimeRemaining == null) return SizedBox.shrink();
    
    final remainingSeconds = widget.turnTimeRemaining!.inSeconds;
    final isUrgent = remainingSeconds <= 10;
    
    return Container(
      padding: EdgeInsets.all(CalderumSpacing.md),
      decoration: BoxDecoration(
        color: isUrgent 
            ? context.dangerRed.withOpacity(0.1)
            : context.mysticalGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(CalderumSpacing.md),
        border: Border.all(
          color: isUrgent 
              ? context.dangerRed.withOpacity(0.3)
              : context.mysticalGold.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                CalderumIcons.timer,
                color: isUrgent ? context.dangerRed : context.mysticalGold,
              ),
              SizedBox(width: CalderumSpacing.sm),
              Expanded(
                child: Text(
                  isUrgent ? "Time Running Out!" : "Turn Timer",
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isUrgent ? context.dangerRed : context.mysticalGold,
                    fontFamily: 'Caudex',
                  ),
                ),
              ),
              Text(
                "${remainingSeconds}s",
                style: context.textTheme.titleMedium?.copyWith(
                  color: isUrgent ? context.dangerRed : context.mysticalGold,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
              ),
            ],
          ),
          
          SizedBox(height: CalderumSpacing.sm),
          
          AnimatedBuilder(
            animation: _timerAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _timerAnimation.value,
                backgroundColor: context.onSurface.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isUrgent ? context.dangerRed : context.mysticalGold
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getPlayerIndicatorColor(
    BuildContext context,
    Player player,
    bool isActive,
    bool isCurrentPlayer,
    bool hasCompleted,
  ) {
    if (hasCompleted) return context.safeGreen;
    if (isActive) return context.mysticalGold;
    if (isCurrentPlayer) return context.magicPurple;
    return context.onSurface.withOpacity(0.3);
  }

  Color _getStatusColor(
    BuildContext context,
    Player player,
    bool isActive,
    bool hasCompleted,
  ) {
    if (player.isDisconnected) return context.onSurface.withOpacity(0.4);
    if (hasCompleted) return context.safeGreen;
    if (isActive) return context.mysticalGold;
    return context.magicPurple;
  }

  Widget? _getStatusIcon(
    BuildContext context,
    Player player,
    bool isActive,
    bool hasCompleted,
  ) {
    if (player.isDisconnected) {
      return Icon(
        CalderumIcons.disconnected,
        color: Colors.white,
        size: 6,
      );
    }
    if (hasCompleted) {
      return Icon(
        CalderumIcons.checkMark,
        color: Colors.white,
        size: 6,
      );
    }
    if (isActive) {
      return Icon(
        CalderumIcons.wand,
        color: Colors.white,
        size: 6,
      );
    }
    return null;
  }

  String _getPlayerStatusText(
    Player player,
    bool isActive,
    bool hasCompleted,
  ) {
    if (player.isDisconnected) return "Disconnected";
    if (hasCompleted) return "Completed";
    if (isActive) return "Playing...";
    return "Waiting";
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timerController.dispose();
    _turnTimer?.cancel();
    super.dispose();
  }
}
```

This comprehensive UX enhancement system provides:

1. **Progressive Disclosure** - Multi-step wizards, contextual tooltips, and expandable panels
2. **Game Mechanic Guidance** - Interactive tutorials, visual hints, and risk/reward analysis
3. **Complex State Management** - Phase indicators, status dashboards, and timeline views
4. **Interaction Feedback** - Micro-animations, haptic patterns, and audio integration
5. **User Assistance** - Contextual help system with search and recovery options
6. **Social/Multiplayer UX** - Turn management, player status, and waiting state handling

---

# Implementation Guidelines and Technical Considerations

## 1. Flutter Implementation Framework

### 1.1 Widget Library Structure and Organization

```dart
// Core library structure
lib/
├── design_system/
│   ├── tokens/                    # Design tokens
│   │   ├── colors.dart
│   │   ├── typography.dart
│   │   ├── spacing.dart
│   │   └── animations.dart
│   ├── components/                # Reusable components
│   │   ├── atoms/                 # Basic building blocks
│   │   ├── molecules/             # Component combinations
│   │   └── organisms/             # Complex components
│   ├── themes/                    # Theme definitions
│   │   ├── calderum_theme.dart
│   │   └── theme_extensions.dart
│   └── utils/                     # Helper utilities
│       ├── responsive.dart
│       └── accessibility.dart
└── features/                      # Feature implementations
    ├── account/
    ├── home/
    └── room/
```

### 1.2 Custom Theme Extension Implementation Patterns

```dart
// calderum_theme.dart - Comprehensive theme system
class CalderumTheme {
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    colorScheme: _darkColorScheme,
    textTheme: _textTheme,
    extensions: [
      CalderumColors.dark,
      CalderumTypography.standard,
      CalderumSpacing.standard,
      CalderumAnimations.standard,
    ],
  );

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: Color(0xFF6B4E96),
    secondary: Color(0xFFD4AF37),
    surface: Color(0xFF16213E),
    background: Color(0xFF1A1A2E),
    error: Color(0xFFF44336),
    onPrimary: Colors.white,
    onSecondary: Color(0xFF1A1A2E),
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
  );

  static TextTheme get _textTheme => TextTheme(
    displayLarge: GoogleFonts.caudex(
      fontSize: 48, 
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    headlineLarge: GoogleFonts.caudex(
      fontSize: 32, 
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: GoogleFonts.caudex(
      fontSize: 16, 
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    labelLarge: GoogleFonts.caveat(
      fontSize: 20, 
      fontWeight: FontWeight.w500,
    ),
  );
}

// Theme extensions for type-safe access
@immutable
class CalderumColors extends ThemeExtension<CalderumColors> {
  const CalderumColors({
    required this.magicPurple,
    required this.mysticalGold,
    required this.darkSurface,
    required this.darkBackground,
    required this.safeGreen,
    required this.dangerRed,
    required this.infoBlue,
    required this.warningAmber,
    required this.gradientPrimary,
    required this.gradientSecondary,
  });

  final Color magicPurple;
  final Color mysticalGold;
  final Color darkSurface;
  final Color darkBackground;
  final Color safeGreen;
  final Color dangerRed;
  final Color infoBlue;
  final Color warningAmber;
  final List<Color> gradientPrimary;
  final List<Color> gradientSecondary;

  static const CalderumColors dark = CalderumColors(
    magicPurple: Color(0xFF6B4E96),
    mysticalGold: Color(0xFFD4AF37),
    darkSurface: Color(0xFF16213E),
    darkBackground: Color(0xFF1A1A2E),
    safeGreen: Color(0xFF4CAF50),
    dangerRed: Color(0xFFF44336),
    infoBlue: Color(0xFF2196F3),
    warningAmber: Color(0xFFFF9800),
    gradientPrimary: [Color(0xFF6B4E96), Color(0xFFD4AF37)],
    gradientSecondary: [Color(0xFF1A1A2E), Color(0xFF6B4E96)],
  );

  @override
  CalderumColors copyWith({
    Color? magicPurple,
    Color? mysticalGold,
    Color? darkSurface,
    Color? darkBackground,
    Color? safeGreen,
    Color? dangerRed,
    Color? infoBlue,
    Color? warningAmber,
    List<Color>? gradientPrimary,
    List<Color>? gradientSecondary,
  }) {
    return CalderumColors(
      magicPurple: magicPurple ?? this.magicPurple,
      mysticalGold: mysticalGold ?? this.mysticalGold,
      darkSurface: darkSurface ?? this.darkSurface,
      darkBackground: darkBackground ?? this.darkBackground,
      safeGreen: safeGreen ?? this.safeGreen,
      dangerRed: dangerRed ?? this.dangerRed,
      infoBlue: infoBlue ?? this.infoBlue,
      warningAmber: warningAmber ?? this.warningAmber,
      gradientPrimary: gradientPrimary ?? this.gradientPrimary,
      gradientSecondary: gradientSecondary ?? this.gradientSecondary,
    );
  }

  @override
  CalderumColors lerp(ThemeExtension<CalderumColors>? other, double t) {
    if (other is! CalderumColors) return this;
    return CalderumColors(
      magicPurple: Color.lerp(magicPurple, other.magicPurple, t)!,
      mysticalGold: Color.lerp(mysticalGold, other.mysticalGold, t)!,
      darkSurface: Color.lerp(darkSurface, other.darkSurface, t)!,
      darkBackground: Color.lerp(darkBackground, other.darkBackground, t)!,
      safeGreen: Color.lerp(safeGreen, other.safeGreen, t)!,
      dangerRed: Color.lerp(dangerRed, other.dangerRed, t)!,
      infoBlue: Color.lerp(infoBlue, other.infoBlue, t)!,
      warningAmber: Color.lerp(warningAmber, other.warningAmber, t)!,
      gradientPrimary: gradientPrimary,
      gradientSecondary: gradientSecondary,
    );
  }
}

// Convenient extensions for context access
extension CalderumThemeExtensions on BuildContext {
  CalderumColors get colors => Theme.of(this).extension<CalderumColors>()!;
  CalderumTypography get typography => Theme.of(this).extension<CalderumTypography>()!;
  CalderumSpacing get spacing => Theme.of(this).extension<CalderumSpacing>()!;
  CalderumAnimations get animations => Theme.of(this).extension<CalderumAnimations>()!;
}
```

### 1.3 State Management Integration with Riverpod

```dart
// Theme provider with persistence
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedTheme = prefs.getString('theme_mode');
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == savedTheme,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString('theme_mode', mode.name);
    state = mode;
  }
}

// Responsive breakpoint provider
@riverpod
class ResponsiveBreakpoint extends _$ResponsiveBreakpoint {
  @override
  ScreenSize build() {
    final mediaQuery = ref.watch(mediaQueryProvider);
    final width = mediaQuery.size.width;
    
    if (width < 600) return ScreenSize.mobile;
    if (width < 905) return ScreenSize.tablet;
    if (width < 1240) return ScreenSize.desktop;
    return ScreenSize.large;
  }
}

// Animation preference provider
@riverpod
class AnimationPreferences extends _$AnimationPreferences {
  @override
  AnimationSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final mediaQuery = ref.watch(mediaQueryProvider);
    
    return AnimationSettings(
      reduceMotion: prefs.getBool('reduce_motion') ?? 
                   mediaQuery.disableAnimations,
      particleEffects: prefs.getBool('particle_effects') ?? true,
      hapticFeedback: prefs.getBool('haptic_feedback') ?? true,
    );
  }

  Future<void> updateSettings(AnimationSettings settings) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await Future.wait([
      prefs.setBool('reduce_motion', settings.reduceMotion),
      prefs.setBool('particle_effects', settings.particleEffects),
      prefs.setBool('haptic_feedback', settings.hapticFeedback),
    ]);
    state = settings;
  }
}
```

### 1.4 Performance Optimization Techniques

```dart
// Optimized component base class
abstract class CalderumComponent extends StatelessWidget {
  const CalderumComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: buildComponent(context),
    );
  }

  Widget buildComponent(BuildContext context);
}

// Efficient animation controller management
mixin AnimationControllerMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  final Map<String, AnimationController> _controllers = {};
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick);
  }

  AnimationController getController(
    String key, {
    required Duration duration,
    Duration? reverseDuration,
    double? value,
  }) {
    return _controllers.putIfAbsent(
      key,
      () => AnimationController(
        duration: duration,
        reverseDuration: reverseDuration,
        value: value,
        vsync: this,
      ),
    );
  }

  void _onTick(Duration elapsed) {
    // Centralized animation tick handling
    for (final controller in _controllers.values) {
      if (controller.isAnimating) {
        controller.notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  @override
  Ticker createTicker(TickerCallback onTick) => _ticker;
}

// Memory-efficient image handling
class OptimizedNetworkImage extends StatelessWidget {
  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: width?.round(),
      memCacheHeight: height?.round(),
      maxWidthDiskCache: 1024,
      maxHeightDiskCache: 1024,
      placeholder: (context, url) => const ShimmerPlaceholder(),
      errorWidget: (context, url, error) => const ErrorImagePlaceholder(),
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
    );
  }
}
```

### 1.5 Code Organization and Naming Conventions

```dart
// File naming conventions
/*
lib/
├── design_system/
│   ├── components/
│   │   ├── calderum_button.dart         # CalderumButton
│   │   ├── ingredient_chip.dart         # IngredientChip
│   │   └── potion_brewing_panel.dart    # PotionBrewingPanel
│   ├── animations/
│   │   ├── fade_slide_transition.dart   # FadeSlideTransition
│   │   └── particle_explosion.dart      # ParticleExplosion
│   └── utils/
│       ├── responsive_helper.dart       # ResponsiveHelper
│       └── accessibility_helper.dart    # AccessibilityHelper
*/

// Class naming patterns
abstract class CalderumWidget extends StatelessWidget {
  // Base class for all Calderum components
}

class CalderumButton extends CalderumWidget {
  // Specific button implementation
}

class IngredientChip extends CalderumWidget {
  // Game-specific component
}

// Mixin naming patterns
mixin CalderumAnimationMixin<T extends StatefulWidget> on State<T> {
  // Animation-related functionality
}

mixin ResponsiveMixin<T extends StatefulWidget> on State<T> {
  // Responsive behavior
}

// Provider naming patterns
@riverpod
class GameStateNotifier extends _$GameStateNotifier {
  // Game state management
}

@riverpod
Future<List<Room>> availableRooms(AvailableRoomsRef ref) async {
  // Async data provider
}

// Constants naming
class CalderumConstants {
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double borderRadius = 12.0;
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
}

class GameConstants {
  static const int maxPlayers = 4;
  static const int totalTurns = 9;
  static const double explosionThreshold = 7.0;
}
```

## 2. Design Token Implementation

### 2.1 Token File Structure and Code Generation

```dart
// tokens/base_tokens.dart - Foundation tokens
class BaseTokens {
  // Color primitives
  static const Color purple50 = Color(0xFFF3F0FF);
  static const Color purple100 = Color(0xFFE9E2FF);
  static const Color purple500 = Color(0xFF6B4E96);
  static const Color purple900 = Color(0xFF2D1B45);

  static const Color gold50 = Color(0xFFFFFBE6);
  static const Color gold100 = Color(0xFFFFF4CC);
  static const Color gold500 = Color(0xFFD4AF37);
  static const Color gold900 = Color(0xFF8A7419);

  // Typography scale
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;
  static const double fontSize32 = 32.0;
  static const double fontSize48 = 48.0;

  // Spacing scale (4px base)
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // Border radius scale
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius24 = 24.0;
  static const double radiusFull = 9999.0;

  // Animation durations
  static const Duration duration100 = Duration(milliseconds: 100);
  static const Duration duration200 = Duration(milliseconds: 200);
  static const Duration duration300 = Duration(milliseconds: 300);
  static const Duration duration500 = Duration(milliseconds: 500);
  static const Duration duration800 = Duration(milliseconds: 800);
  static const Duration duration1200 = Duration(milliseconds: 1200);
}

// tokens/semantic_tokens.dart - Semantic meaning tokens
class SemanticTokens {
  // Color intentions
  static const Color colorPrimary = BaseTokens.purple500;
  static const Color colorSecondary = BaseTokens.gold500;
  static const Color colorSuccess = Color(0xFF4CAF50);
  static const Color colorWarning = Color(0xFFFF9800);
  static const Color colorError = Color(0xFFF44336);
  static const Color colorInfo = Color(0xFF2196F3);

  // Surface colors
  static const Color surfacePrimary = Color(0xFF1A1A2E);
  static const Color surfaceSecondary = Color(0xFF16213E);
  static const Color surfaceTertiary = Color(0xFF0F172A);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Color(0xFF1A1A2E);

  // Component-specific tokens
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: BaseTokens.space20,
    vertical: BaseTokens.space12,
  );

  static const double cardRadius = BaseTokens.radius12;
  static const EdgeInsets cardPadding = EdgeInsets.all(BaseTokens.space16);
  static const double cardElevation = 4.0;

  // Game-specific tokens
  static const double chipSize = 32.0;
  static const double chipSizeSmall = 24.0;
  static const double chipSizeLarge = 40.0;
  static const double cauldronSizeSmall = 280.0;
  static const double cauldronSizeMedium = 340.0;
  static const double cauldronSizeLarge = 400.0;
}
```

### 2.2 Type-Safe Token Access Patterns

```dart
// Token provider system
@riverpod
class DesignTokens extends _$DesignTokens {
  @override
  TokenSet build() {
    final screenSize = ref.watch(responsiveBreakpointProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    
    return TokenSet(
      colors: _getColorTokens(themeMode),
      typography: _getTypographyTokens(screenSize),
      spacing: _getSpacingTokens(screenSize),
      animations: _getAnimationTokens(),
    );
  }

  ColorTokens _getColorTokens(ThemeMode themeMode) {
    // Return appropriate color tokens based on theme
    return const ColorTokens.dark();
  }

  TypographyTokens _getTypographyTokens(ScreenSize screenSize) {
    // Return scaled typography based on screen size
    return TypographyTokens.forScreen(screenSize);
  }

  SpacingTokens _getSpacingTokens(ScreenSize screenSize) {
    // Return responsive spacing tokens
    return SpacingTokens.forScreen(screenSize);
  }

  AnimationTokens _getAnimationTokens() {
    final animationPrefs = ref.watch(animationPreferencesProvider);
    return AnimationTokens(
      reduceMotion: animationPrefs.reduceMotion,
    );
  }
}

// Type-safe token classes
@freezed
class ColorTokens with _$ColorTokens {
  const factory ColorTokens({
    required Color primary,
    required Color secondary,
    required Color surface,
    required Color background,
    required Color error,
    required Color success,
    required Color warning,
    required Color info,
    required Color textPrimary,
    required Color textSecondary,
    required Color textTertiary,
  }) = _ColorTokens;

  const factory ColorTokens.dark() = ColorTokens(
    primary: SemanticTokens.colorPrimary,
    secondary: SemanticTokens.colorSecondary,
    surface: SemanticTokens.surfaceSecondary,
    background: SemanticTokens.surfacePrimary,
    error: SemanticTokens.colorError,
    success: SemanticTokens.colorSuccess,
    warning: SemanticTokens.colorWarning,
    info: SemanticTokens.colorInfo,
    textPrimary: SemanticTokens.textPrimary,
    textSecondary: SemanticTokens.textSecondary,
    textTertiary: SemanticTokens.textTertiary,
  );
}

@freezed
class TypographyTokens with _$TypographyTokens {
  const factory TypographyTokens({
    required TextStyle displayLarge,
    required TextStyle headlineLarge,
    required TextStyle headlineMedium,
    required TextStyle titleLarge,
    required TextStyle titleMedium,
    required TextStyle bodyLarge,
    required TextStyle bodyMedium,
    required TextStyle labelLarge,
    required TextStyle labelMedium,
    required TextStyle labelSmall,
  }) = _TypographyTokens;

  factory TypographyTokens.forScreen(ScreenSize screenSize) {
    final scale = screenSize.typographyScale;
    return TypographyTokens(
      displayLarge: GoogleFonts.caudex(
        fontSize: 48.0 * scale,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      headlineLarge: GoogleFonts.caudex(
        fontSize: 32.0 * scale,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.caudex(
        fontSize: 16.0 * scale,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
      // ... additional styles
    );
  }
}

// Extension for easy access
extension ScreenSizeExtensions on ScreenSize {
  double get typographyScale {
    switch (this) {
      case ScreenSize.mobile:
        return 0.9;
      case ScreenSize.tablet:
        return 1.0;
      case ScreenSize.desktop:
        return 1.1;
      case ScreenSize.large:
        return 1.2;
    }
  }

  double get spacingScale {
    switch (this) {
      case ScreenSize.mobile:
        return 0.8;
      case ScreenSize.tablet:
        return 1.0;
      case ScreenSize.desktop:
        return 1.2;
      case ScreenSize.large:
        return 1.4;
    }
  }
}
```

### 2.3 Theme Switching Implementation

```dart
// Theme switching with smooth transitions
class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      data: _getThemeData(themeMode),
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Calderum',
            theme: CalderumTheme.lightTheme,
            darkTheme: CalderumTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: ref.watch(routerProvider),
          );
        },
      ),
    );
  }

  ThemeData _getThemeData(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return CalderumTheme.lightTheme;
      case ThemeMode.dark:
        return CalderumTheme.darkTheme;
      case ThemeMode.system:
        final brightness = SchedulerBinding.instance.window.platformBrightness;
        return brightness == Brightness.dark
            ? CalderumTheme.darkTheme
            : CalderumTheme.lightTheme;
    }
  }
}

// Runtime theme customization
@riverpod
class RuntimeThemeCustomization extends _$RuntimeThemeCustomization {
  @override
  ThemeCustomization build() {
    return const ThemeCustomization();
  }

  void updateAccentColor(Color color) {
    state = state.copyWith(accentColor: color);
  }

  void updateAnimationSpeed(double speed) {
    state = state.copyWith(animationSpeed: speed);
  }

  void updateCornerRadius(double radius) {
    state = state.copyWith(cornerRadius: radius);
  }
}

@freezed
class ThemeCustomization with _$ThemeCustomization {
  const factory ThemeCustomization({
    @Default(Color(0xFF6B4E96)) Color accentColor,
    @Default(1.0) double animationSpeed,
    @Default(12.0) double cornerRadius,
    @Default(1.0) double textScale,
    @Default(false) bool highContrast,
  }) = _ThemeCustomization;
}

// Dynamic theme builder
class DynamicThemeBuilder extends ConsumerWidget {
  const DynamicThemeBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, ThemeData theme) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseTheme = Theme.of(context);
    final customization = ref.watch(runtimeThemeCustomizationProvider);
    
    final dynamicTheme = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: customization.accentColor,
      ),
      extensions: [
        ...baseTheme.extensions.values,
        CalderumAnimations.custom(
          speedMultiplier: customization.animationSpeed,
        ),
        CalderumSpacing.custom(
          cornerRadius: customization.cornerRadius,
        ),
      ],
    );

    return builder(context, dynamicTheme);
  }
}
```

### 2.4 Token Versioning and Migration Strategies

```dart
// Token version management
class TokenVersion {
  static const String current = '1.2.0';
  static const String minimum = '1.0.0';
  
  static const Map<String, TokenMigration> migrations = {
    '1.0.0->1.1.0': TokenMigration(
      from: '1.0.0',
      to: '1.1.0',
      changes: [
        'Added semantic color tokens',
        'Updated spacing scale',
      ],
    ),
    '1.1.0->1.2.0': TokenMigration(
      from: '1.1.0',
      to: '1.2.0',
      changes: [
        'Added game-specific tokens',
        'Updated animation durations',
      ],
    ),
  };
}

@freezed
class TokenMigration with _$TokenMigration {
  const factory TokenMigration({
    required String from,
    required String to,
    required List<String> changes,
  }) = _TokenMigration;
}

// Migration service
@riverpod
class TokenMigrationService extends _$TokenMigrationService {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString('token_version') ?? '1.0.0';
  }

  Future<void> migrateIfNeeded() async {
    final currentVersion = state;
    if (currentVersion == TokenVersion.current) return;

    final migrations = _getMigrationsNeeded(currentVersion);
    for (final migration in migrations) {
      await _applyMigration(migration);
    }

    await _updateVersion(TokenVersion.current);
  }

  List<TokenMigration> _getMigrationsNeeded(String fromVersion) {
    final migrations = <TokenMigration>[];
    String currentVersion = fromVersion;
    
    while (currentVersion != TokenVersion.current) {
      final migrationKey = '$currentVersion->${_getNextVersion(currentVersion)}';
      final migration = TokenVersion.migrations[migrationKey];
      
      if (migration != null) {
        migrations.add(migration);
        currentVersion = migration.to;
      } else {
        break;
      }
    }
    
    return migrations;
  }

  String _getNextVersion(String version) {
    // Logic to determine next version
    switch (version) {
      case '1.0.0':
        return '1.1.0';
      case '1.1.0':
        return '1.2.0';
      default:
        return TokenVersion.current;
    }
  }

  Future<void> _applyMigration(TokenMigration migration) async {
    // Apply specific migration logic
    print('Applying migration: ${migration.from} -> ${migration.to}');
    for (final change in migration.changes) {
      print('- $change');
    }
  }

  Future<void> _updateVersion(String version) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString('token_version', version);
    state = version;
  }
}
```

## 3. Component Library Architecture

### 3.1 Reusable Component Patterns

```dart
// Base component architecture
abstract class CalderumBaseComponent extends StatelessWidget {
  const CalderumBaseComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        _validateProps(context);
        return RepaintBoundary(
          child: buildComponent(context),
        );
      },
    );
  }

  Widget buildComponent(BuildContext context);

  void _validateProps(BuildContext context) {
    // Validation logic for component props
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMediaQuery(context));
  }
}

// Composition-based button system
class CalderumButton extends CalderumBaseComponent {
  const CalderumButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = CalderumButtonVariant.primary,
    this.size = CalderumButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.suffixIcon,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final CalderumButtonVariant variant;
  final CalderumButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final Widget? suffixIcon;

  @override
  Widget buildComponent(BuildContext context) {
    final tokens = ref.watch(designTokensProvider);
    final config = _getButtonConfig(tokens);
    
    return CalderumButtonBase(
      config: config,
      onPressed: _getOnPressed(),
      child: _buildButtonContent(context),
    );
  }

  ButtonConfig _getButtonConfig(TokenSet tokens) {
    return ButtonConfig(
      backgroundColor: variant.getBackgroundColor(tokens.colors),
      foregroundColor: variant.getForegroundColor(tokens.colors),
      borderRadius: size.getBorderRadius(tokens.spacing),
      padding: size.getPadding(tokens.spacing),
      elevation: variant.getElevation(),
      minHeight: size.getHeight(tokens.spacing),
    );
  }

  VoidCallback? _getOnPressed() {
    if (isDisabled || isLoading) return null;
    return onPressed;
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingContent(context);
    }

    final children = <Widget>[];
    
    if (icon != null) {
      children.add(icon!);
      children.add(SizedBox(width: size.iconSpacing));
    }
    
    children.add(child);
    
    if (suffixIcon != null) {
      children.add(SizedBox(width: size.iconSpacing));
      children.add(suffixIcon!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size.iconSize,
          height: size.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              variant.getForegroundColor(Theme.of(context).colorScheme),
            ),
          ),
        ),
        SizedBox(width: size.iconSpacing),
        child,
      ],
    );
  }
}

// Enumerated variants with behavior
enum CalderumButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger;

  Color getBackgroundColor(ColorTokens colors) {
    switch (this) {
      case CalderumButtonVariant.primary:
        return colors.primary;
      case CalderumButtonVariant.secondary:
        return colors.secondary;
      case CalderumButtonVariant.outline:
        return Colors.transparent;
      case CalderumButtonVariant.ghost:
        return Colors.transparent;
      case CalderumButtonVariant.danger:
        return colors.error;
    }
  }

  Color getForegroundColor(ColorTokens colors) {
    switch (this) {
      case CalderumButtonVariant.primary:
      case CalderumButtonVariant.danger:
        return Colors.white;
      case CalderumButtonVariant.secondary:
        return colors.background;
      case CalderumButtonVariant.outline:
      case CalderumButtonVariant.ghost:
        return colors.primary;
    }
  }

  double getElevation() {
    switch (this) {
      case CalderumButtonVariant.primary:
      case CalderumButtonVariant.secondary:
      case CalderumButtonVariant.danger:
        return 2.0;
      case CalderumButtonVariant.outline:
      case CalderumButtonVariant.ghost:
        return 0.0;
    }
  }

  BorderSide? getBorderSide(ColorTokens colors) {
    switch (this) {
      case CalderumButtonVariant.outline:
        return BorderSide(color: colors.primary, width: 1.5);
      case CalderumButtonVariant.primary:
      case CalderumButtonVariant.secondary:
      case CalderumButtonVariant.ghost:
      case CalderumButtonVariant.danger:
        return null;
    }
  }
}

enum CalderumButtonSize {
  small,
  medium,
  large;

  double getHeight(SpacingTokens spacing) {
    switch (this) {
      case CalderumButtonSize.small:
        return 36.0;
      case CalderumButtonSize.medium:
        return 48.0;
      case CalderumButtonSize.large:
        return 56.0;
    }
  }

  EdgeInsets getPadding(SpacingTokens spacing) {
    switch (this) {
      case CalderumButtonSize.small:
        return EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xs);
      case CalderumButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm);
      case CalderumButtonSize.large:
        return EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.md);
    }
  }

  double getBorderRadius(SpacingTokens spacing) {
    switch (this) {
      case CalderumButtonSize.small:
        return spacing.radiusXs;
      case CalderumButtonSize.medium:
        return spacing.radiusSm;
      case CalderumButtonSize.large:
        return spacing.radiusMd;
    }
  }

  double get iconSize {
    switch (this) {
      case CalderumButtonSize.small:
        return 16.0;
      case CalderumButtonSize.medium:
        return 20.0;
      case CalderumButtonSize.large:
        return 24.0;
    }
  }

  double get iconSpacing {
    switch (this) {
      case CalderumButtonSize.small:
        return 6.0;
      case CalderumButtonSize.medium:
        return 8.0;
      case CalderumButtonSize.large:
        return 12.0;
    }
  }
}
```

### 3.2 Composition Over Inheritance Principles

```dart
// Composable component system
mixin CalderumInteractiveMixin {
  bool get isInteractive => true;
  Duration get animationDuration => const Duration(milliseconds: 200);
  Curve get animationCurve => Curves.easeInOut;
}

mixin CalderumFocusableMixin {
  bool get canRequestFocus => true;
  FocusNode? get focusNode;
  void onFocusChange(bool hasFocus) {}
}

mixin CalderumHoverableMixin {
  bool get isHoverable => true;
  void onHover(bool isHovered) {}
}

// Composed interactive card
class CalderumInteractiveCard extends StatefulWidget 
    with CalderumInteractiveMixin, CalderumFocusableMixin, CalderumHoverableMixin {
  const CalderumInteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.elevation = 2.0,
    this.focusNode,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double elevation;
  @override
  final FocusNode? focusNode;

  @override
  State<CalderumInteractiveCard> createState() => _CalderumInteractiveCardState();
}

class _CalderumInteractiveCardState extends State<CalderumInteractiveCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;
  bool _isPressed = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    
    _hoverController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation + 2.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: widget.animationCurve,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onFocusChange: _handleFocusChange,
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => _handlePress(true),
          onTapUp: (_) => _handlePress(false),
          onTapCancel: () => _handlePress(false),
          child: AnimatedBuilder(
            animation: Listenable.merge([_elevationAnimation, _scaleAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Card(
                  elevation: _elevationAnimation.value,
                  shape: RoundedRectangleBorder(
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: widget.padding ?? const EdgeInsets.all(16),
                    child: widget.child,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleHover(bool isHovered) {
    if (_isHovered == isHovered) return;
    setState(() => _isHovered = isHovered);
    
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
    
    widget.onHover(isHovered);
  }

  void _handlePress(bool isPressed) {
    if (_isPressed == isPressed) return;
    setState(() => _isPressed = isPressed);
    
    if (isPressed) {
      _pressController.forward();
    } else {
      _pressController.reverse();
    }
  }

  void _handleFocusChange(bool hasFocus) {
    widget.onFocusChange(hasFocus);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }
}
```

### 3.3 Props/Parameter Standardization

```dart
// Standardized prop patterns
@immutable
class CalderumComponentProps {
  const CalderumComponentProps({
    this.variant = ComponentVariant.primary,
    this.size = ComponentSize.medium,
    this.state = ComponentState.enabled,
    this.semanticLabel,
    this.testKey,
  });

  final ComponentVariant variant;
  final ComponentSize size;
  final ComponentState state;
  final String? semanticLabel;
  final Key? testKey;

  CalderumComponentProps copyWith({
    ComponentVariant? variant,
    ComponentSize? size,
    ComponentState? state,
    String? semanticLabel,
    Key? testKey,
  }) {
    return CalderumComponentProps(
      variant: variant ?? this.variant,
      size: size ?? this.size,
      state: state ?? this.state,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      testKey: testKey ?? this.testKey,
    );
  }
}

// Standardized enums across components
enum ComponentVariant {
  primary,
  secondary,
  tertiary,
  danger,
  success,
  warning,
  info;

  String get semanticName => name;
}

enum ComponentSize {
  extraSmall,
  small,
  medium,
  large,
  extraLarge;

  String get semanticName => name;
  
  double get scaleFactor {
    switch (this) {
      case ComponentSize.extraSmall:
        return 0.75;
      case ComponentSize.small:
        return 0.875;
      case ComponentSize.medium:
        return 1.0;
      case ComponentSize.large:
        return 1.125;
      case ComponentSize.extraLarge:
        return 1.25;
    }
  }
}

enum ComponentState {
  enabled,
  disabled,
  loading,
  error,
  success;

  bool get isInteractive => this == ComponentState.enabled;
  bool get isLoading => this == ComponentState.loading;
  bool get hasError => this == ComponentState.error;
  bool get isSuccess => this == ComponentState.success;
  
  String get semanticName => name;
}

// Prop validation mixin
mixin PropValidationMixin {
  void validateProps(BuildContext context) {
    assert(() {
      _checkRequiredProps();
      _checkPropCombinations();
      _checkAccessibilityProps();
      return true;
    }());
  }

  void _checkRequiredProps() {
    // Override in implementations
  }

  void _checkPropCombinations() {
    // Override in implementations
  }

  void _checkAccessibilityProps() {
    // Override in implementations
  }
}

// Standardized component factory
abstract class CalderumComponentFactory<T extends CalderumBaseComponent> {
  T create({required CalderumComponentProps props});
  
  T createPrimary({ComponentSize size = ComponentSize.medium}) {
    return create(
      props: CalderumComponentProps(
        variant: ComponentVariant.primary,
        size: size,
      ),
    );
  }

  T createSecondary({ComponentSize size = ComponentSize.medium}) {
    return create(
      props: CalderumComponentProps(
        variant: ComponentVariant.secondary,
        size: size,
      ),
    );
  }

  T createDisabled({ComponentSize size = ComponentSize.medium}) {
    return create(
      props: CalderumComponentProps(
        state: ComponentState.disabled,
        size: size,
      ),
    );
  }
}

// Example usage
class CalderumButtonFactory extends CalderumComponentFactory<CalderumButton> {
  @override
  CalderumButton create({required CalderumComponentProps props}) {
    return CalderumButton(
      variant: _mapVariant(props.variant),
      size: _mapSize(props.size),
      isDisabled: props.state == ComponentState.disabled,
      isLoading: props.state == ComponentState.loading,
      key: props.testKey,
      onPressed: null, // Provided by caller
      child: const SizedBox.shrink(), // Provided by caller
    );
  }

  CalderumButtonVariant _mapVariant(ComponentVariant variant) {
    switch (variant) {
      case ComponentVariant.primary:
        return CalderumButtonVariant.primary;
      case ComponentVariant.secondary:
        return CalderumButtonVariant.secondary;
      case ComponentVariant.danger:
        return CalderumButtonVariant.danger;
      default:
        return CalderumButtonVariant.primary;
    }
  }

  CalderumButtonSize _mapSize(ComponentSize size) {
    switch (size) {
      case ComponentSize.small:
      case ComponentSize.extraSmall:
        return CalderumButtonSize.small;
      case ComponentSize.medium:
        return CalderumButtonSize.medium;
      case ComponentSize.large:
      case ComponentSize.extraLarge:
        return CalderumButtonSize.large;
    }
  }
}
```

### 3.4 Testing Strategies for Components

```dart
// Component test base class
abstract class CalderumComponentTest {
  Widget createWidget({
    required CalderumComponentProps props,
    Map<String, dynamic> additionalProps = const {},
  });

  void runStandardTests() {
    group('Standard Component Tests', () {
      testWidgets('renders with default props', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: createWidget(
              props: const CalderumComponentProps(),
            ),
          ),
        );

        expect(find.byType(createWidget().runtimeType), findsOneWidget);
      });

      testWidgets('applies correct semantics', (tester) async {
        const semanticLabel = 'Test Component';
        await tester.pumpWidget(
          MaterialApp(
            home: createWidget(
              props: const CalderumComponentProps(
                semanticLabel: semanticLabel,
              ),
            ),
          ),
        );

        expect(
          find.bySemanticsLabel(semanticLabel),
          findsOneWidget,
        );
      });

      testWidgets('responds to size variants', (tester) async {
        for (final size in ComponentSize.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: createWidget(
                props: CalderumComponentProps(size: size),
              ),
            ),
          );

          // Test size-specific expectations
          await _testSizeVariant(tester, size);
        }
      });

      testWidgets('responds to state changes', (tester) async {
        for (final state in ComponentState.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: createWidget(
                props: CalderumComponentProps(state: state),
              ),
            ),
          );

          await _testStateVariant(tester, state);
        }
      });

      testWidgets('supports accessibility features', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: createWidget(
              props: const CalderumComponentProps(
                semanticLabel: 'Accessible Component',
              ),
            ),
          ),
        );

        await _testAccessibility(tester);
      });
    });
  }

  Future<void> _testSizeVariant(WidgetTester tester, ComponentSize size);
  Future<void> _testStateVariant(WidgetTester tester, ComponentState state);
  Future<void> _testAccessibility(WidgetTester tester);
}

// Button component tests
class CalderumButtonTest extends CalderumComponentTest {
  @override
  Widget createWidget({
    required CalderumComponentProps props,
    Map<String, dynamic> additionalProps = const {},
  }) {
    return CalderumButton(
      variant: _mapVariant(props.variant),
      size: _mapSize(props.size),
      isDisabled: props.state == ComponentState.disabled,
      isLoading: props.state == ComponentState.loading,
      onPressed: additionalProps['onPressed'] ?? () {},
      child: Text(additionalProps['text'] ?? 'Test Button'),
    );
  }

  CalderumButtonVariant _mapVariant(ComponentVariant variant) {
    // Same mapping logic as factory
  }

  CalderumButtonSize _mapSize(ComponentSize size) {
    // Same mapping logic as factory
  }

  @override
  Future<void> _testSizeVariant(WidgetTester tester, ComponentSize size) async {
    final button = find.byType(CalderumButton);
    expect(button, findsOneWidget);

    final widget = tester.widget<CalderumButton>(button);
    expect(widget.size, equals(_mapSize(size)));
  }

  @override
  Future<void> _testStateVariant(WidgetTester tester, ComponentState state) async {
    final button = find.byType(CalderumButton);
    expect(button, findsOneWidget);

    final widget = tester.widget<CalderumButton>(button);
    
    switch (state) {
      case ComponentState.disabled:
        expect(widget.isDisabled, isTrue);
        expect(widget.onPressed, isNull);
        break;
      case ComponentState.loading:
        expect(widget.isLoading, isTrue);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        break;
      case ComponentState.enabled:
        expect(widget.isDisabled, isFalse);
        expect(widget.isLoading, isFalse);
        break;
      default:
        break;
    }
  }

  @override
  Future<void> _testAccessibility(WidgetTester tester) async {
    // Test screen reader semantics
    expect(find.bySemanticsLabel('Accessible Component'), findsOneWidget);
    
    // Test focus behavior
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    
    // Verify focus is on the button
    final focusedWidget = tester.binding.focusManager.primaryFocus?.context?.widget;
    expect(focusedWidget, isA<CalderumButton>());
  }

  void runButtonSpecificTests() {
    group('Button Specific Tests', () {
      testWidgets('handles tap events', (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: createWidget(
              props: const CalderumComponentProps(),
              additionalProps: {
                'onPressed': () => tapped = true,
              },
            ),
          ),
        );

        await tester.tap(find.byType(CalderumButton));
        expect(tapped, isTrue);
      });

      testWidgets('shows loading indicator when loading', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: createWidget(
              props: const CalderumComponentProps(
                state: ComponentState.loading,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('prevents interaction when disabled', (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: createWidget(
              props: const CalderumComponentProps(
                state: ComponentState.disabled,
              ),
              additionalProps: {
                'onPressed': () => tapped = true,
              },
            ),
          ),
        );

        await tester.tap(find.byType(CalderumButton));
        expect(tapped, isFalse);
      });
    });
  }
}

// Golden test utilities
class ComponentGoldenTest {
  static Future<void> testVariants<T extends Widget>({
    required WidgetTester tester,
    required T Function(CalderumComponentProps props) createWidget,
    required String componentName,
  }) async {
    for (final variant in ComponentVariant.values) {
      for (final size in ComponentSize.values) {
        for (final state in ComponentState.values) {
          final props = CalderumComponentProps(
            variant: variant,
            size: size,
            state: state,
          );

          await tester.pumpWidget(
            MaterialApp(
              theme: CalderumTheme.darkTheme,
              home: Scaffold(
                body: Center(
                  child: createWidget(props),
                ),
              ),
            ),
          );

          await expectLater(
            find.byType(Scaffold),
            matchesGoldenFile(
              'goldens/${componentName}_${variant.name}_${size.name}_${state.name}.png',
            ),
          );
        }
      }
    }
  }
}
```

### 3.5 Documentation Generation for Components

```dart
// Component documentation annotations
class ComponentDoc {
  const ComponentDoc({
    required this.name,
    required this.description,
    this.examples = const [],
    this.properties = const [],
    this.accessibility = const [],
    this.designNotes = const [],
  });

  final String name;
  final String description;
  final List<ComponentExample> examples;
  final List<ComponentProperty> properties;
  final List<String> accessibility;
  final List<String> designNotes;
}

class ComponentExample {
  const ComponentExample({
    required this.title,
    required this.description,
    required this.code,
    this.preview,
  });

  final String title;
  final String description;
  final String code;
  final Widget? preview;
}

class ComponentProperty {
  const ComponentProperty({
    required this.name,
    required this.type,
    required this.description,
    this.defaultValue,
    this.required = false,
  });

  final String name;
  final String type;
  final String description;
  final String? defaultValue;
  final bool required;
}

// Documentation for CalderumButton
@ComponentDoc(
  name: 'CalderumButton',
  description: 'A themed button component with multiple variants and sizes, supporting loading states and accessibility features.',
  examples: [
    ComponentExample(
      title: 'Basic Usage',
      description: 'Simple button with text',
      code: '''
CalderumButton(
  onPressed: () => print('Pressed!'),
  child: Text('Click Me'),
)
''',
    ),
    ComponentExample(
      title: 'With Icon',
      description: 'Button with leading icon',
      code: '''
CalderumButton(
  onPressed: () => print('Pressed!'),
  icon: Icon(Icons.star),
  child: Text('Favorite'),
)
''',
    ),
    ComponentExample(
      title: 'Loading State',
      description: 'Button showing loading indicator',
      code: '''
CalderumButton(
  onPressed: null,
  isLoading: true,
  child: Text('Please Wait'),
)
''',
    ),
  ],
  properties: [
    ComponentProperty(
      name: 'onPressed',
      type: 'VoidCallback?',
      description: 'Callback fired when button is pressed',
      required: true,
    ),
    ComponentProperty(
      name: 'child',
      type: 'Widget',
      description: 'Button content',
      required: true,
    ),
    ComponentProperty(
      name: 'variant',
      type: 'CalderumButtonVariant',
      description: 'Visual style variant',
      defaultValue: 'CalderumButtonVariant.primary',
    ),
    ComponentProperty(
      name: 'size',
      type: 'CalderumButtonSize',
      description: 'Button size',
      defaultValue: 'CalderumButtonSize.medium',
    ),
    ComponentProperty(
      name: 'isLoading',
      type: 'bool',
      description: 'Shows loading indicator when true',
      defaultValue: 'false',
    ),
    ComponentProperty(
      name: 'isDisabled',
      type: 'bool',
      description: 'Disables interaction when true',
      defaultValue: 'false',
    ),
  ],
  accessibility: [
    'Supports screen readers with semantic labels',
    'Keyboard navigation with Tab and Enter keys',
    'Focus indicators with proper contrast',
    'Loading state announced to screen readers',
    'Disabled state properly communicated',
  ],
  designNotes: [
    'Maintains 44px minimum touch target on mobile',
    'Uses theme colors for consistent branding',
    'Hover and press states provide visual feedback',
    'Loading spinner matches button text color',
    'Border radius follows design system scale',
  ],
)
class CalderumButton extends CalderumBaseComponent {
  // Implementation...
}

// Documentation generator
class ComponentDocumentationGenerator {
  static Future<void> generateMarkdown({
    required String outputDir,
    required List<Type> componentTypes,
  }) async {
    final buffer = StringBuffer();
    
    buffer.writeln('# Calderum Design System Components\n');
    buffer.writeln('Auto-generated component documentation.\n');
    
    for (final type in componentTypes) {
      final doc = _getComponentDocumentation(type);
      if (doc != null) {
        _writeComponentSection(buffer, doc);
      }
    }

    final file = File('$outputDir/components.md');
    await file.writeAsString(buffer.toString());
  }

  static ComponentDoc? _getComponentDocumentation(Type type) {
    // Use reflection to get ComponentDoc annotation
    // This would require additional setup for code generation
    return null; // Placeholder
  }

  static void _writeComponentSection(StringBuffer buffer, ComponentDoc doc) {
    buffer.writeln('## ${doc.name}\n');
    buffer.writeln('${doc.description}\n');
    
    // Properties section
    buffer.writeln('### Properties\n');
    buffer.writeln('| Property | Type | Description | Default | Required |');
    buffer.writeln('|----------|------|-------------|---------|----------|');
    
    for (final prop in doc.properties) {
      buffer.writeln('| ${prop.name} | `${prop.type}` | ${prop.description} | `${prop.defaultValue ?? 'null'}` | ${prop.required ? '✓' : ''} |');
    }
    buffer.writeln();
    
    // Examples section
    buffer.writeln('### Examples\n');
    for (final example in doc.examples) {
      buffer.writeln('#### ${example.title}\n');
      buffer.writeln('${example.description}\n');
      buffer.writeln('```dart');
      buffer.writeln(example.code);
      buffer.writeln('```\n');
    }
    
    // Accessibility section
    if (doc.accessibility.isNotEmpty) {
      buffer.writeln('### Accessibility\n');
      for (final item in doc.accessibility) {
        buffer.writeln('- $item');
      }
      buffer.writeln();
    }
    
    // Design notes section
    if (doc.designNotes.isNotEmpty) {
      buffer.writeln('### Design Notes\n');
      for (final note in doc.designNotes) {
        buffer.writeln('- $note');
      }
      buffer.writeln();
    }
    
    buffer.writeln('---\n');
  }

  static Future<void> generateStorybook({
    required String outputDir,
    required List<Type> componentTypes,
  }) async {
    // Generate Storybook-like component showcase
    // This would create interactive documentation
  }
}
```

This comprehensive implementation framework provides developers with all the tools needed to effectively implement the Calderum design system. The following sections complete the technical implementation guidance.

## 4. Accessibility Implementation

### 4.1 Screen Reader Testing Procedures

```dart
// Screen reader testing utilities
class ScreenReaderTestingHelper {
  static Future<void> testComponentAccessibility({
    required WidgetTester tester,
    required Widget widget,
    required String expectedLabel,
    required String expectedHint,
    List<String> expectedActions = const [],
  }) async {
    await tester.pumpWidget(MaterialApp(home: widget));
    
    // Test semantic labels
    expect(find.bySemanticsLabel(expectedLabel), findsOneWidget);
    
    // Test semantic hints
    final semanticsData = tester.getSemantics(find.byWidget(widget));
    expect(semanticsData.hint, expectedHint);
    
    // Test available actions
    for (final action in expectedActions) {
      expect(
        semanticsData.getSemanticsData().actions.keys.map((key) => key.toString()),
        contains(action),
      );
    }
  }

  static Future<void> announceToScreenReader(
    String message, {
    Assertiveness assertiveness = Assertiveness.polite,
  }) async {
    await SemanticsService.announce(message, TextDirection.ltr);
  }
}

// Accessibility-aware component wrapper
class AccessibilityWrapper extends StatelessWidget {
  const AccessibilityWrapper({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.value,
    this.increasedValue,
    this.decreasedValue,
    this.onTap,
    this.onIncrease,
    this.onDecrease,
    this.isButton = false,
    this.isSlider = false,
    this.isToggle = false,
    this.isFocusable = true,
  });

  final Widget child;
  final String? label;
  final String? hint;
  final String? value;
  final String? increasedValue;
  final String? decreasedValue;
  final VoidCallback? onTap;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final bool isButton;
  final bool isSlider;
  final bool isToggle;
  final bool isFocusable;

  @override
  Widget build(BuildContext context) {
    Widget semanticChild = child;

    if (isButton) {
      semanticChild = Semantics(
        button: true,
        label: label,
        hint: hint,
        onTap: onTap,
        focusable: isFocusable,
        child: child,
      );
    } else if (isSlider) {
      semanticChild = Semantics(
        slider: true,
        label: label,
        hint: hint,
        value: value,
        increasedValue: increasedValue,
        decreasedValue: decreasedValue,
        onIncrease: onIncrease,
        onDecrease: onDecrease,
        focusable: isFocusable,
        child: child,
      );
    } else if (isToggle) {
      semanticChild = Semantics(
        toggleableState: value == 'true',
        label: label,
        hint: hint,
        onTap: onTap,
        focusable: isFocusable,
        child: child,
      );
    } else {
      semanticChild = Semantics(
        label: label,
        hint: hint,
        value: value,
        focusable: isFocusable,
        child: child,
      );
    }

    return semanticChild;
  }
}

// Game-specific accessibility helpers
class GameAccessibilityHelper {
  static String formatIngredientDescription(IngredientChip ingredient) {
    return '${ingredient.color.name} ingredient chip with value ${ingredient.value}. '
           '${ingredient.isSelected ? 'Selected' : 'Not selected'}. '
           '${ingredient.ability != null ? 'Special ability: ${ingredient.ability}' : 'No special ability'}.';
  }

  static String formatCauldronState(int currentValue, int maxValue) {
    final remainingCapacity = maxValue - currentValue;
    final riskLevel = currentValue >= 5 ? 'High risk' : 
                     currentValue >= 3 ? 'Medium risk' : 'Low risk';
    
    return 'Cauldron at $currentValue out of $maxValue capacity. '
           '$remainingCapacity points remaining. '
           'Risk level: $riskLevel.';
  }

  static String formatPlayerStatus(Player player, GamePhase phase) {
    final statusParts = <String>[
      'Player ${player.name}',
      if (player.isCurrentPlayer) 'Current turn',
      'Score: ${player.score}',
      'Phase: ${phase.name}',
    ];
    
    return statusParts.join(', ');
  }
}
```

### 4.2 Keyboard Navigation Implementation

```dart
// Keyboard navigation controller
class KeyboardNavigationController extends ChangeNotifier {
  final List<FocusNode> _focusNodes = [];
  int _currentIndex = 0;
  
  void registerFocusNode(FocusNode node) {
    _focusNodes.add(node);
    node.addListener(_onFocusChange);
  }

  void unregisterFocusNode(FocusNode node) {
    _focusNodes.remove(node);
    node.removeListener(_onFocusChange);
  }

  void _onFocusChange() {
    final focusedIndex = _focusNodes.indexWhere((node) => node.hasFocus);
    if (focusedIndex != -1) {
      _currentIndex = focusedIndex;
      notifyListeners();
    }
  }

  void moveFocusNext() {
    if (_focusNodes.isEmpty) return;
    
    _currentIndex = (_currentIndex + 1) % _focusNodes.length;
    _focusNodes[_currentIndex].requestFocus();
  }

  void moveFocusPrevious() {
    if (_focusNodes.isEmpty) return;
    
    _currentIndex = _currentIndex > 0 ? _currentIndex - 1 : _focusNodes.length - 1;
    _focusNodes[_currentIndex].requestFocus();
  }

  void focusFirst() {
    if (_focusNodes.isNotEmpty) {
      _currentIndex = 0;
      _focusNodes[_currentIndex].requestFocus();
    }
  }

  void focusLast() {
    if (_focusNodes.isNotEmpty) {
      _currentIndex = _focusNodes.length - 1;
      _focusNodes[_currentIndex].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.removeListener(_onFocusChange);
    }
    _focusNodes.clear();
    super.dispose();
  }
}

// Keyboard navigation mixin
mixin KeyboardNavigationMixin<T extends StatefulWidget> on State<T> {
  late KeyboardNavigationController _navigationController;
  
  KeyboardNavigationController get navigationController => _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = KeyboardNavigationController();
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  Widget buildWithKeyboardNavigation({
    required Widget child,
    Map<LogicalKeySet, Intent> shortcuts = const {},
    Map<Type, Action<Intent>> actions = const {},
  }) {
    final defaultShortcuts = {
      LogicalKeySet(LogicalKeyboardKey.tab): NextFocusIntent(),
      LogicalKeySet(LogicalKeyboardKey.tab, LogicalKeyboardKey.shift): PreviousFocusIntent(),
      LogicalKeySet(LogicalKeyboardKey.home): _FirstFocusIntent(),
      LogicalKeySet(LogicalKeyboardKey.end): _LastFocusIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowDown): NextFocusIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowUp): PreviousFocusIntent(),
      ...shortcuts,
    };

    final defaultActions = {
      NextFocusIntent: CallbackAction<NextFocusIntent>(
        onInvoke: (_) => _navigationController.moveFocusNext(),
      ),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
        onInvoke: (_) => _navigationController.moveFocusPrevious(),
      ),
      _FirstFocusIntent: CallbackAction<_FirstFocusIntent>(
        onInvoke: (_) => _navigationController.focusFirst(),
      ),
      _LastFocusIntent: CallbackAction<_LastFocusIntent>(
        onInvoke: (_) => _navigationController.focusLast(),
      ),
      ...actions,
    };

    return Shortcuts(
      shortcuts: defaultShortcuts,
      child: Actions(
        actions: defaultActions,
        child: child,
      ),
    );
  }
}

class _FirstFocusIntent extends Intent {}
class _LastFocusIntent extends Intent {}

// Focusable game component
class FocusableIngredientChip extends StatefulWidget {
  const FocusableIngredientChip({
    super.key,
    required this.ingredient,
    required this.onTap,
    this.focusNode,
  });

  final IngredientChip ingredient;
  final VoidCallback onTap;
  final FocusNode? focusNode;

  @override
  State<FocusableIngredientChip> createState() => _FocusableIngredientChipState();
}

class _FocusableIngredientChipState extends State<FocusableIngredientChip> {
  late FocusNode _focusNode;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onFocusChange: _handleFocusChange,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AccessibilityWrapper(
            isButton: true,
            label: GameAccessibilityHelper.formatIngredientDescription(widget.ingredient),
            hint: 'Double tap to select ingredient',
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: widget.ingredient.color,
                border: Border.all(
                  color: _focusNode.hasFocus || _isHovered
                      ? Theme.of(context).focusColor
                      : Colors.transparent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: widget.ingredient,
            ),
          ),
        ),
      ),
    );
  }

  void _handleFocusChange(bool hasFocus) {
    if (hasFocus) {
      // Announce ingredient details when focused
      ScreenReaderTestingHelper.announceToScreenReader(
        GameAccessibilityHelper.formatIngredientDescription(widget.ingredient),
      );
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }
}
```

### 4.3 High Contrast Mode Support

```dart
// High contrast theme provider
@riverpod
class HighContrastTheme extends _$HighContrastTheme {
  @override
  bool build() {
    final mediaQuery = ref.watch(mediaQueryProvider);
    final prefs = ref.watch(sharedPreferencesProvider);
    
    // Check system preference first, then user preference
    return prefs.getBool('force_high_contrast') ?? 
           mediaQuery.highContrast;
  }

  void toggleHighContrast() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final newValue = !state;
    await prefs.setBool('force_high_contrast', newValue);
    state = newValue;
  }
}

// High contrast color extensions
extension HighContrastColors on CalderumColors {
  static CalderumColors get highContrast => const CalderumColors(
    magicPurple: Color(0xFF000080),      // Darker blue
    mysticalGold: Color(0xFFFFFF00),     // Pure yellow
    darkSurface: Color(0xFF000000),      // Pure black
    darkBackground: Color(0xFF000000),   // Pure black
    safeGreen: Color(0xFF00FF00),        // Pure green
    dangerRed: Color(0xFFFF0000),        // Pure red
    infoBlue: Color(0xFF0000FF),         // Pure blue
    warningAmber: Color(0xFFFFAA00),     // High contrast orange
    gradientPrimary: [Color(0xFF000080), Color(0xFFFFFF00)],
    gradientSecondary: [Color(0xFF000000), Color(0xFF000080)],
  );

  CalderumColors toHighContrast() {
    return CalderumColors(
      magicPurple: _toHighContrastColor(magicPurple),
      mysticalGold: _toHighContrastColor(mysticalGold),
      darkSurface: Color(0xFF000000),
      darkBackground: Color(0xFF000000),
      safeGreen: Color(0xFF00FF00),
      dangerRed: Color(0xFFFF0000),
      infoBlue: Color(0xFF0000FF),
      warningAmber: Color(0xFFFFAA00),
      gradientPrimary: gradientPrimary.map(_toHighContrastColor).toList(),
      gradientSecondary: gradientSecondary.map(_toHighContrastColor).toList(),
    );
  }

  Color _toHighContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.white : Colors.black;
  }
}

// High contrast component wrapper
class HighContrastWrapper extends ConsumerWidget {
  const HighContrastWrapper({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
  });

  final Widget child;
  final double borderWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHighContrast = ref.watch(highContrastThemeProvider);
    
    if (!isHighContrast) return child;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}

// Focus indicator with high contrast support
class CalderumFocusIndicator extends StatelessWidget {
  const CalderumFocusIndicator({
    super.key,
    required this.child,
    required this.hasFocus,
    this.borderRadius = 8.0,
    this.padding = 4.0,
  });

  final Widget child;
  final bool hasFocus;
  final double borderRadius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    if (!hasFocus) return child;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).focusColor,
          width: 3.0, // Increased for high contrast
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
```

### 4.4 Voice Control Integration

```dart
// Voice command handler
class VoiceCommandHandler {
  static const Map<String, VoiceCommand> _commands = {
    'select ingredient': VoiceCommand.selectIngredient,
    'brew potion': VoiceCommand.brewPotion,
    'end turn': VoiceCommand.endTurn,
    'show help': VoiceCommand.showHelp,
    'read game state': VoiceCommand.readGameState,
    'focus next': VoiceCommand.focusNext,
    'focus previous': VoiceCommand.focusPrevious,
  };

  static VoiceCommand? parseCommand(String spokenText) {
    final normalized = spokenText.toLowerCase().trim();
    
    for (final entry in _commands.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return null;
  }

  static Future<void> executeCommand(
    VoiceCommand command,
    BuildContext context,
  ) async {
    switch (command) {
      case VoiceCommand.selectIngredient:
        await _selectIngredient(context);
        break;
      case VoiceCommand.brewPotion:
        await _brewPotion(context);
        break;
      case VoiceCommand.endTurn:
        await _endTurn(context);
        break;
      case VoiceCommand.showHelp:
        await _showHelp(context);
        break;
      case VoiceCommand.readGameState:
        await _readGameState(context);
        break;
      case VoiceCommand.focusNext:
        await _focusNext(context);
        break;
      case VoiceCommand.focusPrevious:
        await _focusPrevious(context);
        break;
    }
  }

  static Future<void> _selectIngredient(BuildContext context) async {
    final focusedWidget = FocusManager.instance.primaryFocus?.context?.widget;
    if (focusedWidget is FocusableIngredientChip) {
      focusedWidget.onTap();
      await ScreenReaderTestingHelper.announceToScreenReader(
        'Ingredient selected',
        assertiveness: Assertiveness.assertive,
      );
    } else {
      await ScreenReaderTestingHelper.announceToScreenReader(
        'No ingredient focused. Use focus commands to navigate to an ingredient first.',
      );
    }
  }

  static Future<void> _readGameState(BuildContext context) async {
    // This would read current game state aloud
    final gameState = context.read<GameStateNotifier>().state;
    final announcement = GameAccessibilityHelper.formatCauldronState(
      gameState.currentPlayer.cauldronValue,
      7, // max before explosion
    );
    await ScreenReaderTestingHelper.announceToScreenReader(announcement);
  }

  // Additional command implementations...
}

enum VoiceCommand {
  selectIngredient,
  brewPotion,
  endTurn,
  showHelp,
  readGameState,
  focusNext,
  focusPrevious,
}

// Voice control provider
@riverpod
class VoiceControlService extends _$VoiceControlService {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool('voice_control_enabled') ?? false;
  }

  Future<void> toggleVoiceControl() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final newValue = !state;
    await prefs.setBool('voice_control_enabled', newValue);
    state = newValue;
    
    if (newValue) {
      await _startListening();
    } else {
      await _stopListening();
    }
  }

  Future<void> _startListening() async {
    // Initialize speech recognition
    // This would integrate with speech_to_text package
  }

  Future<void> _stopListening() async {
    // Stop speech recognition
  }
}
```

### 4.5 Accessibility Audit Processes

```dart
// Accessibility audit runner
class AccessibilityAuditor {
  static Future<AccessibilityAuditReport> runAudit(
    WidgetTester tester,
    Widget widget,
  ) async {
    final report = AccessibilityAuditReport();
    
    await tester.pumpWidget(MaterialApp(home: widget));
    
    // Test 1: Semantic labels
    await _auditSemanticLabels(tester, report);
    
    // Test 2: Focus management
    await _auditFocusManagement(tester, report);
    
    // Test 3: Color contrast
    await _auditColorContrast(tester, report);
    
    // Test 4: Touch targets
    await _auditTouchTargets(tester, report);
    
    // Test 5: Screen reader compatibility
    await _auditScreenReaderCompatibility(tester, report);
    
    return report;
  }

  static Future<void> _auditSemanticLabels(
    WidgetTester tester,
    AccessibilityAuditReport report,
  ) async {
    final semanticsNodes = tester.binding.pipelineOwner
        .semanticsOwner?.rootSemanticsNode?.visitChildren();
    
    final unlabeledInteractiveElements = <String>[];
    
    semanticsNodes?.forEach((node) {
      if (node.hasAction(SemanticsAction.tap) && 
          (node.label?.isEmpty ?? true)) {
        unlabeledInteractiveElements.add(node.toString());
      }
    });
    
    if (unlabeledInteractiveElements.isNotEmpty) {
      report.addIssue(AccessibilityIssue(
        severity: AccessibilitySeverity.error,
        type: AccessibilityIssueType.missingLabel,
        description: 'Interactive elements missing semantic labels',
        elements: unlabeledInteractiveElements,
        recommendation: 'Add meaningful labels to all interactive elements',
      ));
    }
  }

  static Future<void> _auditTouchTargets(
    WidgetTester tester,
    AccessibilityAuditReport report,
  ) async {
    const minTouchTargetSize = 44.0;
    final smallTargets = <String>[];
    
    final elements = find.byType(GestureDetector);
    for (int i = 0; i < elements.evaluate().length; i++) {
      final element = elements.at(i);
      final renderBox = tester.renderObject<RenderBox>(element);
      final size = renderBox.size;
      
      if (size.width < minTouchTargetSize || size.height < minTouchTargetSize) {
        smallTargets.add('GestureDetector at index $i: ${size.width}x${size.height}');
      }
    }
    
    if (smallTargets.isNotEmpty) {
      report.addIssue(AccessibilityIssue(
        severity: AccessibilitySeverity.warning,
        type: AccessibilityIssueType.smallTouchTarget,
        description: 'Touch targets smaller than 44x44 pixels',
        elements: smallTargets,
        recommendation: 'Increase touch target size to at least 44x44 pixels',
      ));
    }
  }

  static Future<void> _auditColorContrast(
    WidgetTester tester,
    AccessibilityAuditReport report,
  ) async {
    // This would analyze text/background color combinations
    // and calculate contrast ratios
    final lowContrastElements = <String>[];
    
    // Implementation would check WCAG contrast requirements
    // For now, this is a simplified example
    
    if (lowContrastElements.isNotEmpty) {
      report.addIssue(AccessibilityIssue(
        severity: AccessibilitySeverity.error,
        type: AccessibilityIssueType.lowContrast,
        description: 'Text elements with insufficient color contrast',
        elements: lowContrastElements,
        recommendation: 'Ensure minimum 4.5:1 contrast ratio for normal text, 3:1 for large text',
      ));
    }
  }
}

// Accessibility audit report
class AccessibilityAuditReport {
  final List<AccessibilityIssue> _issues = [];
  
  List<AccessibilityIssue> get issues => List.unmodifiable(_issues);
  
  void addIssue(AccessibilityIssue issue) {
    _issues.add(issue);
  }
  
  bool get hasErrors => _issues.any((issue) => issue.severity == AccessibilitySeverity.error);
  bool get hasWarnings => _issues.any((issue) => issue.severity == AccessibilitySeverity.warning);
  
  int get errorCount => _issues.where((issue) => issue.severity == AccessibilitySeverity.error).length;
  int get warningCount => _issues.where((issue) => issue.severity == AccessibilitySeverity.warning).length;
  
  String generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('# Accessibility Audit Report');
    buffer.writeln();
    buffer.writeln('## Summary');
    buffer.writeln('- Errors: $errorCount');
    buffer.writeln('- Warnings: $warningCount');
    buffer.writeln();
    
    if (_issues.isNotEmpty) {
      buffer.writeln('## Issues');
      for (final issue in _issues) {
        buffer.writeln('### ${issue.type.name} (${issue.severity.name})');
        buffer.writeln(issue.description);
        buffer.writeln();
        buffer.writeln('**Recommendation:** ${issue.recommendation}');
        buffer.writeln();
        if (issue.elements.isNotEmpty) {
          buffer.writeln('**Affected elements:**');
          for (final element in issue.elements) {
            buffer.writeln('- $element');
          }
          buffer.writeln();
        }
      }
    } else {
      buffer.writeln('## No accessibility issues found');
    }
    
    return buffer.toString();
  }
}

@freezed
class AccessibilityIssue with _$AccessibilityIssue {
  const factory AccessibilityIssue({
    required AccessibilitySeverity severity,
    required AccessibilityIssueType type,
    required String description,
    required String recommendation,
    @Default([]) List<String> elements,
  }) = _AccessibilityIssue;
}

enum AccessibilitySeverity { error, warning, info }

enum AccessibilityIssueType {
  missingLabel,
  smallTouchTarget,
  lowContrast,
  missingSemantics,
  keyboardNavigation,
  focusManagement,
}
```

## 5. Performance and Optimization

### 5.1 Animation Performance Best Practices

```dart
// Optimized animation controller pool
class AnimationControllerPool {
  static final Map<String, AnimationController> _controllers = {};
  static final Map<String, int> _refCounts = {};
  
  static AnimationController getController(
    String key,
    TickerProvider vsync, {
    required Duration duration,
    Duration? reverseDuration,
    double? value,
  }) {
    final existing = _controllers[key];
    if (existing != null) {
      _refCounts[key] = (_refCounts[key] ?? 0) + 1;
      return existing;
    }
    
    final controller = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      value: value,
      vsync: vsync,
    );
    
    _controllers[key] = controller;
    _refCounts[key] = 1;
    
    return controller;
  }
  
  static void releaseController(String key) {
    final refCount = _refCounts[key] ?? 0;
    if (refCount <= 1) {
      _controllers[key]?.dispose();
      _controllers.remove(key);
      _refCounts.remove(key);
    } else {
      _refCounts[key] = refCount - 1;
    }
  }
  
  static void disposeAll() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _refCounts.clear();
  }
}

// Optimized particle system
class OptimizedParticleSystem extends StatefulWidget {
  const OptimizedParticleSystem({
    super.key,
    required this.particleCount,
    required this.emissionRate,
    this.maxParticles = 100,
    this.particleLifetime = const Duration(seconds: 3),
  });

  final int particleCount;
  final double emissionRate; // particles per second
  final int maxParticles;
  final Duration particleLifetime;

  @override
  State<OptimizedParticleSystem> createState() => _OptimizedParticleSystemState();
}

class _OptimizedParticleSystemState extends State<OptimizedParticleSystem>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();
  Timer? _emissionTimer;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _startEmission();
    _controller.repeat();
  }

  void _startEmission() {
    _emissionTimer = Timer.periodic(
      Duration(milliseconds: (1000 / widget.emissionRate).round()),
      (_) => _addParticle(),
    );
  }

  void _addParticle() {
    if (_particles.length >= widget.maxParticles) return;
    
    _particles.add(Particle(
      position: Offset(_random.nextDouble() * 300, _random.nextDouble() * 300),
      velocity: Offset(
        (_random.nextDouble() - 0.5) * 100,
        (_random.nextDouble() - 0.5) * 100,
      ),
      color: Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        1.0,
      ),
      lifetime: widget.particleLifetime,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _updateParticles();
        return CustomPaint(
          painter: ParticlePainter(_particles),
          size: const Size(300, 300),
        );
      },
    );
  }

  void _updateParticles() {
    final now = DateTime.now();
    _particles.removeWhere((particle) {
      final age = now.difference(particle.createdAt);
      return age > particle.lifetime;
    });
    
    for (final particle in _particles) {
      particle.update();
    }
  }

  @override
  void dispose() {
    _emissionTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}

class Particle {
  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.lifetime,
    required this.createdAt,
  });

  Offset position;
  final Offset velocity;
  final Color color;
  final Duration lifetime;
  final DateTime createdAt;

  void update() {
    position = position + velocity * 0.016; // Assume 60 FPS
  }

  double get alpha {
    final age = DateTime.now().difference(createdAt);
    final progress = age.inMilliseconds / lifetime.inMilliseconds;
    return 1.0 - progress.clamp(0.0, 1.0);
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(this.particles);

  final List<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (final particle in particles) {
      paint.color = particle.color.withOpacity(particle.alpha);
      canvas.drawCircle(particle.position, 3.0, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.particles.length != particles.length;
  }
}

// Performance-optimized list rendering
class OptimizedGameList<T> extends StatefulWidget {
  const OptimizedGameList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.itemExtent,
    this.cacheExtent = 250.0,
    this.physics,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double? itemExtent;
  final double cacheExtent;
  final ScrollPhysics? physics;

  @override
  State<OptimizedGameList<T>> createState() => _OptimizedGameListState<T>();
}

class _OptimizedGameListState<T> extends State<OptimizedGameList<T>> {
  final ScrollController _scrollController = ScrollController();
  final Set<int> _visibleIndices = {};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      physics: widget.physics,
      cacheExtent: widget.cacheExtent,
      itemExtent: widget.itemExtent,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        _visibleIndices.add(index);
        
        return RepaintBoundary(
          key: ValueKey('item_$index'),
          child: widget.itemBuilder(context, widget.items[index], index),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

### 5.2 Memory Management for Complex UI

```dart
// Memory-efficient widget cache
class WidgetCache {
  static final Map<String, Widget> _cache = {};
  static const int _maxCacheSize = 50;
  static final Queue<String> _accessOrder = Queue<String>();
  
  static Widget? get(String key) {
    if (_cache.containsKey(key)) {
      // Move to end of access order
      _accessOrder.remove(key);
      _accessOrder.addLast(key);
      return _cache[key];
    }
    return null;
  }
  
  static void put(String key, Widget widget) {
    if (_cache.length >= _maxCacheSize) {
      // Remove least recently used
      final lru = _accessOrder.removeFirst();
      _cache.remove(lru);
    }
    
    _cache[key] = widget;
    _accessOrder.addLast(key);
  }
  
  static void clear() {
    _cache.clear();
    _accessOrder.clear();
  }
  
  static void remove(String key) {
    _cache.remove(key);
    _accessOrder.remove(key);
  }
}

// Memory-aware image loading
class MemoryAwareImageCache {
  static final Map<String, ui.Image> _cache = {};
  static int _currentMemoryUsage = 0;
  static const int _maxMemoryUsage = 50 * 1024 * 1024; // 50MB
  
  static Future<ui.Image?> loadImage(String url) async {
    if (_cache.containsKey(url)) {
      return _cache[url];
    }
    
    try {
      final completer = Completer<ui.Image>();
      final networkImage = NetworkImage(url);
      final imageStream = networkImage.resolve(ImageConfiguration.empty);
      
      imageStream.addListener(ImageStreamListener((info, _) {
        final image = info.image;
        final memoryUsage = _estimateImageMemoryUsage(image);
        
        // Check if adding this image would exceed memory limit
        if (_currentMemoryUsage + memoryUsage > _maxMemoryUsage) {
          _evictLeastRecentlyUsed();
        }
        
        _cache[url] = image;
        _currentMemoryUsage += memoryUsage;
        completer.complete(image);
      }, onError: (error, stackTrace) {
        completer.completeError(error);
      }));
      
      return await completer.future;
    } catch (e) {
      return null;
    }
  }
  
  static int _estimateImageMemoryUsage(ui.Image image) {
    return image.width * image.height * 4; // RGBA = 4 bytes per pixel
  }
  
  static void _evictLeastRecentlyUsed() {
    if (_cache.isNotEmpty) {
      final firstKey = _cache.keys.first;
      final image = _cache.remove(firstKey);
      if (image != null) {
        _currentMemoryUsage -= _estimateImageMemoryUsage(image);
        image.dispose();
      }
    }
  }
  
  static void clearCache() {
    for (final image in _cache.values) {
      image.dispose();
    }
    _cache.clear();
    _currentMemoryUsage = 0;
  }
}

// Disposable resource manager
class ResourceManager {
  static final Map<String, DisposableResource> _resources = {};
  
  static T register<T extends DisposableResource>(String key, T resource) {
    _resources[key]?.dispose();
    _resources[key] = resource;
    return resource;
  }
  
  static void dispose(String key) {
    _resources[key]?.dispose();
    _resources.remove(key);
  }
  
  static void disposeAll() {
    for (final resource in _resources.values) {
      resource.dispose();
    }
    _resources.clear();
  }
}

abstract class DisposableResource {
  void dispose();
}

class AudioResourceManager extends DisposableResource {
  final Map<String, AudioPlayer> _players = {};
  
  AudioPlayer getPlayer(String key) {
    return _players.putIfAbsent(key, () => AudioPlayer());
  }
  
  @override
  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}
```

### 5.3 Asset Optimization Strategies

```dart
// Asset optimization service
class AssetOptimizationService {
  static const Map<String, String> _assetMappings = {
    'ingredient_chips': 'images/ingredients/chips.webp',
    'cauldron_base': 'images/game/cauldron.webp',
    'particle_texture': 'images/effects/particle.webp',
    'ui_background': 'images/ui/background.webp',
  };
  
  static const Map<String, List<String>> _responsiveAssets = {
    'splash_background': [
      'images/splash/bg_1x.webp',
      'images/splash/bg_2x.webp',
      'images/splash/bg_3x.webp',
    ],
    'game_board': [
      'images/game/board_small.webp',
      'images/game/board_medium.webp',
      'images/game/board_large.webp',
    ],
  };
  
  static String getAssetPath(String key, {double? devicePixelRatio}) {
    final responsiveAssets = _responsiveAssets[key];
    if (responsiveAssets != null && devicePixelRatio != null) {
      if (devicePixelRatio >= 3.0) return responsiveAssets[2];
      if (devicePixelRatio >= 2.0) return responsiveAssets[1];
      return responsiveAssets[0];
    }
    
    return _assetMappings[key] ?? 'images/placeholder.webp';
  }
  
  static Future<void> preloadAssets(BuildContext context) async {
    final mediaQuery = MediaQuery.of(context);
    final devicePixelRatio = mediaQuery.devicePixelRatio;
    
    final futures = <Future>[];
    
    // Preload essential assets
    final essentialAssets = [
      'ingredient_chips',
      'cauldron_base',
      'ui_background',
    ];
    
    for (final asset in essentialAssets) {
      final path = getAssetPath(asset, devicePixelRatio: devicePixelRatio);
      futures.add(precacheImage(AssetImage(path), context));
    }
    
    await Future.wait(futures);
  }
  
  static Future<void> preloadGameAssets(BuildContext context) async {
    final mediaQuery = MediaQuery.of(context);
    final devicePixelRatio = mediaQuery.devicePixelRatio;
    
    // Preload game-specific assets
    final gameAssets = [
      'game_board',
      'particle_texture',
    ];
    
    final futures = <Future>[];
    for (final asset in gameAssets) {
      final path = getAssetPath(asset, devicePixelRatio: devicePixelRatio);
      futures.add(precacheImage(AssetImage(path), context));
    }
    
    await Future.wait(futures);
  }
}

// Lazy loading image widget
class LazyLoadingImage extends StatefulWidget {
  const LazyLoadingImage({
    super.key,
    required this.assetKey,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
  });

  final String assetKey;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;

  @override
  State<LazyLoadingImage> createState() => _LazyLoadingImageState();
}

class _LazyLoadingImageState extends State<LazyLoadingImage> {
  bool _isVisible = false;
  
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.assetKey),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: _isVisible ? _buildImage() : _buildPlaceholder(),
    );
  }

  Widget _buildImage() {
    final mediaQuery = MediaQuery.of(context);
    final path = AssetOptimizationService.getAssetPath(
      widget.assetKey,
      devicePixelRatio: mediaQuery.devicePixelRatio,
    );
    
    return Image.asset(
      path,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      cacheWidth: widget.width?.round(),
      cacheHeight: widget.height?.round(),
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return widget.placeholder ?? Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// Asset bundling configuration
class AssetBundleConfig {
  static const Map<String, List<String>> bundles = {
    'essential': [
      'images/ui/background.webp',
      'images/ui/logo.webp',
      'fonts/Caudex-Regular.ttf',
      'fonts/Caveat-Regular.ttf',
    ],
    'game_core': [
      'images/game/cauldron.webp',
      'images/game/board_medium.webp',
      'images/ingredients/chips.webp',
      'sounds/game/bubble.mp3',
    ],
    'effects': [
      'images/effects/particle.webp',
      'images/effects/explosion.webp',
      'sounds/effects/pop.mp3',
      'sounds/effects/magic.mp3',
    ],
    'tutorial': [
      'images/tutorial/step1.webp',
      'images/tutorial/step2.webp',
      'images/tutorial/step3.webp',
      'sounds/tutorial/voice1.mp3',
    ],
  };
  
  static Future<void> preloadBundle(String bundleName, BuildContext context) async {
    final assets = bundles[bundleName];
    if (assets == null) return;
    
    final futures = <Future>[];
    for (final asset in assets) {
      if (asset.startsWith('images/')) {
        futures.add(precacheImage(AssetImage(asset), context));
      }
      // Note: Audio preloading would be handled separately
    }
    
    await Future.wait(futures);
  }
}
```

### 5.4 Network Request Optimization

```dart
// Optimized HTTP client with caching and retry logic
class OptimizedHttpClient {
  static final Dio _dio = Dio();
  static final Map<String, CachedResponse> _cache = {};
  
  static void initialize() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent': 'Calderum/1.0',
      },
    );
    
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      options: const RetryOptions(
        retries: 3,
        retryInterval: Duration(seconds: 1),
      ),
    ));
    
    _dio.interceptors.add(CacheInterceptor());
  }
  
  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useCache = true,
    Duration? cacheDuration,
  }) async {
    final cacheKey = _generateCacheKey(path, queryParameters);
    
    if (useCache) {
      final cached = _getCachedResponse(cacheKey, cacheDuration);
      if (cached != null) {
        return Response<T>(
          data: cached.data,
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
        );
      }
    }
    
    final response = await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
    
    if (useCache && response.statusCode == 200) {
      _cacheResponse(cacheKey, response.data, cacheDuration);
    }
    
    return response;
  }
  
  static Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  static String _generateCacheKey(String path, Map<String, dynamic>? params) {
    final buffer = StringBuffer(path);
    if (params != null) {
      buffer.write('?');
      buffer.write(params.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&'));
    }
    return buffer.toString();
  }
  
  static CachedResponse? _getCachedResponse(String key, Duration? maxAge) {
    final cached = _cache[key];
    if (cached == null) return null;
    
    final age = DateTime.now().difference(cached.timestamp);
    final maxAgeToUse = maxAge ?? const Duration(minutes: 5);
    
    if (age > maxAgeToUse) {
      _cache.remove(key);
      return null;
    }
    
    return cached;
  }
  
  static void _cacheResponse(String key, dynamic data, Duration? ttl) {
    _cache[key] = CachedResponse(
      data: data,
      timestamp: DateTime.now(),
      ttl: ttl ?? const Duration(minutes: 5),
    );
    
    // Clean up old cache entries
    _cleanupCache();
  }
  
  static void _cleanupCache() {
    final now = DateTime.now();
    _cache.removeWhere((key, value) {
      final age = now.difference(value.timestamp);
      return age > value.ttl;
    });
  }
}

class CachedResponse {
  const CachedResponse({
    required this.data,
    required this.timestamp,
    required this.ttl,
  });

  final dynamic data;
  final DateTime timestamp;
  final Duration ttl;
}

class CacheInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add cache control headers
    options.headers['Cache-Control'] = 'max-age=300';
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log successful responses for debugging
    print('✅ ${response.requestOptions.method} ${response.requestOptions.path} - ${response.statusCode}');
    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ${err.requestOptions.method} ${err.requestOptions.path} - ${err.response?.statusCode ?? 'Unknown'}');
    handler.next(err);
  }
}

// Firebase optimization for game data
class OptimizedFirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Map<String, StreamSubscription> _activeListeners = {};
  
  static Stream<QuerySnapshot<T>> getOptimizedCollection<T>(
    String path,
    FirestoreDataConverter<T> converter, {
    int? limit,
    List<Object?>? startAfter,
    bool useCache = true,
  }) {
    final collection = _firestore
        .collection(path)
        .withConverter(
          fromFirestore: converter.fromFirestore,
          toFirestore: converter.toFirestore,
        );
    
    Query<T> query = collection;
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter as DocumentSnapshot);
    }
    
    final source = useCache ? Source.cache : Source.server;
    
    return query.snapshots(
      includeMetadataChanges: false,
    );
  }
  
  static Future<void> batchWrite(List<BatchOperation> operations) async {
    final batch = _firestore.batch();
    
    for (final operation in operations) {
      switch (operation.type) {
        case BatchOperationType.set:
          batch.set(operation.reference, operation.data);
          break;
        case BatchOperationType.update:
          batch.update(operation.reference, operation.data);
          break;
        case BatchOperationType.delete:
          batch.delete(operation.reference);
          break;
      }
    }
    
    await batch.commit();
  }
  
  static void disposeListener(String key) {
    _activeListeners[key]?.cancel();
    _activeListeners.remove(key);
  }
  
  static void disposeAllListeners() {
    for (final subscription in _activeListeners.values) {
      subscription.cancel();
    }
    _activeListeners.clear();
  }
}

class BatchOperation {
  const BatchOperation({
    required this.type,
    required this.reference,
    required this.data,
  });

  final BatchOperationType type;
  final DocumentReference reference;
  final Map<String, dynamic> data;
}

enum BatchOperationType { set, update, delete }
```

### 5.5 Caching Strategies for Game Data

```dart
// Layered cache system for game data
class GameDataCache {
  static final MemoryCache _memoryCache = MemoryCache();
  static final PersistentCache _persistentCache = PersistentCache();
  static const Duration _defaultTTL = Duration(minutes: 30);
  
  static Future<T?> get<T>(
    String key, {
    Duration? ttl,
    bool checkPersistent = true,
  }) async {
    // Check memory cache first
    final memoryResult = _memoryCache.get<T>(key);
    if (memoryResult != null) {
      return memoryResult;
    }
    
    // Check persistent cache
    if (checkPersistent) {
      final persistentResult = await _persistentCache.get<T>(key, ttl: ttl);
      if (persistentResult != null) {
        // Populate memory cache for faster future access
        _memoryCache.set(key, persistentResult, ttl ?? _defaultTTL);
        return persistentResult;
      }
    }
    
    return null;
  }
  
  static Future<void> set<T>(
    String key,
    T value, {
    Duration? ttl,
    bool persistToDisk = true,
  }) async {
    final ttlToUse = ttl ?? _defaultTTL;
    
    // Always set in memory cache
    _memoryCache.set(key, value, ttlToUse);
    
    // Optionally persist to disk
    if (persistToDisk) {
      await _persistentCache.set(key, value, ttlToUse);
    }
  }
  
  static Future<void> invalidate(String key) async {
    _memoryCache.remove(key);
    await _persistentCache.remove(key);
  }
  
  static Future<void> clear() async {
    _memoryCache.clear();
    await _persistentCache.clear();
  }
}

class MemoryCache {
  final Map<String, CacheEntry> _cache = {};
  static const int _maxEntries = 100;
  
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    
    return entry.value as T;
  }
  
  void set<T>(String key, T value, Duration ttl) {
    if (_cache.length >= _maxEntries) {
      _evictOldest();
    }
    
    _cache[key] = CacheEntry(
      value: value,
      expiresAt: DateTime.now().add(ttl),
    );
  }
  
  void remove(String key) {
    _cache.remove(key);
  }
  
  void clear() {
    _cache.clear();
  }
  
  void _evictOldest() {
    DateTime? oldestTime;
    String? oldestKey;
    
    for (final entry in _cache.entries) {
      if (oldestTime == null || entry.value.expiresAt.isBefore(oldestTime)) {
        oldestTime = entry.value.expiresAt;
        oldestKey = entry.key;
      }
    }
    
    if (oldestKey != null) {
      _cache.remove(oldestKey);
    }
  }
}

class PersistentCache {
  static SharedPreferences? _prefs;
  
  Future<SharedPreferences> get prefs async {
    return _prefs ??= await SharedPreferences.getInstance();
  }
  
  Future<T?> get<T>(String key, {Duration? ttl}) async {
    final sharedPrefs = await prefs;
    final data = sharedPrefs.getString('cache_$key');
    
    if (data == null) return null;
    
    try {
      final Map<String, dynamic> json = jsonDecode(data);
      final expiresAt = DateTime.parse(json['expiresAt']);
      
      if (DateTime.now().isAfter(expiresAt)) {
        await remove(key);
        return null;
      }
      
      return _deserialize<T>(json['value']);
    } catch (e) {
      await remove(key);
      return null;
    }
  }
  
  Future<void> set<T>(String key, T value, Duration ttl) async {
    final sharedPrefs = await prefs;
    final data = {
      'value': _serialize(value),
      'expiresAt': DateTime.now().add(ttl).toIso8601String(),
    };
    
    await sharedPrefs.setString('cache_$key', jsonEncode(data));
  }
  
  Future<void> remove(String key) async {
    final sharedPrefs = await prefs;
    await sharedPrefs.remove('cache_$key');
  }
  
  Future<void> clear() async {
    final sharedPrefs = await prefs;
    final keys = sharedPrefs.getKeys()
        .where((key) => key.startsWith('cache_'));
    
    for (final key in keys) {
      await sharedPrefs.remove(key);
    }
  }
  
  dynamic _serialize<T>(T value) {
    if (value is String || value is num || value is bool) {
      return value;
    } else if (value is Map || value is List) {
      return value;
    } else {
      // For complex objects, assume they have toJson method
      return (value as dynamic).toJson();
    }
  }
  
  T? _deserialize<T>(dynamic value) {
    // This would need type-specific deserialization logic
    // For now, return as-is
    return value as T?;
  }
}

class CacheEntry {
  const CacheEntry({
    required this.value,
    required this.expiresAt,
  });

  final dynamic value;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

// Game-specific cache strategies
class GameStateCacheStrategy {
  static const String _playerDataKey = 'player_data';
  static const String _roomDataKey = 'room_data';
  static const String _gameRulesKey = 'game_rules';
  
  static Future<PlayerData?> getPlayerData(String playerId) async {
    return await GameDataCache.get<PlayerData>(
      '${_playerDataKey}_$playerId',
      ttl: const Duration(minutes: 15),
    );
  }
  
  static Future<void> cachePlayerData(String playerId, PlayerData data) async {
    await GameDataCache.set(
      '${_playerDataKey}_$playerId',
      data,
      ttl: const Duration(minutes: 15),
    );
  }
  
  static Future<RoomData?> getRoomData(String roomId) async {
    return await GameDataCache.get<RoomData>(
      '${_roomDataKey}_$roomId',
      ttl: const Duration(minutes: 5), // Rooms change frequently
    );
  }
  
  static Future<void> cacheRoomData(String roomId, RoomData data) async {
    await GameDataCache.set(
      '${_roomDataKey}_$roomId',
      data,
      ttl: const Duration(minutes: 5),
    );
  }
  
  static Future<GameRules?> getGameRules() async {
    return await GameDataCache.get<GameRules>(
      _gameRulesKey,
      ttl: const Duration(hours: 24), // Rules don't change often
    );
  }
  
  static Future<void> cacheGameRules(GameRules rules) async {
    await GameDataCache.set(
      _gameRulesKey,
      rules,
      ttl: const Duration(hours: 24),
    );
  }
}
```

This comprehensive implementation framework provides developers with all the tools needed to effectively implement the Calderum design system. Each component maintains the magical theme while providing intuitive, accessible interactions that make the complex Quacks of Quedlinburg mechanics enjoyable and approachable for all players.