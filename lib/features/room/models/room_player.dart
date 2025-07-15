import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_player.freezed.dart';
part 'room_player.g.dart';

@freezed
abstract class RoomPlayer with _$RoomPlayer {
  const factory RoomPlayer({
    required String id,
    required String roomId,
    required String playerId,
    required DateTime joinedAt,
    @Default('player') String role,
  }) = _RoomPlayer;

  factory RoomPlayer.fromJson(Map<String, dynamic> json) =>
      _$RoomPlayerFromJson(json);
}
