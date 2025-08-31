# Calderum Development Task Plan

## Project Timeline Overview
- **Total Duration**: 4 months (16 weeks)
- **Team Size**: 4 developers
- **Methodology**: Agile/Scrum with 2-week sprints
- **Current Status**: Authentication complete, ready for game development
- **Architecture**: Firebase-only (Firestore, Auth, Cloud Functions, Hosting)

## Development Phases

### Phase 0: Foundation ✅ COMPLETE
**Duration**: Complete
**Status**: Done

Completed Items:
- ✅ Project setup with Flutter 3.35.2
- ✅ Firebase integration and secure configuration
- ✅ Authentication system (email/password)
- ✅ User profile management
- ✅ Base UI components and theming
- ✅ Routing with go_router
- ✅ State management with Riverpod

### Phase 1: Core Game Infrastructure ✅ COMPLETE
**Duration**: 4 weeks (Sprints 1-2)
**Goal**: Establish multiplayer foundation and room management
**Status**: All tasks completed successfully

#### Sprint 1: Room Management Backend
**Week 1-2**

##### Backend Tasks
- [x] **TASK-BE-001**: Design Firestore schema for rooms ✅
  - Collections: rooms, room_members, room_settings
  - Security rules for room access
  - Composite indexes for queries
  - Estimate: 8 hours

- [x] **TASK-BE-002**: Implement room service ✅
  - Create room with unique code generation
  - Join room via code validation
  - Leave room and cleanup
  - Room capacity management
  - Duplicate room prevention
  - Estimate: 16 hours

- [x] **TASK-BE-003**: Real-time room state sync ✅
  - Firestore real-time listeners setup
  - Room state synchronization
  - Player presence system
  - Connection state handling
  - Estimate: 12 hours

- [x] **TASK-BE-004**: Room settings management ✅
  - Ingredient set selection (1-4)
  - Test tube variant toggle
  - Dynamic player count (2-4)
  - Settings dialog for hosts
  - Estimate: 8 hours

##### Frontend Tasks
- [x] **TASK-FE-001**: Create room model with Freezed ✅
  - Room data class
  - Room settings model
  - Player model for room context
  - Estimate: 4 hours

- [x] **TASK-FE-002**: Room management view models ✅
  - Create room view model
  - Join room view model
  - Room stream providers
  - Estimate: 8 hours

- [x] **TASK-FE-003**: Room creation UI ✅
  - Instant room creation
  - Settings configuration dialog
  - Room code display
  - Share functionality
  - Estimate: 12 hours

#### Sprint 2: Lobby and Dynamic Rooms
**Week 3-4**

##### Frontend Tasks
- [x] **TASK-FE-004**: Room lobby UI ✅
  - Player list display with online/offline status
  - Ready status indicators
  - Settings display and configuration
  - Room code sharing
  - Leave room functionality
  - Estimate: 16 hours

- [x] **TASK-FE-005**: Friend invitation system ✅
  - Friend list display with online status
  - Recent players display (auto-tracked from games)
  - Send invitation flow via share integration
  - Friend request system (send/accept/reject)
  - User search functionality
  - Estimate: 12 hours

- [x] **TASK-FE-006**: Dynamic room management ✅
  - Join room via code interface
  - Paste room code functionality
  - Auto-join on valid code
  - Player status indicators
  - Estimate: 8 hours

##### Backend Tasks
- [x] **TASK-BE-005**: Emote/reaction system ✅
  - Predefined emote set (10 emotes with emoji and labels)
  - Real-time emote broadcasting via Firestore
  - Emote rate limiting (2-second cooldown)
  - Auto-cleanup after 5 seconds
  - Estimate: 6 hours

- [x] **TASK-BE-006**: Dynamic room persistence ✅
  - Maintain game state for absent players
  - Handle rejoin logic with handleReconnection()
  - Player status tracking (online/offline)
  - Turn notification system ready
  - Estimate: 12 hours

- [x] **TASK-BE-007**: Room lifecycle management ✅
  - Auto-cleanup abandoned rooms (24-hour threshold)
  - Host migration on disconnect
  - Game start validation
  - Room deletion when empty
  - Estimate: 8 hours

### Phase 2: Game Mechanics Implementation
**Duration**: 6 weeks (Sprints 3-5)
**Goal**: Implement core gameplay loop

#### Sprint 3: Game Board and Basic Mechanics
**Week 5-6**

##### Frontend Tasks
- [ ] **TASK-FE-007**: Game board UI layout
  - Cauldron visualization
  - Ingredient bag area
  - Score display
  - Round indicator
  - Estimate: 16 hours

- [ ] **TASK-FE-008**: Ingredient system UI
  - Ingredient assets/icons
  - Drag and drop implementation
  - Draw animation
  - Bag visualization
  - Estimate: 16 hours

- [ ] **TASK-FE-009**: Cauldron interaction
  - Drop zone detection
  - Bubble animation system
  - Score counter animation
  - Explosion effects
  - Estimate: 12 hours

##### Backend Tasks
- [ ] **TASK-BE-008**: Game state management
  - Game initialization (9 rounds)
  - Phase machine implementation (Fortune Teller, Rats, Potions, Evaluation A-F)
  - Simultaneous Potions phase coordination
  - Round progression tracking
  - Estimate: 16 hours

- [ ] **TASK-BE-009**: Ingredient bag system
  - Ingredient distribution
  - Random draw algorithm
  - Bag refill mechanics
  - Special ingredient rules
  - Estimate: 12 hours

#### Sprint 4: Scoring and Rules Engine
**Week 7-8**

##### Backend Tasks
- [ ] **TASK-BE-010**: Scoring calculator
  - Base ingredient values
  - Combo detection
  - Multiplier system
  - Round bonus calculation
  - Estimate: 12 hours

- [ ] **TASK-BE-011**: Explosion mechanics
  - Black ingredient threshold
  - Explosion triggers
  - Penalty calculation
  - Recovery mechanics
  - Estimate: 8 hours

- [ ] **TASK-BE-012**: Special abilities system
  - Ability activation
  - Effect application
  - Cooldown management
  - Ability combinations
  - Estimate: 12 hours

##### Frontend Tasks
- [ ] **TASK-FE-010**: Score visualization
  - Live score updates
  - Score breakdown popup
  - Player rankings display
  - Animation effects
  - Estimate: 12 hours

- [ ] **TASK-FE-011**: Special ability UI
  - Ability cards display
  - Activation buttons
  - Effect animations
  - Cooldown indicators
  - Estimate: 12 hours

#### Sprint 5: Multiplayer Synchronization
**Week 9-10**

##### Backend Tasks
- [ ] **TASK-BE-013**: Real-time game sync
  - Action broadcasting
  - State reconciliation
  - Lag compensation
  - Disconnection handling
  - Estimate: 20 hours

- [ ] **TASK-BE-014**: Anti-cheat measures
  - Server validation
  - Action verification
  - Timing checks
  - Suspicious pattern detection
  - Estimate: 12 hours

##### Frontend Tasks
- [ ] **TASK-FE-012**: Opponent visualization
  - Opponent board preview
  - Action indicators
  - Score comparison
  - Turn indicators
  - Estimate: 16 hours

- [ ] **TASK-FE-013**: Network status UI
  - Connection indicator
  - Reconnection screen
  - Sync status display
  - Error messages
  - Estimate: 8 hours

### Phase 3: Game Polish and Features
**Duration**: 4 weeks (Sprints 6-7)
**Goal**: Polish gameplay and add engagement features

#### Sprint 6: Animations and Effects
**Week 11-12**

##### Frontend Tasks
- [ ] **TASK-FE-014**: Advanced animations
  - Ingredient particle effects
  - Cauldron bubble physics
  - Explosion screen shake
  - Victory celebration
  - Estimate: 20 hours

- [ ] **TASK-FE-015**: Sound implementation
  - UI sound effects
  - Game action sounds
  - Background music
  - Volume controls
  - Estimate: 12 hours

- [ ] **TASK-FE-016**: Haptic feedback
  - Drag vibration
  - Success feedback
  - Explosion rumble
  - Platform-specific implementation
  - Estimate: 8 hours

#### Sprint 7: Core Features Completion
**Week 13-14**

##### Backend Tasks
- [ ] **TASK-BE-015**: Turn notification system
  - Firebase Cloud Messaging setup
  - Turn notifications for offline players
  - Notification preferences
  - Push notification handling
  - Estimate: 12 hours

- [ ] **TASK-BE-016**: Game statistics tracking
  - Track games played/won
  - Victory points totals
  - Win rate calculation
  - Store in user profile
  - Estimate: 8 hours

- [ ] **TASK-BE-017**: Room invitation system
  - Generate invitation links
  - Handle invitation acceptance
  - Track recent players
  - Friend recommendations
  - Estimate: 8 hours

##### Frontend Tasks
- [ ] **TASK-FE-017**: Notification handling
  - In-app notification display
  - Handle push notifications
  - Navigate to active game
  - Turn reminder UI
  - Estimate: 8 hours

- [ ] **TASK-FE-018**: End game screen
  - Final rankings display
  - Score breakdown
  - Add friends from match
  - Rematch option
  - Estimate: 8 hours

- [ ] **TASK-FE-019**: Fortune Teller cards UI
  - Card display system
  - Card effects visualization
  - Round indicator updates
  - Special round events
  - Estimate: 12 hours

### Phase 4: Polish and Friends System
**Duration**: 2 weeks (Sprint 8)
**Goal**: Implement social features and final polish

#### Sprint 8: Friends and Achievements
**Week 15-16**

##### Backend Tasks
- [ ] **TASK-BE-018**: XP and leveling (Backend Only)
  - XP calculation logic
  - Level progression calculation
  - Store in user profile
  - Ready for future UI
  - Estimate: 8 hours

- [ ] **TASK-BE-019**: Achievement system
  - Track 11 core achievements
  - Achievement unlock logic
  - Progress tracking
  - Store in user profile
  - Estimate: 12 hours

##### Frontend Tasks
- [ ] **TASK-FE-020**: Friends system UI
  - Add friend flow
  - Friends list display
  - Recent players list
  - Online status indicators
  - Estimate: 12 hours

- [ ] **TASK-FE-021**: Achievement gallery
  - Achievement display grid
  - Unlock notifications
  - Progress indicators
  - View on friend profiles
  - Estimate: 8 hours

- [ ] **TASK-FE-022**: Onboarding screens
  - 4 welcome screens with navigation
  - Skip functionality
  - Progress indicators
  - Store completion in preferences
  - Estimate: 6 hours

### Phase 5: Platform Optimization
**Duration**: 3 weeks (Sprints 10-11)
**Goal**: Optimize for all platforms

#### Sprint 10: Mobile Optimization
**Week 19-20**

##### iOS Tasks
- [ ] **TASK-IOS-001**: iOS-specific features
  - Sign in with Apple
  - iOS widgets
  - App clips
  - Haptic feedback tuning
  - Estimate: 16 hours

- [ ] **TASK-IOS-002**: iOS optimization
  - Performance profiling
  - Memory management
  - Battery optimization
  - App size reduction
  - Estimate: 12 hours

##### Android Tasks
- [ ] **TASK-AND-001**: Android-specific features
  - Google Play Games integration
  - Android widgets
  - Instant apps
  - Material You theming
  - Estimate: 16 hours

- [ ] **TASK-AND-002**: Android optimization
  - Performance profiling
  - Memory management
  - Battery optimization
  - APK size reduction
  - Estimate: 12 hours

#### Sprint 11: Web and Desktop
**Week 21**

##### Web Tasks
- [ ] **TASK-WEB-001**: Progressive Web App
  - Service worker
  - Offline support
  - Install prompts
  - Web push notifications
  - Estimate: 16 hours

- [ ] **TASK-WEB-002**: Web optimization
  - Bundle size optimization
  - Lazy loading
  - CDN configuration
  - SEO optimization
  - Estimate: 12 hours

##### Desktop Tasks
- [ ] **TASK-DESK-001**: Desktop features
  - Window management
  - Keyboard shortcuts
  - System tray integration
  - Native menus
  - Estimate: 12 hours

### Phase 6: Testing and Launch
**Duration**: 3 weeks (Sprint 12)
**Goal**: Final testing and release preparation

#### Sprint 12: Quality Assurance
**Week 22-24**

##### Testing Tasks
- [ ] **TASK-QA-001**: Unit test coverage
  - Widget tests
  - Business logic tests
  - Integration tests
  - Coverage > 80%
  - Estimate: 20 hours

- [ ] **TASK-QA-002**: E2E testing
  - User flow tests
  - Multiplayer scenarios
  - Payment testing
  - Performance testing
  - Estimate: 20 hours

- [ ] **TASK-QA-003**: Platform testing
  - iOS device testing
  - Android device testing
  - Browser compatibility
  - Desktop testing
  - Estimate: 16 hours

##### Launch Tasks
- [ ] **TASK-LAUNCH-001**: App store preparation
  - Screenshots
  - Descriptions
  - Keywords/ASO
  - Privacy policy
  - Estimate: 12 hours

- [ ] **TASK-LAUNCH-002**: Backend preparation
  - Load testing
  - Scaling configuration
  - Monitoring setup
  - Backup procedures
  - Estimate: 16 hours

- [ ] **TASK-LAUNCH-003**: Marketing materials
  - Landing page
  - Trailer video
  - Press kit
  - Social media assets
  - Estimate: 20 hours

## Critical Path

### Must-Have for MVP (Minimum Viable Product)
1. Room creation with invitation system
2. Full 9-round game mechanics (Fortune Teller, Rats, Potions, Evaluation)
3. Simultaneous Potions phase synchronization
4. Dynamic room management (join/leave/rejoin)
5. Core ingredient effects (all 8 types)
6. Basic UI/UX complete

### Should-Have for Launch
1. Onboarding screens (4 welcome screens)
2. Friends system with recommendations
3. 11 core achievements
4. Sound effects
5. Polished animations
6. Turn notifications for offline players
7. Emote/reaction system

### Nice-to-Have for Post-Launch
1. Enhanced onboarding with animations
2. Additional achievement tiers
3. Statistics UI (currently backend-only)
4. Seasonal events and challenges
5. Advanced friend features (gifting, messaging)

## Resource Allocation

### Developer Roles
1. **Developer 1 (Frontend Lead)**
   - Primary: UI/UX implementation
   - Secondary: Animations and effects
   - ~40% of frontend tasks

2. **Developer 2 (Backend Lead)**
   - Primary: Firebase and game logic
   - Secondary: Multiplayer sync
   - ~40% of backend tasks

3. **Developer 3 (Full Stack)**
   - Primary: Feature integration
   - Secondary: Platform optimization
   - ~30% frontend, ~30% backend

4. **Developer 4 (Full Stack)**
   - Primary: Testing and polish
   - Secondary: DevOps and deployment
   - ~30% frontend, ~30% backend

## Risk Mitigation

### Technical Risks
1. **Real-time sync performance**
   - Mitigation: Early prototyping, fallback to turn-based
   - Contingency: 2 weeks buffer

2. **Platform-specific bugs**
   - Mitigation: Continuous testing on all platforms
   - Contingency: Platform-specific release delays

3. **Scaling issues**
   - Mitigation: Load testing from Sprint 8
   - Contingency: Gradual rollout strategy

### Schedule Risks
1. **Feature creep**
   - Mitigation: Strict MVP definition
   - Contingency: Post-launch updates

2. **Integration delays**
   - Mitigation: Early API development
   - Contingency: Mock services

3. **App store approval**
   - Mitigation: Early submission for review
   - Contingency: 2-week buffer

## Success Metrics

### Development Metrics
- Sprint velocity: 40 story points average
- Bug discovery rate < 5 per sprint after Sprint 6
- Code review turnaround < 4 hours
- Build success rate > 95%

### Quality Metrics
- Unit test coverage > 80%
- Integration test coverage > 60%
- Crash-free rate > 99.5%
- Performance budget met (3s load, 60fps)

### Launch Metrics
- Beta feedback score > 4.0/5.0
- 100 beta testers recruited
- 0 critical bugs at launch
- All platforms approved for release

## Monitoring and Reporting

### Daily Standups
- 15-minute sync meetings
- Blocker identification
- Progress updates
- Next 24-hour plan

### Sprint Reviews
- Demo completed features
- Stakeholder feedback
- Acceptance criteria validation
- Velocity tracking

### Retrospectives
- Process improvements
- Team health check
- Risk reassessment
- Action items for next sprint

## Dependencies and Prerequisites

### External Dependencies
1. Firebase service availability
2. App store developer accounts
3. Design assets delivery
4. Sound/music assets
5. Marketing materials

### Internal Dependencies
1. Code review process
2. CI/CD pipeline setup
3. Testing environment
4. Documentation updates
5. Version control workflow

## Definition of Done

### Feature Complete
- Code implemented and reviewed
- Unit tests written and passing
- Integration tests passing
- Documentation updated
- UI/UX review passed

### Sprint Complete
- All stories accepted
- No critical bugs
- Performance targets met
- Deployment successful
- Retrospective completed

### Release Ready
- All acceptance criteria met
- Security audit passed
- Performance testing passed
- App store compliance verified
- Marketing materials ready

This task plan provides a comprehensive roadmap for Calderum development, with clear milestones, resource allocation, and risk management strategies to ensure successful delivery within the 6-month timeline.