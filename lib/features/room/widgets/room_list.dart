import 'package:calderum/features/room/models/room.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomList extends StatelessWidget {
  final List<Room> rooms;

  const RoomList({super.key, required this.rooms});

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const Center(child: Text('No rooms you\'re invited to yet'));
    }

    return ListView.separated(
      itemCount: rooms.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final room = rooms[index];

        return ListTile(
          title: Text(room.name),
          subtitle: Row(
            children: [
              // Text('${room.playerIds.length}/${room.maxPlayers} players'),
              const SizedBox(width: 12),
              _statusChip(room.status, context),
            ],
          ),
          trailing: const Icon(Icons.meeting_room),
          onTap: () {
            context.go('/room/${room.id}');
          },
        );
      },
    );
  }

  Widget _statusChip(RoomStatus status, BuildContext context) {
    final label = switch (status) {
      RoomStatus.creating => 'Waiting',
      RoomStatus.inGame => 'In Game',
      RoomStatus.finished => 'Finished',
    };

    final color = switch (status) {
      RoomStatus.creating => Colors.amber,
      RoomStatus.inGame => Colors.green,
      RoomStatus.finished => Colors.grey,
    };

    return Chip(
      label: Text(label),
      backgroundColor: color.withAlpha((0.2 * 255).toInt()),
      labelStyle: TextStyle(color: color),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
