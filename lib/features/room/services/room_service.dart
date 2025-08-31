import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room_model.dart';
import '../models/room_invitation_model.dart';
import '../models/emote_model.dart';
import '../../account/models/user_model.dart';
import '../../friends/services/friends_service.dart';

final roomServiceProvider = Provider<RoomService>((ref) {
  final friendsService = ref.read(friendsServiceProvider);
  return RoomService(FirebaseFirestore.instance, friendsService);
});

class RoomService {
  final FirebaseFirestore _firestore;
  final FriendsService _friendsService;
  static const String _roomsCollection = 'rooms';
  static const String _invitationsCollection = 'room_invitations';

  RoomService(this._firestore, this._friendsService);

  // Generate unique 6-character room code
  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Create a new room
  Future<RoomModel> createRoom({
    required UserModel host,
    RoomSettingsModel? settings,
  }) async {
    // Check if user already has a waiting room as host
    final existingHostRooms = await _firestore
        .collection(_roomsCollection)
        .where('hostId', isEqualTo: host.uid)
        .where('status', isEqualTo: RoomStatus.waiting.name)
        .get();
    
    if (existingHostRooms.docs.isNotEmpty) {
      // Return the existing waiting room instead of creating a new one
      final existingRoom = RoomModel.fromJson({
        ...existingHostRooms.docs.first.data(),
        'id': existingHostRooms.docs.first.id,
      });
      print('♻️ Returning existing waiting room where user is host: ${existingRoom.code}');
      return existingRoom;
    }
    
    // Also check if user is already in a waiting room as a player
    final allWaitingRooms = await _firestore
        .collection(_roomsCollection)
        .where('status', isEqualTo: RoomStatus.waiting.name)
        .get();
    
    for (final doc in allWaitingRooms.docs) {
      final room = RoomModel.fromJson({...doc.data(), 'id': doc.id});
      if (room.players.any((p) => p.userId == host.uid)) {
        print('♻️ User already in waiting room: ${room.code}');
        // User is already in a waiting room, return that room
        return room;
      }
    }
    
    final roomCode = _generateRoomCode();
    final now = DateTime.now();
    
    final room = RoomModel(
      id: '', // Will be set by Firestore
      code: roomCode,
      hostId: host.uid,
      hostName: host.displayName,
      players: [
        RoomPlayerModel(
          userId: host.uid,
          displayName: host.displayName,
          photoUrl: host.photoUrl,
          isOnline: true,
          isReady: true, // Host is ready by default
          joinedAt: now,
          lastSeen: now,
        ),
      ],
      settings: settings ?? const RoomSettingsModel(),
      status: RoomStatus.waiting,
      createdAt: now,
      updatedAt: now,
    );

    print('🏠 Attempting to serialize room data...');
    final roomJson = room.toJson();
    print('✅ Room JSON serialized successfully');
    print('   - Players count: ${roomJson['players']?.length}');
    print('   - First player type: ${roomJson['players']?[0].runtimeType}');
    
    // Manually serialize nested objects to ensure proper JSON conversion
    final playersJson = room.players.map((player) => player.toJson()).toList();
    final settingsJson = room.settings.toJson();
    
    final correctedRoomJson = Map<String, dynamic>.from(roomJson);
    correctedRoomJson['players'] = playersJson;
    correctedRoomJson['settings'] = settingsJson;
    
    print('🔧 Fixed nested object serialization');
    print('   - Fixed player type: ${correctedRoomJson['players'][0].runtimeType}');
    print('   - Fixed settings type: ${correctedRoomJson['settings'].runtimeType}');
    
    print('💾 Saving room to Firestore...');
    final docRef = await _firestore.collection(_roomsCollection).add(correctedRoomJson);
    print('✅ Room saved to Firestore with ID: ${docRef.id}');
    
    return room.copyWith(id: docRef.id);
  }

  // Join room by code
  Future<RoomModel> joinRoomByCode({
    required String roomCode,
    required UserModel user,
  }) async {
    // Find room by code
    final querySnapshot = await _firestore
        .collection(_roomsCollection)
        .where('code', isEqualTo: roomCode.toUpperCase())
        .where('status', whereIn: [RoomStatus.waiting.name, RoomStatus.inProgress.name])
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw 'Room not found or no longer available';
    }

    final doc = querySnapshot.docs.first;
    final room = RoomModel.fromJson({...doc.data(), 'id': doc.id});

    // Check if user is already in room
    if (room.players.any((p) => p.userId == user.uid)) {
      // Update player status to online and return room
      return await _updatePlayerStatus(room.id, user.uid, isOnline: true);
    }

    // Check room capacity
    if (room.players.length >= room.settings.maxPlayers) {
      throw 'Room is full (${room.players.length}/${room.settings.maxPlayers} players)';
    }

    // Check if mid-game joins are allowed
    if (room.status == RoomStatus.inProgress && !room.settings.allowMidGameJoins) {
      throw 'Cannot join room - game is in progress';
    }

    // Add player to room
    final newPlayer = RoomPlayerModel(
      userId: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      isOnline: true,
      isReady: false,
      joinedAt: DateTime.now(),
      lastSeen: DateTime.now(),
    );

    final updatedPlayers = [...room.players, newPlayer];

    await _firestore.collection(_roomsCollection).doc(room.id).update({
      'players': updatedPlayers.map((p) => p.toJson()).toList(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // Add all existing players as recent players for the new user
    for (final existingPlayer in room.players) {
      await _friendsService.addRecentPlayer(
        currentUserId: user.uid,
        playerId: existingPlayer.userId,
        playerName: existingPlayer.displayName,
        playerPhotoUrl: existingPlayer.photoUrl,
      );
      
      // Add new user as recent player for existing players
      await _friendsService.addRecentPlayer(
        currentUserId: existingPlayer.userId,
        playerId: user.uid,
        playerName: user.displayName,
        playerPhotoUrl: user.photoUrl,
      );
    }

    return room.copyWith(
      players: updatedPlayers,
      updatedAt: DateTime.now(),
    );
  }

  // Leave room
  Future<void> leaveRoom(String roomId, String userId) async {
    final doc = await _firestore.collection(_roomsCollection).doc(roomId).get();
    if (!doc.exists) return;

    final room = RoomModel.fromJson({...doc.data()!, 'id': doc.id});
    final updatedPlayers = room.players.where((p) => p.userId != userId).toList();

    if (updatedPlayers.isEmpty) {
      // Delete room if no players left
      await _firestore.collection(_roomsCollection).doc(roomId).delete();
      return;
    }

    // If host left, assign new host
    String newHostId = room.hostId;
    String newHostName = room.hostName;
    
    if (room.hostId == userId) {
      final newHost = updatedPlayers.first;
      newHostId = newHost.userId;
      newHostName = newHost.displayName;
    }

    await _firestore.collection(_roomsCollection).doc(roomId).update({
      'hostId': newHostId,
      'hostName': newHostName,
      'players': updatedPlayers.map((p) => p.toJson()).toList(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // Update player ready status
  Future<RoomModel> updatePlayerReady(String roomId, String userId, bool isReady) async {
    final doc = await _firestore.collection(_roomsCollection).doc(roomId).get();
    if (!doc.exists) throw 'Room not found';

    final room = RoomModel.fromJson({...doc.data()!, 'id': doc.id});
    final updatedPlayers = room.players.map((player) {
      if (player.userId == userId) {
        return player.copyWith(isReady: isReady);
      }
      return player;
    }).toList();

    await _firestore.collection(_roomsCollection).doc(roomId).update({
      'players': updatedPlayers.map((p) => p.toJson()).toList(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    return room.copyWith(
      players: updatedPlayers,
      updatedAt: DateTime.now(),
    );
  }

  // Update player online status
  Future<RoomModel> _updatePlayerStatus(String roomId, String userId, {bool? isOnline}) async {
    final doc = await _firestore.collection(_roomsCollection).doc(roomId).get();
    if (!doc.exists) throw 'Room not found';

    final room = RoomModel.fromJson({...doc.data()!, 'id': doc.id});
    final updatedPlayers = room.players.map((player) {
      if (player.userId == userId) {
        return player.copyWith(
          isOnline: isOnline ?? player.isOnline,
          lastSeen: DateTime.now(),
        );
      }
      return player;
    }).toList();

    await _firestore.collection(_roomsCollection).doc(roomId).update({
      'players': updatedPlayers.map((p) => p.toJson()).toList(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    return room.copyWith(
      players: updatedPlayers,
      updatedAt: DateTime.now(),
    );
  }

  // Get room by ID
  Future<RoomModel?> getRoomById(String roomId) async {
    final doc = await _firestore.collection(_roomsCollection).doc(roomId).get();
    if (!doc.exists) return null;

    return RoomModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  // Stream room changes
  Stream<RoomModel> streamRoom(String roomId) {
    return _firestore
        .collection(_roomsCollection)
        .doc(roomId)
        .snapshots()
        .map((doc) => RoomModel.fromJson({...doc.data()!, 'id': doc.id}));
  }

  // Get user's active rooms
  Stream<List<RoomModel>> streamUserRooms(String userId) {
    return _firestore
        .collection(_roomsCollection)
        .where('players', arrayContains: {
          'userId': userId,
          'isOnline': true,
        })
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RoomModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Update room settings (host only)
  Future<void> updateRoomSettings(String roomId, String hostId, RoomSettingsModel settings) async {
    final doc = await _firestore.collection(_roomsCollection).doc(roomId).get();
    if (!doc.exists) throw 'Room not found';

    final room = RoomModel.fromJson({...doc.data()!, 'id': doc.id});
    if (room.hostId != hostId) throw 'Only the host can update room settings';

    await _firestore.collection(_roomsCollection).doc(roomId).update({
      'settings': settings.toJson(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // Emote/Reaction System
  final Map<String, DateTime> _lastEmoteTime = {};
  static const Duration _emoteCooldown = Duration(seconds: 2);
  
  Future<void> sendEmote({
    required String roomId,
    required String userId,
    required String displayName,
    required EmoteType type,
  }) async {
    // Rate limiting - check cooldown
    final lastTime = _lastEmoteTime['$roomId-$userId'];
    if (lastTime != null) {
      final timeSinceLastEmote = DateTime.now().difference(lastTime);
      if (timeSinceLastEmote < _emoteCooldown) {
        throw 'Please wait ${(_emoteCooldown - timeSinceLastEmote).inSeconds} seconds before sending another emote';
      }
    }
    
    // Update last emote time
    _lastEmoteTime['$roomId-$userId'] = DateTime.now();
    
    // Create emote
    final emote = EmoteModel(
      userId: userId,
      displayName: displayName,
      type: type,
      timestamp: DateTime.now(),
    );
    
    // Send emote to room's emotes subcollection
    await _firestore
        .collection(_roomsCollection)
        .doc(roomId)
        .collection('emotes')
        .add(emote.toJson());
    
    // Auto-delete emote after 5 seconds
    Timer(const Duration(seconds: 5), () async {
      final emoteDocs = await _firestore
          .collection(_roomsCollection)
          .doc(roomId)
          .collection('emotes')
          .where('timestamp', isLessThan: DateTime.now().subtract(const Duration(seconds: 5)).toIso8601String())
          .get();
      
      for (final doc in emoteDocs.docs) {
        await doc.reference.delete();
      }
    });
  }
  
  // Stream emotes for a room
  Stream<List<EmoteModel>> streamEmotes(String roomId) {
    return _firestore
        .collection(_roomsCollection)
        .doc(roomId)
        .collection('emotes')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EmoteModel.fromJson(doc.data()))
            .toList());
  }

  // Room Lifecycle Management
  Future<void> cleanupAbandonedRooms() async {
    final cutoffTime = DateTime.now().subtract(const Duration(hours: 24));
    
    final abandonedRooms = await _firestore
        .collection(_roomsCollection)
        .where('status', isEqualTo: RoomStatus.waiting.name)
        .where('updatedAt', isLessThan: cutoffTime.toIso8601String())
        .get();
    
    for (final doc in abandonedRooms.docs) {
      await doc.reference.delete();
      print('🧹 Cleaned up abandoned room: ${doc.id}');
    }
  }
  
  // Host migration
  Future<void> migrateHost(String roomId, String oldHostId) async {
    final doc = await _firestore.collection(_roomsCollection).doc(roomId).get();
    if (!doc.exists) return;
    
    final room = RoomModel.fromJson({...doc.data()!, 'id': doc.id});
    
    // Find online players excluding old host
    final onlinePlayers = room.players
        .where((p) => p.userId != oldHostId && p.isOnline)
        .toList();
    
    if (onlinePlayers.isEmpty) {
      // No online players, room will be deleted
      await doc.reference.delete();
      return;
    }
    
    // Assign new host (first online player)
    final newHost = onlinePlayers.first;
    
    await doc.reference.update({
      'hostId': newHost.userId,
      'hostName': newHost.displayName,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    
    print('👑 Host migrated from $oldHostId to ${newHost.userId}');
  }
  
  // Handle player reconnection
  Future<RoomModel?> handleReconnection(String userId) async {
    // Find rooms where user is a player and game is in progress
    final activeRooms = await _firestore
        .collection(_roomsCollection)
        .where('status', isEqualTo: RoomStatus.inProgress.name)
        .get();
    
    for (final doc in activeRooms.docs) {
      final room = RoomModel.fromJson({...doc.data(), 'id': doc.id});
      final playerIndex = room.players.indexWhere((p) => p.userId == userId);
      
      if (playerIndex != -1) {
        // Update player online status
        final updatedPlayers = [...room.players];
        updatedPlayers[playerIndex] = updatedPlayers[playerIndex].copyWith(
          isOnline: true,
          lastSeen: DateTime.now(),
        );
        
        await doc.reference.update({
          'players': updatedPlayers.map((p) => p.toJson()).toList(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
        
        return room.copyWith(players: updatedPlayers);
      }
    }
    
    return null;
  }

  // Start game (host only)
  Future<void> startGame(String roomId, String hostId) async {
    final doc = await _firestore.collection(_roomsCollection).doc(roomId).get();
    if (!doc.exists) throw 'Room not found';

    final room = RoomModel.fromJson({...doc.data()!, 'id': doc.id});
    if (room.hostId != hostId) throw 'Only the host can start the game';

    // Check minimum players
    final readyPlayers = room.players.where((p) => p.isReady).length;
    if (readyPlayers < room.settings.minPlayers) {
      throw 'Need at least ${room.settings.minPlayers} ready players to start';
    }

    await _firestore.collection(_roomsCollection).doc(roomId).update({
      'status': RoomStatus.starting.name,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
}