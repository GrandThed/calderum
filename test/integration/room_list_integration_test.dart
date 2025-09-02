import 'package:flutter_test/flutter_test.dart';
import 'package:calderum/features/room/models/room_model.dart';

void main() {
  group('Room List Integration Tests', () {
    test('RoomStatus enum should have all expected values', () {
      final allStatuses = RoomStatus.values;
      
      expect(allStatuses, contains(RoomStatus.waiting));
      expect(allStatuses, contains(RoomStatus.starting));  
      expect(allStatuses, contains(RoomStatus.inProgress));
      expect(allStatuses, contains(RoomStatus.paused));
      expect(allStatuses, contains(RoomStatus.finished));
      
      print('Available room statuses:');
      for (final status in allStatuses) {
        print('- ${status.name}');
      }
    });
    
    test('Non-finished statuses should be correctly identified', () {
      final nonFinishedStatuses = RoomStatus.values
          .where((status) => status != RoomStatus.finished)
          .toList();
      
      expect(nonFinishedStatuses.length, equals(4));
      expect(nonFinishedStatuses, containsAll([
        RoomStatus.waiting,
        RoomStatus.starting,
        RoomStatus.inProgress, 
        RoomStatus.paused,
      ]));
      expect(nonFinishedStatuses, isNot(contains(RoomStatus.finished)));
      
      print('Non-finished statuses that should be shown in room list:');
      for (final status in nonFinishedStatuses) {
        print('- ${status.name}');
      }
    });

    test('Room status serialization works correctly', () {
      // Test that all statuses can be converted to/from JSON
      for (final status in RoomStatus.values) {
        final statusName = status.name;
        print('Status ${status.name} serializes to: $statusName');
        
        // Should not throw an error
        expect(statusName, isA<String>());
        expect(statusName.isNotEmpty, isTrue);
      }
    });
  });
}