// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomPlayer _$RoomPlayerFromJson(Map<String, dynamic> json) => _RoomPlayer(
  id: json['id'] as String,
  roomId: json['roomId'] as String,
  playerId: json['playerId'] as String,
  joinedAt: DateTime.parse(json['joinedAt'] as String),
  role: json['role'] as String? ?? 'player',
);

Map<String, dynamic> _$RoomPlayerToJson(_RoomPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'playerId': instance.playerId,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'role': instance.role,
    };
