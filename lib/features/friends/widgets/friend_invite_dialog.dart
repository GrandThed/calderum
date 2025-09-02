import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../models/friend_model.dart';
import '../viewmodels/friends_viewmodel.dart';
import '../../account/services/auth_service.dart';
import '../../../shared/theme/app_theme.dart';

class FriendInviteDialog extends ConsumerStatefulWidget {
  final String roomCode;

  const FriendInviteDialog({required this.roomCode, super.key});

  @override
  ConsumerState<FriendInviteDialog> createState() => _FriendInviteDialogState();
}

class _FriendInviteDialogState extends ConsumerState<FriendInviteDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.read(authServiceProvider).currentUser;

    if (currentUser == null) return const SizedBox.shrink();

    return AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      title: Row(
        children: [
          Icon(Icons.group_add, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            'Invite Friends',
            style: AppTheme.headlineStyle.copyWith(fontSize: 24),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 400,
        child: Column(
          children: [
            // Share room code section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.vpn_key, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Room Code: ${widget.roomCode}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFamily: 'Caudex',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _shareRoomCode,
                        icon: const Icon(Icons.share),
                        tooltip: 'Share room code',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share this code with friends or invite them directly',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab bar
            TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: Colors.white60,
              indicatorColor: theme.colorScheme.primary,
              tabs: const [
                Tab(text: 'Friends'),
                Tab(text: 'Recent Players'),
              ],
            ),
            const SizedBox(height: 8),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFriendsTab(currentUser.uid),
                  _buildRecentPlayersTab(currentUser.uid),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendsTab(String userId) {
    final friendsAsync = ref.watch(friendsStreamProvider(userId));

    return friendsAsync.when(
      data: (friends) {
        if (friends.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 48, color: Colors.white60),
                const SizedBox(height: 16),
                Text(
                  'No friends yet',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white60),
                ),
                Text(
                  'Add friends to invite them to games',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white60),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return _buildPlayerTile(
              friend.displayName,
              friend.photoUrl,
              friend.isOnline,
              () => _inviteFriend(friend),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error loading friends: $error')),
    );
  }

  Widget _buildRecentPlayersTab(String userId) {
    final recentPlayersAsync = ref.watch(recentPlayersStreamProvider(userId));

    return recentPlayersAsync.when(
      data: (players) {
        if (players.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 48, color: Colors.white60),
                const SizedBox(height: 16),
                Text(
                  'No recent players',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white60),
                ),
                Text(
                  'Players you\'ve recently played with will appear here',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white60),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return _buildPlayerTile(
              player.displayName,
              player.photoUrl,
              false, // Recent players don't have online status
              () => _inviteRecentPlayer(player),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Error loading recent players: $error')),
    );
  }

  Widget _buildPlayerTile(
    String displayName,
    String? photoUrl,
    bool isOnline,
    VoidCallback onInvite,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
              child: photoUrl == null
                  ? Text(displayName[0].toUpperCase())
                  : null,
            ),
            if (isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          displayName,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: isOnline
            ? Text(
                'Online',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.green),
              )
            : null,
        trailing: IconButton(
          onPressed: onInvite,
          icon: Icon(Icons.send, color: theme.colorScheme.primary),
          tooltip: 'Send invitation',
        ),
      ),
    );
  }

  void _shareRoomCode() {
    Share.share(
      'Join my Calderum game! Room code: ${widget.roomCode}',
      subject: 'Calderum Game Invitation',
    );
  }

  void _inviteFriend(FriendModel friend) {
    Share.share(
      'Hey ${friend.displayName}! Join my Calderum game! Room code: ${widget.roomCode}',
      subject: 'Calderum Game Invitation',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invitation sent to ${friend.displayName}!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _inviteRecentPlayer(RecentPlayerModel player) {
    Share.share(
      'Hey ${player.displayName}! Join my Calderum game! Room code: ${widget.roomCode}',
      subject: 'Calderum Game Invitation',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invitation sent to ${player.displayName}!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
