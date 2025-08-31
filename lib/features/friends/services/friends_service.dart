import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/friend_model.dart';
import '../../account/models/user_model.dart';

final friendsServiceProvider = Provider<FriendsService>((ref) {
  return FriendsService(FirebaseFirestore.instance);
});

class FriendsService {
  final FirebaseFirestore _firestore;
  static const String _friendsCollection = 'friends';
  static const String _friendRequestsCollection = 'friend_requests';
  static const String _recentPlayersCollection = 'recent_players';

  FriendsService(this._firestore);

  // Send friend request
  Future<void> sendFriendRequest({
    required UserModel fromUser,
    required String toUserId,
    required String toDisplayName,
    String? toPhotoUrl,
  }) async {
    // Check if users are already friends
    final existingFriendship = await _firestore
        .collection(_friendsCollection)
        .doc(fromUser.uid)
        .collection('user_friends')
        .doc(toUserId)
        .get();

    if (existingFriendship.exists) {
      throw 'You are already friends with this user';
    }

    // Check if request already exists
    final existingRequest = await _firestore
        .collection(_friendRequestsCollection)
        .where('fromUserId', isEqualTo: fromUser.uid)
        .where('toUserId', isEqualTo: toUserId)
        .where('status', isEqualTo: FriendRequestStatus.pending.name)
        .get();

    if (existingRequest.docs.isNotEmpty) {
      throw 'Friend request already sent';
    }

    // Create friend request
    final request = FriendRequestModel(
      id: '', // Will be set by Firestore
      fromUserId: fromUser.uid,
      fromDisplayName: fromUser.displayName,
      fromPhotoUrl: fromUser.photoUrl,
      toUserId: toUserId,
      toDisplayName: toDisplayName,
      toPhotoUrl: toPhotoUrl,
      sentAt: DateTime.now(),
    );

    await _firestore.collection(_friendRequestsCollection).add(request.toJson());
  }

  // Accept friend request
  Future<void> acceptFriendRequest(String requestId) async {
    final requestDoc = await _firestore
        .collection(_friendRequestsCollection)
        .doc(requestId)
        .get();

    if (!requestDoc.exists) {
      throw 'Friend request not found';
    }

    final request = FriendRequestModel.fromJson({
      ...requestDoc.data()!,
      'id': requestDoc.id,
    });

    // Create friendship for both users
    final batch = _firestore.batch();

    // Add friend to sender's list
    batch.set(
      _firestore
          .collection(_friendsCollection)
          .doc(request.fromUserId)
          .collection('user_friends')
          .doc(request.toUserId),
      FriendModel(
        userId: request.toUserId,
        displayName: request.toDisplayName,
        photoUrl: request.toPhotoUrl,
        addedAt: DateTime.now(),
        isOnline: false, // Will be updated by presence system
      ).toJson(),
    );

    // Add friend to receiver's list
    batch.set(
      _firestore
          .collection(_friendsCollection)
          .doc(request.toUserId)
          .collection('user_friends')
          .doc(request.fromUserId),
      FriendModel(
        userId: request.fromUserId,
        displayName: request.fromDisplayName,
        photoUrl: request.fromPhotoUrl,
        addedAt: DateTime.now(),
        isOnline: false, // Will be updated by presence system
      ).toJson(),
    );

    // Update request status
    batch.update(
      requestDoc.reference,
      {'status': FriendRequestStatus.accepted.name},
    );

    await batch.commit();
  }

  // Reject friend request
  Future<void> rejectFriendRequest(String requestId) async {
    await _firestore.collection(_friendRequestsCollection).doc(requestId).update({
      'status': FriendRequestStatus.rejected.name,
    });
  }

  // Remove friend
  Future<void> removeFriend(String currentUserId, String friendUserId) async {
    final batch = _firestore.batch();

    // Remove from current user's friends
    batch.delete(
      _firestore
          .collection(_friendsCollection)
          .doc(currentUserId)
          .collection('user_friends')
          .doc(friendUserId),
    );

    // Remove from friend's friends
    batch.delete(
      _firestore
          .collection(_friendsCollection)
          .doc(friendUserId)
          .collection('user_friends')
          .doc(currentUserId),
    );

    await batch.commit();
  }

  // Get user's friends
  Stream<List<FriendModel>> streamFriends(String userId) {
    return _firestore
        .collection(_friendsCollection)
        .doc(userId)
        .collection('user_friends')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FriendModel.fromJson(doc.data()))
            .toList());
  }

  // Get incoming friend requests
  Stream<List<FriendRequestModel>> streamIncomingRequests(String userId) {
    return _firestore
        .collection(_friendRequestsCollection)
        .where('toUserId', isEqualTo: userId)
        .where('status', isEqualTo: FriendRequestStatus.pending.name)
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FriendRequestModel.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList());
  }

  // Get outgoing friend requests
  Stream<List<FriendRequestModel>> streamOutgoingRequests(String userId) {
    return _firestore
        .collection(_friendRequestsCollection)
        .where('fromUserId', isEqualTo: userId)
        .where('status', isEqualTo: FriendRequestStatus.pending.name)
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FriendRequestModel.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList());
  }

  // Add recent player
  Future<void> addRecentPlayer({
    required String currentUserId,
    required String playerId,
    required String playerName,
    String? playerPhotoUrl,
  }) async {
    if (currentUserId == playerId) return; // Don't add self

    final recentPlayerRef = _firestore
        .collection(_recentPlayersCollection)
        .doc(currentUserId)
        .collection('players')
        .doc(playerId);

    final existingPlayer = await recentPlayerRef.get();

    if (existingPlayer.exists) {
      // Update existing player
      final current = RecentPlayerModel.fromJson(existingPlayer.data()!);
      await recentPlayerRef.update({
        'lastPlayedWith': DateTime.now().toIso8601String(),
        'gamesPlayed': current.gamesPlayed + 1,
      });
    } else {
      // Add new recent player
      final recentPlayer = RecentPlayerModel(
        userId: playerId,
        displayName: playerName,
        photoUrl: playerPhotoUrl,
        lastPlayedWith: DateTime.now(),
        gamesPlayed: 1,
      );
      await recentPlayerRef.set(recentPlayer.toJson());
    }
  }

  // Get recent players
  Stream<List<RecentPlayerModel>> streamRecentPlayers(String userId) {
    return _firestore
        .collection(_recentPlayersCollection)
        .doc(userId)
        .collection('players')
        .orderBy('lastPlayedWith', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RecentPlayerModel.fromJson(doc.data()))
            .toList());
  }

  // Search users by display name (for friend requests)
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.trim().length < 2) return [];

    final usersQuery = await _firestore
        .collection('users')
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThan: '${query}z')
        .limit(10)
        .get();

    return usersQuery.docs
        .map((doc) => UserModel.fromJson({...doc.data(), 'uid': doc.id}))
        .toList();
  }
}