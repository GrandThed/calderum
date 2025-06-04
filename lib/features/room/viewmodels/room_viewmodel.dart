import 'dart:async';

import 'package:calderum/core/services/global_services.dart';
import 'package:calderum/features/room/models/room.dart';
import 'package:calderum/features/room/services/room_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room_viewmodel.g.dart';

@riverpod
class RoomViewModel extends _$RoomViewModel {
  final _service = RoomService();

  StreamSubscription<List<Room>>? _subscription;

  @override
  AsyncValue<List<Room>> build() {
    final userId = GlobalServices.currentUserId;
    if (userId == null) return const AsyncValue.data([]);

    _subscription = _service.streamUserRooms(userId).listen((rooms) {
      state = AsyncValue.data(rooms);
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return const AsyncValue.loading();
  }

  Future<void> createRoom(Room room) async {
    await _service.createRoom(room);
  }

  Future<void> joinRoom(String roomId, String playerId) async {
    await _service.joinRoom(roomId, playerId);
  }

  Room? getRoomById(String id) {
    return state.maybeWhen(
      data: (rooms) => rooms.firstWhere((r) => r.id == id),
      orElse: () => null,
    );
  }

  Future<Room?> getRoomByInviteCode(String inviteCode) async {
    return _service.getRoomByInviteCode(inviteCode);
  }
}
