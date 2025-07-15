// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Room {

 String get id; String get name; String get hostId; String get inviteCode;@RoomStatusConverter() RoomStatus get status; int get round; String? get currentTurnPlayerId; int get maxPlayers; DateTime get createdAt;
/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomCopyWith<Room> get copyWith => _$RoomCopyWithImpl<Room>(this as Room, _$identity);

  /// Serializes this Room to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Room&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.round, round) || other.round == round)&&(identical(other.currentTurnPlayerId, currentTurnPlayerId) || other.currentTurnPlayerId == currentTurnPlayerId)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hostId,inviteCode,status,round,currentTurnPlayerId,maxPlayers,createdAt);

@override
String toString() {
  return 'Room(id: $id, name: $name, hostId: $hostId, inviteCode: $inviteCode, status: $status, round: $round, currentTurnPlayerId: $currentTurnPlayerId, maxPlayers: $maxPlayers, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RoomCopyWith<$Res>  {
  factory $RoomCopyWith(Room value, $Res Function(Room) _then) = _$RoomCopyWithImpl;
@useResult
$Res call({
 String id, String name, String hostId, String inviteCode,@RoomStatusConverter() RoomStatus status, int round, String? currentTurnPlayerId, int maxPlayers, DateTime createdAt
});




}
/// @nodoc
class _$RoomCopyWithImpl<$Res>
    implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._self, this._then);

  final Room _self;
  final $Res Function(Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? hostId = null,Object? inviteCode = null,Object? status = null,Object? round = null,Object? currentTurnPlayerId = freezed,Object? maxPlayers = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomStatus,round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int,currentTurnPlayerId: freezed == currentTurnPlayerId ? _self.currentTurnPlayerId : currentTurnPlayerId // ignore: cast_nullable_to_non_nullable
as String?,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Room implements Room {
  const _Room({required this.id, required this.name, required this.hostId, required this.inviteCode, @RoomStatusConverter() required this.status, this.round = 1, this.currentTurnPlayerId, this.maxPlayers = 4, required this.createdAt});
  factory _Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

@override final  String id;
@override final  String name;
@override final  String hostId;
@override final  String inviteCode;
@override@RoomStatusConverter() final  RoomStatus status;
@override@JsonKey() final  int round;
@override final  String? currentTurnPlayerId;
@override@JsonKey() final  int maxPlayers;
@override final  DateTime createdAt;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomCopyWith<_Room> get copyWith => __$RoomCopyWithImpl<_Room>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Room&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.round, round) || other.round == round)&&(identical(other.currentTurnPlayerId, currentTurnPlayerId) || other.currentTurnPlayerId == currentTurnPlayerId)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hostId,inviteCode,status,round,currentTurnPlayerId,maxPlayers,createdAt);

@override
String toString() {
  return 'Room(id: $id, name: $name, hostId: $hostId, inviteCode: $inviteCode, status: $status, round: $round, currentTurnPlayerId: $currentTurnPlayerId, maxPlayers: $maxPlayers, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RoomCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$RoomCopyWith(_Room value, $Res Function(_Room) _then) = __$RoomCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String hostId, String inviteCode,@RoomStatusConverter() RoomStatus status, int round, String? currentTurnPlayerId, int maxPlayers, DateTime createdAt
});




}
/// @nodoc
class __$RoomCopyWithImpl<$Res>
    implements _$RoomCopyWith<$Res> {
  __$RoomCopyWithImpl(this._self, this._then);

  final _Room _self;
  final $Res Function(_Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? hostId = null,Object? inviteCode = null,Object? status = null,Object? round = null,Object? currentTurnPlayerId = freezed,Object? maxPlayers = null,Object? createdAt = null,}) {
  return _then(_Room(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomStatus,round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int,currentTurnPlayerId: freezed == currentTurnPlayerId ? _self.currentTurnPlayerId : currentTurnPlayerId // ignore: cast_nullable_to_non_nullable
as String?,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
