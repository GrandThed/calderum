import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/friend_model.dart';
import '../services/friends_service.dart';
import '../../account/models/user_model.dart';
import '../../account/services/auth_service.dart';

part 'friends_viewmodel.g.dart';

@riverpod
class SendFriendRequest extends _$SendFriendRequest {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> sendRequest(String toUserId, String toDisplayName, [String? toPhotoUrl]) async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      final friendsService = ref.read(friendsServiceProvider);
      final currentUser = await authService.getCurrentUserModel();
      
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      await friendsService.sendFriendRequest(
        fromUser: currentUser,
        toUserId: toUserId,
        toDisplayName: toDisplayName,
        toPhotoUrl: toPhotoUrl,
      );

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

@riverpod
class FriendRequestAction extends _$FriendRequestAction {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> acceptRequest(String requestId) async {
    state = const AsyncValue.loading();
    
    try {
      final friendsService = ref.read(friendsServiceProvider);
      await friendsService.acceptFriendRequest(requestId);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> rejectRequest(String requestId) async {
    state = const AsyncValue.loading();
    
    try {
      final friendsService = ref.read(friendsServiceProvider);
      await friendsService.rejectFriendRequest(requestId);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

@riverpod
class UserSearch extends _$UserSearch {
  @override
  AsyncValue<List<UserModel>> build() {
    return const AsyncValue.data([]);
  }

  Future<void> search(String query) async {
    if (query.trim().length < 2) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final friendsService = ref.read(friendsServiceProvider);
      final users = await friendsService.searchUsers(query);
      state = AsyncValue.data(users);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

@riverpod
Stream<List<FriendModel>> friendsStream(FriendsStreamRef ref, String userId) {
  final friendsService = ref.watch(friendsServiceProvider);
  return friendsService.streamFriends(userId);
}

@riverpod
Stream<List<FriendRequestModel>> incomingRequestsStream(IncomingRequestsStreamRef ref, String userId) {
  final friendsService = ref.watch(friendsServiceProvider);
  return friendsService.streamIncomingRequests(userId);
}

@riverpod
Stream<List<FriendRequestModel>> outgoingRequestsStream(OutgoingRequestsStreamRef ref, String userId) {
  final friendsService = ref.watch(friendsServiceProvider);
  return friendsService.streamOutgoingRequests(userId);
}

@riverpod
Stream<List<RecentPlayerModel>> recentPlayersStream(RecentPlayersStreamRef ref, String userId) {
  final friendsService = ref.watch(friendsServiceProvider);
  return friendsService.streamRecentPlayers(userId);
}