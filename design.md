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

### 3. Active Games Screen
```
┌─────────────────────────┐
│ [Header: Profile | Friends] │
│                         │
│   Welcome, [Username]   │
│   Games Won: 42         │
│                         │
│ [Create New Game]       │
│                         │
│ Active Games (3)        │
│ ┌─────────────────────┐ │
│ │ Room: Mystic Tower  │ │
│ │ Round 5/9           │ │
│ │ 🟢 Your Turn!       │ │
│ │ Players: 3/4 online │ │
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │
│ │ Room: Cauldron Club │ │
│ │ Round 7/9           │ │
│ │ ⏸️ Waiting...       │ │
│ │ Players: 2/3 online │ │
│ └─────────────────────┘ │
│                         │
│ [Completed Games]       │
└─────────────────────────┘
```

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