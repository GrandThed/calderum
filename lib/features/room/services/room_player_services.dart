import 'package:calderum/core/services/global_services.dart';
import 'package:calderum/features/room/models/room.dart';
import 'package:calderum/features/room/models/room_player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomPlayerService extends GlobalServices {
  final _client = Supabase.instance.client;
  final _table = 'room_players';

  Future<void> invitePlayer(String roomId, String playerId) async {
    await _client.from(_table).insert({
      'room_id': roomId,
      'player_id': playerId,
    });
  }

  Future<List<RoomPlayer>> getPlayersInRoom(String roomId) async {
    final result = await _client.from(_table).select().eq('room_id', roomId);

    return (result as List).map((e) => RoomPlayer.fromJson(e)).toList();
  }

  Future<List<Room>> getRoomsForPlayer(String playerId) async {
    final result = await _client
        .from('room_players')
        .select('room_id, rooms(*)')
        .eq('player_id', playerId);

    return (result as List).map((e) => Room.fromJson(e['rooms'])).toList();
  }

  Future<void> createRoomWithHost(Room room, String hostId) async {
    final client = Supabase.instance.client;

    await client.rpc(
      'create_room_with_host',
      params: {
        'room_id': room.id,
        'name': room.name,
        'host_id': hostId,
        'status': room.status.name,
        'invite_code': room.inviteCode,
        'round': room.round,
        'max_players': room.maxPlayers,
      },
    );
  }

  Future<void> addPlayerToRoom(String roomId, String playerId) async {
    await _client.from(_table).insert({
      'room_id': roomId,
      'player_id': playerId,
    });
  }

  Future<List<String>> getPreviousPlayers(String currentUserId) async {
    final result = await _client.rpc(
      'get_previous_players',
      params: {'user_id': currentUserId},
    );

    return List<String>.from(result);
  }

  Future<List<RoomPlayer>> getRoomPlayers(String roomId) async {
    final result = await _client.from(_table).select().eq('room_id', roomId);

    return (result as List).map((e) => RoomPlayer.fromJson(e)).toList();
  }

  Future<void> removePlayerFromRoom(String roomId, String playerId) async {
    await _client.from(_table).delete().match({
      'room_id': roomId,
      'player_id': playerId,
    });
  }
}
