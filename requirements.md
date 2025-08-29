# Calderum Requirements Document

## Executive Summary
Calderum is a digital adaptation of The Quacks of Quedlinburg, a push-your-luck bag-building board game where players compete as alchemists brewing magical potions. The game features 9 rounds of simultaneous potion brewing, strategic ingredient purchasing, and dynamic multiplayer rooms that allow players to join and leave games flexibly. Built exclusively on Firebase infrastructure with Flutter, it emphasizes social play through friend systems and achievements while maintaining the engaging risk-reward mechanics of the original board game.

## Functional Requirements

### 1. User Management

#### 1.0 Onboarding
- **FR-ONBOARD-001**: System must display 4 welcome screens on first launch
- **FR-ONBOARD-002**: Users must be able to skip onboarding at any point
- **FR-ONBOARD-003**: System must track onboarding completion
- **FR-ONBOARD-004**: Onboarding must explain core game mechanics

#### 1.1 Authentication
- **FR-AUTH-001**: Users must be able to register with email and password
- **FR-AUTH-002**: Users must be able to sign in with existing credentials
- **FR-AUTH-003**: Users must be able to reset forgotten passwords via email
- **FR-AUTH-004**: Users must be able to sign in with Google OAuth
- **FR-AUTH-005**: System must maintain secure session management
- **FR-AUTH-006**: Users must be able to sign out from any screen

#### 1.2 Profile Management
- **FR-PROF-001**: Users must be able to set and update display name
- **FR-PROF-002**: Users must be able to upload and change profile picture
- **FR-PROF-003**: System must track user statistics (games played, won, points)
- **FR-PROF-004**: Users must be able to view their game history
- **FR-PROF-005**: Users must be able to delete their account
- **FR-PROF-006**: System must calculate and display win rate

### 2. Game Room Management

#### 2.1 Room Creation
- **FR-ROOM-001**: Users must be able to create private game rooms
- **FR-ROOM-002**: Room creator must be able to set game parameters
  - Number of rounds: 9 (fixed per game rules)
  - Turn timer (15s, 30s, 45s, or unlimited)
  - Ingredient Set (Set 1, Set 2, Set 3, Set 4, or Custom)
  - Test Tube variant (On/Off)
- **FR-ROOM-003**: System must generate unique 6-character room codes
- **FR-ROOM-004**: Rooms must support 2-4 players
- **FR-ROOM-005**: Users must be able to invite friends to rooms

#### 2.2 Dynamic Room Joining
- **FR-JOIN-001**: Users must be able to join rooms via invitation
- **FR-JOIN-002**: Users must be able to join rooms via room code
- **FR-JOIN-003**: Users must be able to rejoin rooms they are part of
- **FR-JOIN-004**: System must maintain player membership across disconnections
- **FR-JOIN-005**: Players must be able to leave rooms temporarily without forfeiting
- **FR-JOIN-006**: Games must continue when players are temporarily absent
- **FR-JOIN-007**: System must notify players when it's their turn (even if offline)

#### 2.3 Lobby Features
- **FR-LOBBY-001**: Players must see all participants in room with online/offline status
- **FR-LOBBY-002**: Players must be able to indicate ready status
- **FR-LOBBY-003**: Host must be able to remove players permanently from room
- **FR-LOBBY-004**: Host must be able to start game when minimum players ready (2+)
- **FR-LOBBY-005**: Players must be able to chat in lobby
- **FR-LOBBY-006**: System must show real-time player connection status
- **FR-LOBBY-007**: System must preserve lobby state across player disconnections
- **FR-LOBBY-008**: Players must be able to join ongoing games during lobby phase

### 3. Core Game Mechanics

#### 3.1 Game Setup
- **FR-GAME-001**: System must initialize player pots with droplet on space 0
- **FR-GAME-002**: System must distribute starting bag contents (4×white-1, 2×white-2, 1×white-3, 1×orange-1, 1×green-1)
- **FR-GAME-003**: System must place all scoring markers on seal tiles (0 points)
- **FR-GAME-004**: System must determine first player (random or by rule)
- **FR-GAME-005**: System must setup ingredient books based on chosen set (1-4)
- **FR-GAME-006**: System must initialize flasks (full) and rat stones on trivets
- **FR-GAME-007**: System must create Fortune Teller deck and place turn marker on round 1

#### 3.2 Turn Structure (9 Rounds)
- **FR-TURN-001**: System must execute Fortune Teller card phase each turn
- **FR-TURN-002**: System must execute Rats phase (turns 2-9) with catch-up mechanism
- **FR-TURN-003**: System must execute simultaneous Potions phase
- **FR-TURN-004**: System must execute Evaluation phases A through F in order
- **FR-TURN-005**: System must reveal yellow book before turn 2, purple book before turn 3
- **FR-TURN-006**: System must add extra white chip to all bags before turn 6

#### 3.3 Potions Phase (Simultaneous Brewing)
- **FR-BREW-001**: Players must draw chips blindly from their bags
- **FR-BREW-002**: System must place chips according to value (1-chip=1 space, 2-chip=2 spaces, etc.)
- **FR-BREW-003**: System must leave empty spaces between placed chips
- **FR-BREW-004**: Players must be able to stop voluntarily after any chip
- **FR-BREW-005**: System must trigger explosion when white chip total ≥ 8
- **FR-BREW-006**: System must allow flask usage (return last white chip to bag, once per turn)
- **FR-BREW-007**: System must prevent flask use if explosion occurs
- **FR-BREW-008**: System must apply immediate chip effects (Blue, Red, Yellow on draw)

#### 3.4 Evaluation Phases
- **FR-EVAL-001**: Phase A - Bonus Die: Highest non-exploded player(s) roll die
- **FR-EVAL-002**: Phase B - Chip Actions: Resolve Green, Purple, Black chip effects
- **FR-EVAL-003**: Phase C - Rubies: Award rubies from scoring spaces
- **FR-EVAL-004**: Phase D - Victory Points: Award points from scoring spaces
- **FR-EVAL-005**: Phase E - Buy Chips: Purchase 1-2 different colored chips with coins
- **FR-EVAL-006**: Phase F - End Turn: Ruby spending, flask refill, pass cards
- **FR-EVAL-007**: Exploded players choose either Phase D OR E (not both)

#### 3.5 Ingredient Effects
- **FR-ING-001**: White chips count toward explosion (≥8 total), no other effects
- **FR-ING-002**: Orange chips have no special effects (basic ingredient)
- **FR-ING-003**: Green chips provide end-phase bonuses based on ingredient set and position
- **FR-ING-004**: Blue chips allow drawing extra chips on placement, keep one
- **FR-ING-005**: Red chips move droplet forward immediately when drawn
- **FR-ING-006**: Yellow chips have set-specific effects when drawn/placed
- **FR-ING-007**: Purple chips provide set-specific special abilities
- **FR-ING-008**: Black chips have set-specific negative effects
- **FR-ING-009**: System must support 4 different ingredient sets with varying effects

#### 3.6 Game End and Scoring
- **FR-SCORE-001**: Game ends after 9 complete rounds
- **FR-SCORE-002**: Scoring space = space immediately after last placed chip
- **FR-SCORE-003**: Victory points awarded based on pot space values (not chip values)
- **FR-SCORE-004**: Winner determined by highest total victory points on track
- **FR-SCORE-005**: Tiebreaker: Player with most chips in pot during final turn
- **FR-SCORE-006**: System must track coins earned (equal to scoring space number)
- **FR-SCORE-007**: Final turn allows purchasing victory points (5 coins or 2 rubies = 1 VP)

### 4. Multiplayer Features

#### 4.1 Real-time Synchronization
- **FR-SYNC-001**: All players must see same game state
- **FR-SYNC-002**: Actions must propagate within 500ms
- **FR-SYNC-003**: System must handle connection drops gracefully
- **FR-SYNC-004**: System must support reconnection
- **FR-SYNC-005**: System must prevent cheating/tampering

#### 4.2 Phase Management
- **FR-PHASE-001**: System must coordinate simultaneous Potions phase
- **FR-PHASE-002**: System must show all players' brewing progress in real-time
- **FR-PHASE-003**: System must handle disconnected players during simultaneous phase
- **FR-PHASE-004**: System must enforce evaluation phase order (starting with first player)
- **FR-PHASE-005**: System must enforce phase time limits
- **FR-PHASE-006**: System must show phase indicators (Fortune Teller, Rats, Potions, Evaluation)

#### 4.3 Communication
- **FR-COMM-001**: Players must be able to send emotes/reactions
- **FR-COMM-002**: System must support predefined reaction buttons (like, surprise, laugh, etc.)
- **FR-COMM-003**: Players must be able to mute other players' reactions
- **FR-COMM-004**: System must show player reactions with visual feedback

### 5. Game Progression

#### 5.1 Rounds
- **FR-ROUND-001**: Games must progress through 9 rounds (fixed per game rules)
- **FR-ROUND-002**: System must clear pots between rounds (reset to droplet position)
- **FR-ROUND-003**: System must show round transitions with current round indicator
- **FR-ROUND-004**: System must update victory point scores after each round

#### 5.2 End Game
- **FR-END-001**: System must determine final rankings
- **FR-END-002**: System must show detailed score breakdown
- **FR-END-003**: Players must be able to rematch with same players
- **FR-END-004**: System must update player statistics (games played, won, total points)

### 6. Social Features

#### 6.1 Friends System
- **FR-FRIEND-001**: Users must be able to add friends
- **FR-FRIEND-002**: Users must be able to invite friends to games
- **FR-FRIEND-003**: Users must see friends' online status
- **FR-FRIEND-004**: Users must be able to view friends' profiles
- **FR-FRIEND-005**: Users must be able to remove friends
- **FR-FRIEND-006**: System must recommend recent players when creating rooms
- **FR-FRIEND-007**: Players must be able to add recent opponents as friends during/after matches
- **FR-FRIEND-008**: Friends must appear first in player recommendation lists


### 7. Progression System

#### 7.1 Experience (Backend Only)
- **FR-EXP-001**: System must track XP earned for games played (backend only)
- **FR-EXP-002**: System must award bonus XP for wins (backend only)
- **FR-EXP-003**: System must calculate and store player levels (backend only)
- **FR-EXP-004**: System must prepare reward unlock system for future UI (backend only)
- **FR-EXP-005**: XP system must be ready for future UI implementation

#### 7.2 Achievements
- **FR-ACH-001**: System must track achievement unlocks:
  - First Victory (win 1 match)
  - Seasoned Alchemist (win 10 matches)
  - Master Brewer (win 100 matches)
  - White Chip Master (avoid explosion with 7 white chips)
  - Orange Specialist (fill 20+ spaces with orange chips in one game)
  - Green Expert (maximize green chip bonuses in one round)
  - Blue Strategist (use blue chip draws effectively)
  - Red Risk-Taker (use red chips to reach space 30+)
  - Yellow Collector (purchase multiple yellow chips)
  - Purple Magician (utilize purple abilities effectively)
  - Black Survivor (win despite black chip penalties)
- **FR-ACH-002**: System must display achievement unlock notifications
- **FR-ACH-003**: Players must be able to view their achievement gallery
- **FR-ACH-004**: Achievements must be visible on friend profiles
- **FR-ACH-005**: System must track achievement progress in backend

## Non-Functional Requirements

### 1. Performance

#### 1.1 Response Time
- **NFR-PERF-001**: Page load time < 3 seconds
- **NFR-PERF-002**: Game action response < 100ms
- **NFR-PERF-003**: Animation frame rate >= 30fps
- **NFR-PERF-004**: Server API response < 500ms
- **NFR-PERF-005**: Real-time sync latency < 200ms

#### 1.2 Capacity
- **NFR-CAP-001**: Support 10,000 concurrent users
- **NFR-CAP-002**: Support 2,500 concurrent games
- **NFR-CAP-003**: Handle 100 requests/second per game
- **NFR-CAP-004**: Store 1 million user profiles
- **NFR-CAP-005**: Maintain 6 months game history

### 2. Reliability

#### 2.1 Availability
- **NFR-AVAIL-001**: 99.9% uptime SLA
- **NFR-AVAIL-002**: Scheduled maintenance < 4 hours/month
- **NFR-AVAIL-003**: Automatic failover < 30 seconds
- **NFR-AVAIL-004**: Data backup every 6 hours
- **NFR-AVAIL-005**: Disaster recovery < 4 hours

#### 2.2 Fault Tolerance
- **NFR-FAULT-001**: Graceful degradation on service failure
- **NFR-FAULT-002**: Automatic reconnection on network issues
- **NFR-FAULT-003**: Game state persistence across crashes
- **NFR-FAULT-004**: No data loss on unexpected shutdown
- **NFR-FAULT-005**: Circuit breakers for external services

### 3. Security

#### 3.1 Authentication & Authorization
- **NFR-SEC-001**: Passwords hashed with bcrypt (12+ rounds)
- **NFR-SEC-002**: JWT tokens with 24-hour expiry
- **NFR-SEC-003**: OAuth 2.0 for third-party auth
- **NFR-SEC-004**: Role-based access control
- **NFR-SEC-005**: Multi-factor authentication option

#### 3.2 Data Protection
- **NFR-DATA-001**: TLS 1.3 for all communications
- **NFR-DATA-002**: Encryption at rest for sensitive data
- **NFR-DATA-003**: PII data anonymization
- **NFR-DATA-004**: GDPR compliance
- **NFR-DATA-005**: Regular security audits

#### 3.3 Game Integrity
- **NFR-GAME-001**: Server-side validation of all moves
- **NFR-GAME-002**: Anti-cheat detection systems
- **NFR-GAME-003**: Rate limiting on API calls
- **NFR-GAME-004**: Replay system for dispute resolution
- **NFR-GAME-005**: Randomness verification

### 4. Usability

#### 4.1 Accessibility
- **NFR-ACCESS-001**: WCAG 2.1 AA compliance
- **NFR-ACCESS-002**: Screen reader support
- **NFR-ACCESS-003**: Keyboard navigation
- **NFR-ACCESS-004**: Color blind friendly modes
- **NFR-ACCESS-005**: Adjustable text size

#### 4.2 User Experience
- **NFR-UX-001**: Onboarding screens completion > 80%
- **NFR-UX-002**: Average session length > 15 minutes
- **NFR-UX-003**: User retention D7 > 40%
- **NFR-UX-004**: Support for 10+ languages
- **NFR-UX-005**: Context-sensitive help

### 5. Compatibility

#### 5.1 Platform Support
- **NFR-PLAT-001**: iOS 13.0+
- **NFR-PLAT-002**: Android 7.0+ (API 24)
- **NFR-PLAT-003**: Chrome, Safari, Firefox, Edge (latest 2 versions)
- **NFR-PLAT-004**: Responsive design 320px to 4K
- **NFR-PLAT-005**: Progressive Web App support

#### 5.2 Device Requirements
- **NFR-DEV-001**: Minimum RAM: 2GB
- **NFR-DEV-002**: Minimum storage: 100MB
- **NFR-DEV-003**: Network: 3G or better
- **NFR-DEV-004**: Touch and mouse input
- **NFR-DEV-005**: Portrait and landscape modes

### 6. Maintainability

#### 6.1 Code Quality
- **NFR-CODE-001**: Test coverage > 80%
- **NFR-CODE-002**: Documentation for all public APIs
- **NFR-CODE-003**: Linting score > 95%
- **NFR-CODE-004**: Cyclomatic complexity < 10
- **NFR-CODE-005**: Automated CI/CD pipeline

#### 6.2 Monitoring
- **NFR-MON-001**: Real-time error tracking
- **NFR-MON-002**: Performance metrics dashboard
- **NFR-MON-003**: User behavior analytics
- **NFR-MON-004**: Automated alerting system
- **NFR-MON-005**: Audit logs for all actions

## Technical Requirements

### 1. Architecture

#### 1.1 Frontend
- **TR-FE-001**: Flutter SDK 3.35.2+
- **TR-FE-002**: Dart 3.9.0+
- **TR-FE-003**: Riverpod state management
- **TR-FE-004**: Go_router for navigation
- **TR-FE-005**: Freezed for immutable models

#### 1.2 Backend
- **TR-BE-001**: Firebase Authentication
- **TR-BE-002**: Cloud Firestore for data
- **TR-BE-003**: Firebase Realtime Database for game state
- **TR-BE-004**: Cloud Functions for game logic
- **TR-BE-005**: Firebase Storage for media

#### 1.3 Infrastructure
- **TR-INF-001**: Firebase Hosting for web deployment
- **TR-INF-002**: Firebase CDN (built-in with Hosting)
- **TR-INF-003**: Firebase Realtime Database for real-time sync
- **TR-INF-004**: Cloud Functions for serverless backend logic
- **TR-INF-005**: Firebase Performance Monitoring

### 2. Data Requirements

#### 2.1 Storage
- **TR-DATA-001**: User profiles in Firestore
- **TR-DATA-002**: Game states in Realtime Database
- **TR-DATA-003**: Match history in Firestore
- **TR-DATA-004**: Media files in Cloud Storage
- **TR-DATA-005**: Analytics in BigQuery

#### 2.2 Schemas
```
User {
  uid: string
  email: string
  displayName: string
  photoUrl: string
  level: number  // Backend only for now
  experience: number  // Backend only for now
  gamesPlayed: number
  gamesWon: number
  totalPoints: number
  achievements: array<AchievementId>
  friends: array<UserId>
  recentPlayers: array<UserId>
  createdAt: timestamp
  lastLogin: timestamp
}

GameRoom {
  roomId: string
  roomCode: string
  hostId: string
  players: array<Player>
  settings: {
    ingredientSet: 1-4
    testTubeVariant: boolean
    turnTimer: number
  }
  state: enum (lobby, playing, finished)
  currentRound: number (1-9)
  createdAt: timestamp
  startedAt: timestamp
}

GameState {
  gameId: string
  round: number (1-9)
  phase: enum (fortuneTeller, rats, potions, evaluation)
  currentEvalPhase: string (A-F)
  firstPlayer: string
  pots: map<playerId, Pot>
  bags: map<playerId, array<Chip>>
  scores: map<playerId, number>
  rubies: map<playerId, number>
  flasks: map<playerId, boolean>
  timeRemaining: number
}
```

### 3. Integration Requirements

#### 3.1 Third-Party Services (Firebase Ecosystem)
- **TR-INT-001**: Google Sign-In OAuth (Firebase Auth)
- **TR-INT-002**: Firebase Analytics for user behavior tracking
- **TR-INT-003**: Firebase Crashlytics for crash reporting
- **TR-INT-004**: Firebase Cloud Messaging for push notifications
- **TR-INT-005**: Firebase Remote Config for feature flags

#### 3.2 APIs (Firebase-based)
- **TR-API-001**: Cloud Functions for serverless API endpoints
- **TR-API-002**: Firebase Realtime Database for real-time game sync
- **TR-API-003**: Firestore for complex queries and user data
- **TR-API-004**: Firebase Auth for authentication
- **TR-API-005**: Cloud Storage for media files

## Constraints

### 1. Business Constraints
- **BC-001**: Initial release within 6 months
- **BC-002**: Development budget optimized for Firebase costs
- **BC-003**: Team of 4 developers
- **BC-004**: Free-to-play model
- **BC-005**: COPPA compliance for 13+ age rating

### 2. Technical Constraints
- **TC-001**: Must use Firebase infrastructure exclusively
- **TC-002**: Optimize for Firebase free tier limits initially
- **TC-003**: Must handle offline/reconnection gracefully
- **TC-004**: Maximum 50MB app download size
- **TC-005**: Must maintain backward compatibility

### 3. Regulatory Constraints
- **RC-001**: GDPR compliance in EU
- **RC-002**: CCPA compliance in California
- **RC-003**: Apple App Store guidelines
- **RC-004**: Google Play Store policies
- **RC-005**: Age-appropriate design code

## Acceptance Criteria

### 1. Feature Complete
- All functional requirements implemented
- All non-functional requirements met
- Technical requirements satisfied
- No critical bugs in production

### 2. Quality Metrics
- Crash-free rate > 99.5%
- App store rating > 4.0
- Load time < 3 seconds
- Memory usage < 200MB
- Battery drain < 5%/hour

### 3. User Acceptance
- Beta testing with 100+ users
- Onboarding completion > 80%
- D7 retention > 40%
- Average session > 15 minutes
- NPS score > 50

## Dependencies

### 1. External Dependencies
- Firebase services availability
- App store approval process
- Third-party OAuth providers
- Internet connectivity
- Device capabilities

### 2. Internal Dependencies
- Design assets completion
- Backend API development
- Database schema finalization
- Security audit completion
- Marketing material preparation

## Assumptions

1. Users have stable internet connection for multiplayer
2. Firebase services maintain current SLA
3. Target devices meet minimum specifications
4. Users understand basic board game concepts
5. Firebase free tier sufficient for initial launch

## Risks

1. **Technical Risks**
   - Real-time sync performance issues
   - Scaling challenges with user growth
   - Platform-specific bugs

2. **Business Risks**
   - User acquisition costs
   - Competition from similar games
   - Player retention without monetization

3. **Compliance Risks**
   - Data privacy regulations
   - App store policy changes
   - Content rating requirements

## Success Metrics

1. **Launch Metrics**
   - 10,000 downloads in first month
   - 1,000 daily active users by month 3
   - 500 concurrent games supported

2. **Engagement Metrics**
   - Average 3 games per session
   - 50% weekly retention rate
   - 60% of players add friends
   - 40% achievement unlock rate

3. **Technical Metrics**
   - <1% crash rate
   - <500ms average latency
   - 99.9% uptime achieved
   - <3 second initial load time

This requirements document defines the complete scope for Calderum development, ensuring all stakeholders understand the project goals and constraints.