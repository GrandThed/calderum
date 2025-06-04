import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

enum RoomStatus { creating, inGame, finished }

@freezed
abstract class Room with _$Room {
  const factory Room({
    required String id,
    required String name,
    required String hostId,
    required String inviteCode,
    required List<String> playerIds,
    @RoomStatusConverter() required RoomStatus status,
    @Default(1) int round,
    String? currentTurnPlayerId,
    @Default(4) int maxPlayers,
    required DateTime createdAt,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}

class RoomStatusConverter implements JsonConverter<RoomStatus, String> {
  const RoomStatusConverter();

  @override
  RoomStatus fromJson(String json) => RoomStatus.values.firstWhere(
    (e) => e.name == json,
    orElse: () => RoomStatus.creating,
  );

  @override
  String toJson(RoomStatus status) => status.name;
}
