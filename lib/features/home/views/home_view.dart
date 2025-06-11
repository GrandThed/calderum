import 'package:calderum/core/services/global_services.dart';
import 'package:calderum/core/widgets/calderum_app_bar.dart';
import 'package:calderum/features/account/viewmodels/auth_viewmodel.dart';
import 'package:calderum/features/room/services/room_services.dart';
import 'package:calderum/features/room/viewmodels/room_viewmodel.dart';
import 'package:calderum/features/room/views/create_room_view.dart';
import 'package:calderum/features/room/widgets/room_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  static const routeName = '/home';

  @override
  ConsumerState<HomeView> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeView> {
  final roomIdController = TextEditingController();
  final roomService = RoomService();

  Future<void> _joinRoom() async {
    final userId = GlobalServices.currentUserId;
    final code = roomIdController.text.trim();

    if (code.isEmpty || userId == null) return;

    final room = await RoomService().getRoomByInviteCode(code);
    if (room == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Room not found')));
      }
      return;
    }

    if (!room.playerIds.contains(userId)) {
      await RoomService().joinRoom(room.id, userId);
    }

    if (context.mounted) {
      context.push('/room/${room.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = GlobalServices.currentUser?.email ?? 'Guest';
    final roomState = ref.watch(roomViewModelProvider);

    return Scaffold(
      appBar: const CalderumAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // logout
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                ref.read(authViewModelProvider.notifier).logout();
                context.go('/');
              },
            ),
            Text(
              'Welcome, $email',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () {
                context.push(CreateRoomScreen.routeName);
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Room'),
            ),

            ElevatedButton.icon(
              onPressed: () {
                context.push(CreateRoomScreen.routeName);
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Room'),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: roomIdController,
              decoration: const InputDecoration(
                labelText: 'Room ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _joinRoom,
              child: const Text('Join Room'),
            ),
            Expanded(
              child: roomState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (rooms) => RoomList(rooms: rooms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
