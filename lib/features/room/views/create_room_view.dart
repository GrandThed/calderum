import 'package:calderum/core/services/global_services.dart';
import 'package:calderum/core/widgets/calderum_app_bar.dart';
import 'package:calderum/features/room/models/room.dart';
import 'package:calderum/features/room/viewmodels/room_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nanoid/nanoid.dart';
import 'package:uuid/uuid.dart';

class CreateRoomScreen extends ConsumerStatefulWidget {
  const CreateRoomScreen({super.key});
  static const routeName = '/create-room';

  @override
  ConsumerState<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  final nameController = TextEditingController();
  int roundCount = 9;

  Future<void> _submit() async {
    final userId = GlobalServices.currentUserId;
    if (userId == null) return;

    final room = Room(
      id: const Uuid().v4(),
      name: nameController.text.trim().isEmpty
          ? 'New Room'
          : nameController.text.trim(),
      hostId: userId,
      inviteCode: nanoid(8),
      status: RoomStatus.creating,
      round: roundCount,
      createdAt: DateTime.now(),
    );

    await ref.read(roomViewModelProvider.notifier).createRoom(room);

    if (context.mounted) {
      context.go('/room/${room.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CalderumAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a Room',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Room name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                const Text('Rounds:'),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: roundCount,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        roundCount = value;
                      });
                    }
                  },
                  items: [5, 7, 9]
                      .map(
                        (round) => DropdownMenuItem(
                          value: round,
                          child: Text('$round'),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Create Room'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
