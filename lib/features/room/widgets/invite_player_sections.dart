import 'package:calderum/core/services/global_services.dart';
import 'package:calderum/features/room/services/room_player_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvitePlayersSection extends ConsumerStatefulWidget {
  final String roomId;

  const InvitePlayersSection({super.key, required this.roomId});

  @override
  ConsumerState<InvitePlayersSection> createState() =>
      _InvitePlayersSectionState();
}

class _InvitePlayersSectionState extends ConsumerState<InvitePlayersSection> {
  List<String> previousPlayerIds = [];
  final selected = <String>{};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreviousPlayers();
  }

  Future<void> _loadPreviousPlayers() async {
    final userId = GlobalServices.currentUserId;
    if (userId == null) return;

    final players = await RoomPlayerService().getPreviousPlayers(userId);
    setState(() {
      previousPlayerIds = players;
      loading = false;
    });
  }

  Future<void> _inviteSelected() async {
    for (final id in selected) {
      await RoomPlayerService().addPlayerToRoom(widget.roomId, id);
    }

    setState(() {
      selected.clear();
    });

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Players invited')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (previousPlayerIds.isEmpty) {
      return const Text('You haven\'t played with anyone yet.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Invite past players:'),
        const SizedBox(height: 8),
        ...previousPlayerIds.map((id) {
          final isSelected = selected.contains(id);
          return CheckboxListTile(
            title: Text(
              'Player ID: $id',
            ), // TODO reemplazar por nombre/email si lo tenés
            value: isSelected,
            onChanged: (val) {
              setState(() {
                val! ? selected.add(id) : selected.remove(id);
              });
            },
          );
        }),
        ElevatedButton(
          onPressed: selected.isEmpty ? null : _inviteSelected,
          child: const Text('Invite selected'),
        ),
      ],
    );
  }
}
