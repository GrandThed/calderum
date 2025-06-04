import 'dart:async';

import 'package:calderum/core/services/global_services.dart';
import 'package:calderum/features/room/models/room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomService extends GlobalServices {
  final _client = GlobalServices.client;
  final _table = 'rooms';

  Future<void> createRoom(Room room) async {
    final data = room.toJson();
    await _client.from(_table).insert(data);
  }

  Future<Room?> getRoomById(String id) async {
    final result = await _client.from(_table).select().eq('id', id).single();
    return Room.fromJson(result);
  }

  Future<void> joinRoom(String roomId, String playerId) async {
    final room = await getRoomById(roomId);
    if (room == null || room.status != RoomStatus.creating) return;

    final updatedPlayerIds = {...room.playerIds, playerId}.toList();

    await _client
        .from(_table)
        .update({'playerIds': updatedPlayerIds})
        .eq('id', roomId);
  }

  Stream<List<Room>> streamUserRooms(String userId) {
    final controller = StreamController<List<Room>>.broadcast();

    final channel = _client.channel('rooms_user_$userId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'rooms',
          callback: (payload) async {
            final result = await getActiveRooms();
            final userRooms = result
                .where((r) => r.playerIds.contains(userId))
                .toList();
            controller.add(userRooms);
          },
        )
        .subscribe();

    return controller.stream;
  }

  Future<List<Room>> getActiveRooms() async {
    final result = await _client
        .from(_table)
        .select()
        .eq('status', 'inGame')
        .order('created_at', ascending: false);

    return (result as List)
        .map((room) => Room.fromJson(room as Map<String, dynamic>))
        .toList();
  }

  Stream<Room> subscribeToRoom(String roomId) {
    final channel = _client.channel('room:$roomId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: _table,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: roomId,
          ),
          callback: (payload) {
            final json = payload.newRecord;
            if (_controller.hasListener) {
              final room = Room.fromJson(json);
              _controller.add(room);
            }
          },
        )
        .subscribe();

    return _controller.stream;
  }

  Future<Room?> getRoomByInviteCode(String code) async {
    final result = await _client
        .from('rooms')
        .select()
        .eq('invite_code', code)
        .order('created_at', ascending: true)
        .limit(1)
        .maybeSingle();

    if (result == null) return null;

    return Room.fromJson(result);
  }

  // Stream controller compartido
  final _controller = StreamController<Room>.broadcast();
}
