import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../models/room_model.dart';
import '../viewmodels/room_viewmodel.dart';
import '../widgets/player_list_tile.dart';
import '../services/room_service.dart';
import '../../friends/widgets/friend_invite_dialog.dart';
import '../../account/services/auth_service.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../../../shared/widgets/calderum_app_bar.dart';
import '../../../shared/theme/room_design_system.dart';
import '../../../shared/theme/app_theme.dart';

class RoomLobbyView extends ConsumerWidget {
  final String roomId;

  const RoomLobbyView({required this.roomId, super.key});

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
              Text('Room not found', style: theme.textTheme.headlineSmall),
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
        title: 'Game Lobby',
        showBackButton: true, // Enable back button to return home
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () => _showInviteFriendsDialog(context, room.code),
            tooltip: 'Invite friends',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareRoom(room),
            tooltip: 'Share room code',
          ),
          if (isHost)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'dismiss_room':
                    _showDismissRoomConfirmation(context, ref, room);
                    break;
                  case 'kick_all':
                    _showKickAllDialog(context, ref);
                    break;
                }
              },
              itemBuilder: (context) => [
                if (room.status == RoomStatus.waiting)
                  const PopupMenuItem(
                    value: 'dismiss_room',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, color: Colors.red),
                      title: Text(
                        'Dismiss Room',
                        style: TextStyle(color: Colors.red),
                      ),
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
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(RoomDesignSystem.screenPadding),
            child: Column(
              children: [
                // Room info card
                Container(
                  decoration: RoomDesignSystem.roomInfoCardDecoration(
                    AppTheme.surfaceColor,
                  ),
                  padding: const EdgeInsets.all(RoomDesignSystem.cardPadding),
                  child: Row(
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
                ),

                const SizedBox(height: RoomDesignSystem.secondarySection),

                // Room settings card
                Container(
                  decoration: RoomDesignSystem.roomInfoCardDecoration(
                    AppTheme.surfaceColor,
                  ),
                  padding: const EdgeInsets.all(RoomDesignSystem.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Room Settings',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontFamily: 'Caudex',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: RoomDesignSystem.spacingMd),

                      SettingRow(
                        icon: _getIngredientSetIcon(
                          room.settings.ingredientSet,
                        ),
                        label: 'Ingredient Set',
                        value: _getIngredientSetName(
                          room.settings.ingredientSet,
                        ),
                        canEdit: isHost && room.status == RoomStatus.waiting,
                        onTap: () =>
                            _showIngredientSetSelector(context, ref, room),
                      ),
                      const SizedBox(height: RoomDesignSystem.spacingSm),
                      SettingRow(
                        icon: Icons.science,
                        label: 'Test Tube Variant',
                        value: room.settings.testTubeVariant
                            ? 'Enabled'
                            : 'Disabled',
                        canEdit: isHost && room.status == RoomStatus.waiting,
                        onTap: () => _toggleTestTube(context, ref, room),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: RoomDesignSystem.secondarySection),

                // Players list
                Container(
                  decoration: RoomDesignSystem.roomInfoCardDecoration(
                    AppTheme.surfaceColor,
                  ),
                  padding: const EdgeInsets.all(RoomDesignSystem.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.group, color: theme.colorScheme.primary),
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
                      const SizedBox(height: RoomDesignSystem.spacingMd),
                      ...room.players.map(
                        (player) => PlayerListTile(
                          player: player,
                          isHost: player.userId == room.hostId,
                          isCurrentUser: player.userId == currentUserId,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: RoomDesignSystem.secondarySection),

                // Action buttons
                if (currentPlayer != null) ...[
                  lobbyState.when(
                    data: (_) => Column(
                      children: [
                        if (!isHost)
                          SizedBox(
                            width: double.infinity,
                            child: CalderumButton(
                              text: currentPlayer.isReady
                                  ? '⏸️ Not Ready'
                                  : '✅ Ready',
                              onPressed: () => ref
                                  .read(
                                    roomLobbyViewModelProvider(roomId).notifier,
                                  )
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
                                  ? () => _startGame(context, ref)
                                  : null,
                              style: CalderumButtonStyle.primary,
                            ),
                          ),
                          const SizedBox(height: RoomDesignSystem.spacingSm),
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
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onErrorContainer,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ],
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (_, _) => const SizedBox(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
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

  Future<void> _startGame(BuildContext context, WidgetRef ref) async {
    try {
      final gameId = await ref
          .read(roomLobbyViewModelProvider(roomId).notifier)
          .startGame();

      if (gameId != null && context.mounted) {
        context.go('/game/$gameId');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start game: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _shareRoom(RoomModel room) {
    Share.share(
      'Join my Calderum game! Room code: ${room.code}',
      subject: 'Calderum Game Invitation',
    );
  }

  void _showInviteFriendsDialog(BuildContext context, String roomCode) {
    showDialog(
      context: context,
      builder: (context) => FriendInviteDialog(roomCode: roomCode),
    );
  }

  void _copyRoomCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room code copied to clipboard!')),
    );
  }

  void _showKickAllDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement kick all dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kick all players coming soon!')),
    );
  }

  Future<void> _showDismissRoomConfirmation(
    BuildContext context,
    WidgetRef ref,
    RoomModel room,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => _buildDismissRoomDialog(room, context),
    );

    if (shouldDelete == true && context.mounted) {
      await _dismissRoom(context, ref, room);
    }
  }

  Widget _buildDismissRoomDialog(RoomModel room, BuildContext context) {
    final otherPlayersCount = room.players.length - 1;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: AppTheme.secondaryColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'Dismiss Room?',
            style: AppTheme.titleStyle.copyWith(
              fontFamily: 'Caveat',
              color: AppTheme.secondaryColor,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to dismiss Room ${room.code}?',
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white.withValues(alpha: 0.87),
            ),
          ),
          if (otherPlayersCount > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.people_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$otherPlayersCount other player${otherPlayersCount == 1 ? '' : 's'} will be removed',
                      style: AppTheme.bodyStyle.copyWith(
                        fontSize: 14,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Dismiss Room',
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _dismissRoom(
    BuildContext context,
    WidgetRef ref,
    RoomModel room,
  ) async {
    try {
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      final currentUser = authService.currentUser;

      if (currentUser == null) {
        throw 'User not authenticated';
      }

      await roomService.deleteRoom(room.id, currentUser.uid);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text('Room ${room.code} dismissed successfully'),
              ],
            ),
            backgroundColor: AppTheme.primaryColor,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Navigate back to home
        context.go('/home');
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed to dismiss room: $error')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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

  void _showIngredientSetSelector(
    BuildContext context,
    WidgetRef ref,
    RoomModel room,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Ingredient Set',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Caudex',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...IngredientSet.values.map((set) {
              final isSelected = room.settings.ingredientSet == set;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(_getIngredientSetIcon(set)),
                  title: Text(_getIngredientSetName(set)),
                  selected: isSelected,
                  onTap: () {
                    Navigator.pop(context);
                    _updateIngredientSet(context, ref, room, set);
                  },
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _toggleTestTube(BuildContext context, WidgetRef ref, RoomModel room) {
    _updateTestTube(context, ref, room, !room.settings.testTubeVariant);
  }

  Future<void> _updateIngredientSet(
    BuildContext context,
    WidgetRef ref,
    RoomModel room,
    IngredientSet set,
  ) async {
    try {
      final updatedSettings = room.settings.copyWith(ingredientSet: set);
      final currentUserId = ref.read(authServiceProvider).currentUser?.uid;

      await ref
          .read(roomServiceProvider)
          .updateRoomSettings(room.id, currentUserId!, updatedSettings);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ingredient set updated to ${_getIngredientSetName(set)}',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update ingredient set: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _updateTestTube(
    BuildContext context,
    WidgetRef ref,
    RoomModel room,
    bool hasTestTube,
  ) async {
    try {
      final updatedSettings = room.settings.copyWith(
        testTubeVariant: hasTestTube,
      );
      final currentUserId = ref.read(authServiceProvider).currentUser?.uid;

      await ref
          .read(roomServiceProvider)
          .updateRoomSettings(room.id, currentUserId!, updatedSettings);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Test tube variant ${hasTestTube ? 'enabled' : 'disabled'}',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update test tube variant: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool canEdit;
  final VoidCallback? onTap;

  const SettingRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.canEdit = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canEdit ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: canEdit
                ? AppTheme.primaryColor.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: canEdit
                  ? AppTheme.primaryColor.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 18, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (canEdit) ...[
                Icon(Icons.edit, size: 18, color: AppTheme.primaryColor),
              ] else ...[
                Icon(Icons.lock, size: 16, color: Colors.white38),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
