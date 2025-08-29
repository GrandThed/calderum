import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../models/room_model.dart';
import '../viewmodels/room_viewmodel.dart';
import '../widgets/player_list_tile.dart';
import '../widgets/room_settings_card.dart';
import '../../account/services/auth_service.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../../../shared/widgets/calderum_app_bar.dart';

class RoomLobbyView extends ConsumerWidget {
  final String roomId;

  const RoomLobbyView({
    required this.roomId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomStreamProvider(roomId));
    final lobbyState = ref.watch(roomLobbyViewModelProvider(roomId));
    final theme = Theme.of(context);

    ref.listen(roomLobbyViewModelProvider(roomId), (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$error'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        },
      );
    });

    return roomAsync.when(
      data: (room) => _buildLobby(context, ref, room, lobbyState),
      loading: () => Scaffold(
        appBar: const CalderumAppBar(title: '🏠 Room'),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: const CalderumAppBar(title: '🏠 Room'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Room not found',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('$error'),
              const SizedBox(height: 24),
              CalderumButton(
                text: 'Back to Home',
                onPressed: () => context.go('/home'),
                style: CalderumButtonStyle.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLobby(
    BuildContext context,
    WidgetRef ref,
    RoomModel room,
    AsyncValue<void> lobbyState,
  ) {
    final theme = Theme.of(context);
    final currentUserId = ref.read(authServiceProvider).currentUser?.uid;
    final isHost = room.hostId == currentUserId;
    final currentPlayer = room.players.cast<RoomPlayerModel?>().firstWhere(
      (p) => p?.userId == currentUserId,
      orElse: () => null,
    );

    return Scaffold(
      appBar: CalderumAppBar(
        title: '🏠 Room ${room.code}',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareRoom(room),
            tooltip: 'Share room code',
          ),
          if (isHost)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'settings':
                    _showSettingsDialog(context, ref, room);
                    break;
                  case 'kick_all':
                    _showKickAllDialog(context, ref);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Room Settings'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'kick_all',
                  child: ListTile(
                    leading: Icon(Icons.clear_all),
                    title: Text('Kick All Players'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Room info card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.vpn_key,
                              color: theme.colorScheme.primary,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Room Code',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  SelectableText(
                                    room.code,
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      fontFamily: 'Caudex',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () => _copyRoomCode(context, room.code),
                              tooltip: 'Copy room code',
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoChip(
                              icon: Icons.people,
                              label: 'Players',
                              value: '${room.players.length}/${room.settings.maxPlayers}',
                              theme: theme,
                            ),
                            _buildInfoChip(
                              icon: Icons.timer,
                              label: 'Timer',
                              value: '${room.settings.turnTimerSeconds}s',
                              theme: theme,
                            ),
                            _buildInfoChip(
                              icon: _getIngredientSetIcon(room.settings.ingredientSet),
                              label: 'Set',
                              value: _getIngredientSetName(room.settings.ingredientSet),
                              theme: theme,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Players list
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.group,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Players (${room.players.length}/${room.settings.maxPlayers})',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontFamily: 'Caudex',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...room.players.map((player) => PlayerListTile(
                          player: player,
                          isHost: player.userId == room.hostId,
                          isCurrentUser: player.userId == currentUserId,
                        )),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Room settings
                RoomSettingsCard(settings: room.settings),
                
                const SizedBox(height: 24),
                
                // Action buttons
                if (currentPlayer != null) ...[
                  lobbyState.when(
                    data: (_) => Column(
                      children: [
                        if (!isHost)
                          SizedBox(
                            width: double.infinity,
                            child: CalderumButton(
                              text: currentPlayer.isReady ? '⏸️ Not Ready' : '✅ Ready',
                              onPressed: () => ref
                                  .read(roomLobbyViewModelProvider(roomId).notifier)
                                  .toggleReady(),
                              style: currentPlayer.isReady 
                                  ? CalderumButtonStyle.secondary
                                  : CalderumButtonStyle.primary,
                            ),
                          ),
                        
                        if (isHost) ...[
                          SizedBox(
                            width: double.infinity,
                            child: CalderumButton(
                              text: '🚀 Start Game',
                              onPressed: _canStartGame(room) 
                                  ? () => ref
                                      .read(roomLobbyViewModelProvider(roomId).notifier)
                                      .startGame()
                                  : null,
                              style: CalderumButtonStyle.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (!_canStartGame(room))
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: theme.colorScheme.onErrorContainer,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _getStartGameMessage(room),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onErrorContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                        
                        const SizedBox(height: 16),
                        
                        SizedBox(
                          width: double.infinity,
                          child: CalderumButton(
                            text: '🚪 Leave Room',
                            onPressed: () => _showLeaveDialog(context, ref),
                            style: CalderumButtonStyle.danger,
                          ),
                        ),
                      ],
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const SizedBox(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  IconData _getIngredientSetIcon(IngredientSet set) {
    switch (set) {
      case IngredientSet.set1:
        return Icons.looks_one;
      case IngredientSet.set2:
        return Icons.looks_two;
      case IngredientSet.set3:
        return Icons.looks_3;
      case IngredientSet.set4:
        return Icons.looks_4;
    }
  }

  String _getIngredientSetName(IngredientSet set) {
    switch (set) {
      case IngredientSet.set1:
        return 'Set 1';
      case IngredientSet.set2:
        return 'Set 2';
      case IngredientSet.set3:
        return 'Set 3';
      case IngredientSet.set4:
        return 'Set 4';
    }
  }

  bool _canStartGame(RoomModel room) {
    final readyPlayers = room.players.where((p) => p.isReady).length;
    return readyPlayers >= room.settings.minPlayers;
  }

  String _getStartGameMessage(RoomModel room) {
    final readyPlayers = room.players.where((p) => p.isReady).length;
    final needed = room.settings.minPlayers - readyPlayers;
    
    if (needed > 0) {
      return 'Need $needed more ready ${needed == 1 ? 'player' : 'players'} to start';
    }
    return '';
  }

  void _shareRoom(RoomModel room) {
    Share.share(
      'Join my Calderum game! Room code: ${room.code}',
      subject: 'Calderum Game Invitation',
    );
  }

  void _copyRoomCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room code copied to clipboard!')),
    );
  }

  void _showLeaveDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Room'),
        content: const Text('Are you sure you want to leave this room?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(roomLobbyViewModelProvider(roomId).notifier).leaveRoom();
              context.go('/home');
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref, RoomModel room) {
    // TODO: Implement settings dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room settings coming soon!')),
    );
  }

  void _showKickAllDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement kick all dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kick all players coming soon!')),
    );
  }
}