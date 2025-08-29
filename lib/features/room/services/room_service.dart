import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room_model.dart';
import '../models/room_invitation_model.dart';
import '../../account/models/user_model.dart';

final roomServiceProvider = Provider<RoomService>((ref) {
  return RoomService(FirebaseFirestore.instance);
});

class RoomService {
  final FirebaseFirestore _firestore;
  static const String _roomsCollection = 'rooms';
  static const String _invitationsCollection = 'room_invitations';

  RoomService(this._firestore);

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

    final docRef = await _firestore.collection(_roomsCollection).add(room.toJson());
    
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