import 'dart:async';

import 'package:calderum/core/services/global_services.dart';
import 'package:calderum/features/room/models/room.dart';
import 'package:calderum/features/room/services/room_player_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomService extends RoomPlayerService {
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

  Future<void> joinRoom(String roomId, String playerId) async {
    await _client.from('room_players').insert({
      'room_id': roomId,
      'player_id': playerId,
    });
  }

  // Stream controller compartido
  final _controller = StreamController<Room>.broadcast();
}
