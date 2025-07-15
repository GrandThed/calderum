import 'dart:async';

import 'package:calderum/core/services/global_services.dart';
import 'package:calderum/features/room/models/room.dart';
import 'package:calderum/features/room/services/room_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room_viewmodel.g.dart';

@riverpod
class RoomViewModel extends _$RoomViewModel {
  final _service = RoomService();

  @override
  FutureOr<List<Room>> build() async {
    state = const AsyncValue.loading();
    final userId = GlobalServices.currentUserId;
    try {
      final rooms = await _service.getRoomsForPlayer(userId!);
      return rooms;
    } catch (e, _) {
      throw Exception('Failed to load rooms: $e');
    }
  }

  Future<void> createRoom(Room room) async {
    await _service.createRoom(room);
  }

  Future<void> joinRoom(String roomId, String playerId) async {
    await _service.joinRoom(roomId, playerId);
  }

  Future<Room?> getRoomByInviteCode(String inviteCode) async {
    return _service.getRoomByInviteCode(inviteCode);
  }
}
