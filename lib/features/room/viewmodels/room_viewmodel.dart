import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';
import '../../account/models/user_model.dart';
import '../../account/services/auth_service.dart';

part 'room_viewmodel.g.dart';

@riverpod
class CreateRoomViewModel extends _$CreateRoomViewModel {
  @override
  AsyncValue<RoomModel?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createRoom({RoomSettingsModel? settings}) async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      
      print('🏠 Creating room - getting current user...');
      final currentUser = await authService.getCurrentUserModel();
      
      print('👤 Current user data:');
      print('   - User: ${currentUser?.uid}');
      print('   - Name: ${currentUser?.displayName}');
      print('   - Email: ${currentUser?.email}');
      print('   - Anonymous: ${currentUser?.isAnonymous}');
      print('   - Created: ${currentUser?.createdAt}');
      
      if (currentUser == null) {
        print('❌ User is null - throwing authentication error');
        throw 'User not authenticated';
      }

      print('✅ User found, creating room...');
      final room = await roomService.createRoom(
        host: currentUser,
        settings: settings,
      );
      print('🎉 Room created successfully: ${room.id}');

      state = AsyncValue.data(room);
    } catch (e, stackTrace) {
      print('❌ Error creating room: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

@riverpod
class JoinRoomViewModel extends _$JoinRoomViewModel {
  @override
  AsyncValue<RoomModel?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> joinRoom(String roomCode) async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      
      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      final room = await roomService.joinRoomByCode(
        roomCode: roomCode,
        user: currentUser,
      );

      state = AsyncValue.data(room);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

@riverpod
Stream<RoomModel> roomStream(RoomStreamRef ref, String roomId) {
  final roomService = ref.watch(roomServiceProvider);
  return roomService.streamRoom(roomId);
}

@riverpod
Stream<List<RoomModel>> userRoomsStream(UserRoomsStreamRef ref, String userId) {
  final roomService = ref.watch(roomServiceProvider);
  return roomService.streamUserRooms(userId);
}

@riverpod
class RoomLobbyViewModel extends _$RoomLobbyViewModel {
  @override
  AsyncValue<void> build(String roomId) {
    return const AsyncValue.data(null);
  }

  Future<void> toggleReady() async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      
      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      // Get current room state to determine current ready status
      final roomAsync = ref.read(roomStreamProvider(roomId));
      await roomAsync.when(
        data: (room) async {
          final currentPlayer = room.players.firstWhere(
            (p) => p.userId == currentUser.uid,
            orElse: () => throw 'Player not found in room',
          );
          
          await roomService.updatePlayerReady(
            roomId,
            currentUser.uid,
            !currentPlayer.isReady,
          );
        },
        loading: () => throw 'Room data not loaded',
        error: (error, _) => throw error,
      );

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> leaveRoom() async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      
      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      await roomService.leaveRoom(roomId, currentUser.uid);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> startGame() async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      
      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      await roomService.startGame(roomId, currentUser.uid);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateSettings(RoomSettingsModel settings) async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      
      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      await roomService.updateRoomSettings(roomId, currentUser.uid, settings);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}