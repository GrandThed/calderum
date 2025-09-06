import 'package:freezed_annotation/freezed_annotation.dart';
import 'ingredient_model.dart';
import '../../account/models/user_model.dart';
import '../utils/pot_scoring.dart';

part 'game_state_model.freezed.dart';
part 'game_state_model.g.dart';

/// Game phases within each turn
enum GamePhase {
  fortuneTeller('Fortune Teller'),
  rats('Rats'),
  potions('Potions'),
  evaluationA('Evaluation A - Bonus Die'),
  evaluationB('Evaluation B - Chip Actions'),
  evaluationC('Evaluation C - Rubies'),
  evaluationD('Evaluation D - Victory Points'),
  evaluationE('Evaluation E - Buy Chips'),
  evaluationF('Evaluation F - End Turn'),
  gameOver('Game Over');

  const GamePhase(this.displayName);
  final String displayName;
}

/// Fortune Teller card types
enum FortuneTellerType {
  purple, // Applied immediately before turn starts
  blue, // Applied during or end of turn
}

/// Fortune Teller card
@freezed
class FortuneTellerCard with _$FortuneTellerCard {
  const factory FortuneTellerCard({
    required String id,
    required FortuneTellerType type,
    required String title,
    required String description,
    required String effect,
  }) = _FortuneTellerCard;

  factory FortuneTellerCard.fromJson(Map<String, dynamic> json) =>
      _$FortuneTellerCardFromJson(json);
}

/// Player's pot state (board)
@freezed
class PotState with _$PotState {
  const factory PotState({
    required String playerId,
    @Default([]) List<IngredientChip> placedChips, // Chips on pot in order
    @Default(0) int dropletPosition, // Current droplet position (0-53)
    int? ratPosition, // Rat stone position (catch-up mechanic)
    @Default(false) bool hasExploded, // If pot exploded this turn
    @Default(true) bool flaskAvailable, // Can use flask to return white chip
    @Default(0) int victoryPoints,
    @Default(0) int rubies,
    @Default(0) int coins, // Based on scoring position
    @Default(false) bool isReady, // Ready for next phase
  }) = _PotState;

  factory PotState.fromJson(Map<String, dynamic> json) =>
      _$PotStateFromJson(json);
}

/// Extension methods for pot operations
extension PotStateOperations on PotState {
  /// Get current scoring position (highest chip position or droplet)
  int get scoringPosition {
    if (placedChips.isEmpty) return dropletPosition;

    final lastChipPosition = placedChips.last.positionOnBoard;
    if (lastChipPosition == null) return dropletPosition;

    return lastChipPosition > dropletPosition
        ? lastChipPosition
        : dropletPosition;
  }

  /// Get white chip total on pot
  int get whiteChipTotal => placedChips
      .where((chip) => chip.color == IngredientColor.white)
      .fold(0, (sum, chip) => sum + chip.value);

  /// Check if pot is exploded (white chips > 7)
  bool get isExploded => whiteChipTotal > 7;

  /// Get coins based on scoring position
  int get coinsFromPosition => PotScoring.getCoins(
      PotScoring.getPotNumber(scoringPosition), hasExploded);

  /// Check if player is on a ruby space
  bool get isOnRubySpace => PotScoring.hasRuby(scoringPosition);

  /// Get victory points from scoring track position
  int get victoryPointsFromPosition => PotScoring.getVictoryPoints(scoringPosition);

  /// Get next available position for placing chip
  int getNextPosition(int chipValue) {
    int startPosition = ratPosition ?? dropletPosition;

    if (placedChips.isNotEmpty) {
      final lastPosition = placedChips.last.positionOnBoard;
      if (lastPosition != null && lastPosition > startPosition) {
        startPosition = lastPosition;
      }
    }

    return startPosition + chipValue;
  }

  /// Check if position is valid for chip placement (0-53)
  bool isValidPosition(int position) => position >= 0 && position <= PotScoring.getMaxPosition();
}

/// Game state for the entire match
@freezed
class GameState with _$GameState {
  const factory GameState({
    required String gameId,
    required String roomId,
    @Default(1) int currentTurn, // 1-9
    @Default(GamePhase.fortuneTeller) GamePhase currentPhase,
    @Default([]) List<GamePlayer> players,
    @Default([]) List<FortuneTellerCard> fortuneTellerDeck,
    FortuneTellerCard? currentFortuneTellerCard,
    @Default([]) List<String> turnOrder, // Player IDs in turn order
    @Default(0) int currentPlayerIndex, // For phases that require turn order
    required IngredientMarket ingredientMarket,
    @Default([]) List<String> bonusDieWinners, // Players who can roll bonus die
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isGameOver,
    String? winnerId,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}

/// Player in game context
@freezed
class GamePlayer with _$GamePlayer {
  const factory GamePlayer({
    required String userId,
    required String displayName,
    String? photoUrl,
    required PotState potState,
    required IngredientBag ingredientBag,
    @Default(false) bool isOnline,
    @Default(false) bool hasCompletedPhase, // For current phase
    DateTime? lastAction,
  }) = _GamePlayer;

  factory GamePlayer.fromJson(Map<String, dynamic> json) =>
      _$GamePlayerFromJson(json);
}

/// Extension methods for game state operations
extension GameStateOperations on GameState {
  /// Check if all players have completed current phase
  bool get allPlayersReady =>
      players.every((player) => player.hasCompletedPhase);

  /// Get current phase player (for sequential phases)
  GamePlayer? get currentPlayer {
    if (currentPlayerIndex < 0 || currentPlayerIndex >= players.length) {
      return null;
    }
    return players[currentPlayerIndex];
  }

  /// Get players sorted by scoring position (for bonus die)
  List<GamePlayer> get playersByScore => players.toList()
    ..sort(
      (a, b) =>
          b.potState.scoringPosition.compareTo(a.potState.scoringPosition),
    );

  /// Get leading players for bonus die roll
  List<GamePlayer> get bonusDieEligiblePlayers {
    if (players.isEmpty) return [];

    final sorted = playersByScore;
    final highestScore = sorted.first.potState.scoringPosition;

    return sorted
        .where(
          (player) =>
              player.potState.scoringPosition == highestScore &&
              !player.potState.hasExploded,
        )
        .toList();
  }

  /// Check if game should end (turn 9 complete)
  bool get shouldEndGame =>
      currentTurn >= 9 && currentPhase == GamePhase.gameOver;

  /// Get winner (highest victory points)
  GamePlayer? get winner {
    if (!isGameOver) return null;

    final sorted = players.toList()
      ..sort(
        (a, b) => b.potState.victoryPoints.compareTo(a.potState.victoryPoints),
      );

    return sorted.isEmpty ? null : sorted.first;
  }

  /// Create new game from room players
  static GameState createNewGame({
    required String gameId,
    required String roomId,
    required List<UserModel> roomPlayers,
  }) {
    // Create turn order (random or based on room order)
    final turnOrder = roomPlayers.map((player) => player.uid).toList()
      ..shuffle();

    // Create game players
    final gamePlayers = roomPlayers
        .map(
          (player) => GamePlayer(
            userId: player.uid,
            displayName: player.displayName,
            photoUrl: player.photoUrl,
            potState: PotState(
              playerId: player.uid,
              dropletPosition: 0,
              victoryPoints: 0,
              rubies: 0,
              coins: 0,
            ),
            ingredientBag: IngredientBagOperations.createStartingBag(
              player.uid,
            ),
            isOnline: true,
            hasCompletedPhase: false,
          ),
        )
        .toList();

    // Create Fortune Teller deck (placeholder - would need actual cards)
    final fortuneTellerDeck = _createFortuneTellerDeck();

    // Create initial ingredient market
    final ingredientMarket = IngredientMarketOperations.createForTurn(1);

    final now = DateTime.now();

    return GameState(
      gameId: gameId,
      roomId: roomId,
      currentTurn: 1,
      currentPhase: GamePhase.fortuneTeller,
      players: gamePlayers,
      fortuneTellerDeck: fortuneTellerDeck,
      turnOrder: turnOrder,
      currentPlayerIndex: 0,
      ingredientMarket: ingredientMarket,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create Fortune Teller deck (simplified for MVP)
  static List<FortuneTellerCard> _createFortuneTellerDeck() {
    return [
      const FortuneTellerCard(
        id: 'ft_001',
        type: FortuneTellerType.purple,
        title: 'Generous Day',
        description: 'Everyone gains 1 ruby',
        effect: 'all_players_gain_ruby',
      ),
      const FortuneTellerCard(
        id: 'ft_002',
        type: FortuneTellerType.blue,
        title: 'Lucky Day',
        description: 'Bonus die shows +1',
        effect: 'bonus_die_plus_one',
      ),
      const FortuneTellerCard(
        id: 'ft_003',
        type: FortuneTellerType.purple,
        title: 'Droplet Day',
        description: 'Move droplets forward 1 space',
        effect: 'all_droplets_forward',
      ),
      // Add more cards as needed...
    ];
  }
}

/// Game action for state changes
@freezed
class GameAction with _$GameAction {
  // Potion phase actions
  const factory GameAction.drawChip({
    required String playerId,
    required IngredientChip chip,
  }) = DrawChipAction;

  const factory GameAction.placeChip({
    required String playerId,
    required IngredientChip chip,
    required int position,
  }) = PlaceChipAction;

  const factory GameAction.useFlask({
    required String playerId,
    required IngredientChip returnedChip,
  }) = UseFlaskAction;

  const factory GameAction.stopDrawing({required String playerId}) =
      StopDrawingAction;

  // Phase management
  const factory GameAction.completePhase({required String playerId}) =
      CompletePhaseAction;

  const factory GameAction.nextPhase() = NextPhaseAction;

  const factory GameAction.nextTurn() = NextTurnAction;

  // Shopping actions
  const factory GameAction.buyIngredient({
    required String playerId,
    required AvailableIngredient ingredient,
  }) = BuyIngredientAction;

  // Ruby actions
  const factory GameAction.useRubies({
    required String playerId,
    required String action, // 'move_droplet' or 'refill_flask'
    required int rubyCount,
  }) = UseRubiesAction;

  factory GameAction.fromJson(Map<String, dynamic> json) =>
      _$GameActionFromJson(json);
}
