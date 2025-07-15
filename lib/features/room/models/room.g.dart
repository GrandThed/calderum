// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
  id: json['id'] as String,
  name: json['name'] as String,
  hostId: json['hostId'] as String,
  inviteCode: json['inviteCode'] as String,
  status: const RoomStatusConverter().fromJson(json['status'] as String),
  round: (json['round'] as num?)?.toInt() ?? 1,
  currentTurnPlayerId: json['currentTurnPlayerId'] as String?,
  maxPlayers: (json['maxPlayers'] as num?)?.toInt() ?? 4,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'hostId': instance.hostId,
  'inviteCode': instance.inviteCode,
  'status': const RoomStatusConverter().toJson(instance.status),
  'round': instance.round,
  'currentTurnPlayerId': instance.currentTurnPlayerId,
  'maxPlayers': instance.maxPlayers,
  'createdAt': instance.createdAt.toIso8601String(),
};
