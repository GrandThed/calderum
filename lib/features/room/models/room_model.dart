import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

@freezed
class RoomModel with _$RoomModel {
  const factory RoomModel({
    required String id,
    required String code,
    required String hostId,
    required String hostName,
    @JsonKey(name: 'players') required List<RoomPlayerModel> players,
    required RoomSettingsModel settings,
    required RoomStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? currentGameId,
    int? currentRound,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}

@freezed
class RoomPlayerModel with _$RoomPlayerModel {
  const factory RoomPlayerModel({
    required String userId,
    required String displayName,
    String? photoUrl,
    required bool isOnline,
    required bool isReady,
    required DateTime joinedAt,
    DateTime? lastSeen,
  }) = _RoomPlayerModel;

  factory RoomPlayerModel.fromJson(Map<String, dynamic> json) =>
      _$RoomPlayerModelFromJson(json);
}

@freezed
class RoomSettingsModel with _$RoomSettingsModel {
  const factory RoomSettingsModel({
    @Default(4) int maxPlayers,
    @Default(2) int minPlayers,
    @Default(IngredientSet.set1) IngredientSet ingredientSet,
    @Default(false) bool testTubeVariant,
    @Default(false) bool allowMidGameJoins,
    @Default(false) bool allowSpectators,
  }) = _RoomSettingsModel;

  factory RoomSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$RoomSettingsModelFromJson(json);
}

enum RoomStatus {
  @JsonValue('waiting')
  waiting,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('paused')
  paused,
  @JsonValue('finished')
  finished,
}

enum IngredientSet {
  @JsonValue('set1')
  set1,
  @JsonValue('set2')
  set2,
  @JsonValue('set3')
  set3,
  @JsonValue('set4')
  set4,
}
