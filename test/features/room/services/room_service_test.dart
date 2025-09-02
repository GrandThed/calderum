import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:calderum/features/room/services/room_service.dart';
import 'package:calderum/features/room/models/room_model.dart';
import 'package:calderum/features/account/models/user_model.dart';
import 'package:calderum/features/friends/services/friends_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFriendsService extends Mock implements FriendsService {}

void main() {
  group('RoomService - Room Gathering Tests', () {
    late FakeFirebaseFirestore firestore;
    late MockFriendsService friendsService;
    late RoomService roomService;
    late UserModel testUser;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      friendsService = MockFriendsService();
      roomService = RoomService(firestore, friendsService);
      
      testUser = UserModel(
        uid: 'test-user-123',
        displayName: 'Test User',
        email: 'test@example.com',
        photoUrl: null,
        isAnonymous: false,
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        lastLogin: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );
    });

    Future<void> createTestRoom({
      required String roomId,
      required RoomStatus status,
      required String userId,
    }) async {
      final room = RoomModel(
        id: roomId,
        code: 'TEST$roomId'.substring(0, 6).toUpperCase(),
        hostId: userId,
        hostName: testUser.displayName,
        players: [
          RoomPlayerModel(
            userId: userId,
            displayName: testUser.displayName,
            photoUrl: testUser.photoUrl,
            isOnline: true,
            isReady: true,
            joinedAt: DateTime.now(),
            lastSeen: DateTime.now(),
          ),
        ],
        settings: const RoomSettingsModel(),
        status: status,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await firestore.collection('rooms').doc(roomId).set(room.toJson());
    }

    test('streamUserRooms should return rooms with all active statuses', () async {
      // Create test rooms with different statuses
      await createTestRoom(
        roomId: 'room1',
        status: RoomStatus.waiting,
        userId: testUser.uid,
      );
      
      await createTestRoom(
        roomId: 'room2',
        status: RoomStatus.starting,
        userId: testUser.uid,
      );
      
      await createTestRoom(
        roomId: 'room3',
        status: RoomStatus.inProgress,
        userId: testUser.uid,
      );
      
      await createTestRoom(
        roomId: 'room4',
        status: RoomStatus.paused,
        userId: testUser.uid,
      );
      
      await createTestRoom(
        roomId: 'room5',
        status: RoomStatus.finished,
        userId: testUser.uid,
      );

      // Test the stream
      final roomsStream = roomService.streamUserRooms(testUser.uid);
      final rooms = await roomsStream.first;

      print('Found ${rooms.length} rooms');
      for (final room in rooms) {
        print('Room ${room.id}: ${room.status.name}');
      }

      // Should return all rooms except finished ones
      expect(rooms.length, equals(4), reason: 'Should return waiting, starting, inProgress, and paused rooms');
      
      final statuses = rooms.map((r) => r.status).toSet();
      expect(statuses, containsAll([
        RoomStatus.waiting,
        RoomStatus.starting,
        RoomStatus.inProgress,
        RoomStatus.paused,
      ]), reason: 'Should include all active statuses');
      
      expect(statuses, isNot(contains(RoomStatus.finished)), 
             reason: 'Should not include finished rooms');
    });

    test('streamUserRooms currently only returns waiting and inProgress rooms (bug demonstration)', () async {
      // Create test rooms with different statuses
      await createTestRoom(
        roomId: 'room1',
        status: RoomStatus.waiting,
        userId: testUser.uid,
      );
      
      await createTestRoom(
        roomId: 'room2',
        status: RoomStatus.starting,
        userId: testUser.uid,
      );
      
      await createTestRoom(
        roomId: 'room3',
        status: RoomStatus.inProgress,
        userId: testUser.uid,
      );
      
      await createTestRoom(
        roomId: 'room4',
        status: RoomStatus.paused,
        userId: testUser.uid,
      );

      // Test the current implementation
      final roomsStream = roomService.streamUserRooms(testUser.uid);
      final rooms = await roomsStream.first;

      print('Current implementation returns ${rooms.length} rooms');
      for (final room in rooms) {
        print('Room ${room.id}: ${room.status.name}');
      }

      // This test demonstrates the bug - only 2 rooms are returned instead of 4
      expect(rooms.length, equals(2), reason: 'Current implementation only returns 2 rooms due to bug');
      
      final statuses = rooms.map((r) => r.status).toSet();
      expect(statuses, equals({RoomStatus.waiting, RoomStatus.inProgress}), 
             reason: 'Current implementation only returns waiting and inProgress');
    });

    test('Firebase query should exclude only finished rooms', () async {
      // This test verifies what the correct query should return
      await createTestRoom(roomId: 'room1', status: RoomStatus.waiting, userId: testUser.uid);
      await createTestRoom(roomId: 'room2', status: RoomStatus.starting, userId: testUser.uid);
      await createTestRoom(roomId: 'room3', status: RoomStatus.inProgress, userId: testUser.uid);
      await createTestRoom(roomId: 'room4', status: RoomStatus.paused, userId: testUser.uid);
      await createTestRoom(roomId: 'room5', status: RoomStatus.finished, userId: testUser.uid);

      // Query all non-finished rooms directly from Firestore
      final querySnapshot = await firestore
          .collection('rooms')
          .where('status', isNotEqualTo: RoomStatus.finished.name)
          .get();

      final rooms = querySnapshot.docs
          .map((doc) => RoomModel.fromJson({...doc.data(), 'id': doc.id}))
          .where((room) => room.players.any((player) => player.userId == testUser.uid))
          .toList();

      print('Correct query returns ${rooms.length} rooms');
      for (final room in rooms) {
        print('Room ${room.id}: ${room.status.name}');
      }

      expect(rooms.length, equals(4), reason: 'Should return all non-finished rooms');
      
      final statuses = rooms.map((r) => r.status).toSet();
      expect(statuses, containsAll([
        RoomStatus.waiting,
        RoomStatus.starting,
        RoomStatus.inProgress,
        RoomStatus.paused,
      ]));
      expect(statuses, isNot(contains(RoomStatus.finished)));
    });
  });
}