import 'package:flutter/material.dart';
import '../models/room_model.dart';

class PlayerListTile extends StatelessWidget {
  final RoomPlayerModel player;
  final bool isHost;
  final bool isCurrentUser;

  const PlayerListTile({
    required this.player,
    required this.isHost,
    required this.isCurrentUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrentUser 
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.5))
            : null,
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: player.photoUrl != null
                  ? NetworkImage(player.photoUrl!)
                  : null,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: player.photoUrl == null
                  ? Text(
                      player.displayName.isNotEmpty 
                          ? player.displayName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: player.isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                player.displayName,
                style: TextStyle(
                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentUser 
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (isHost)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '👑 Host',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isCurrentUser)
              Text(
                'You',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.primary,
                ),
              ),
            Row(
              children: [
                Icon(
                  player.isOnline ? Icons.circle : Icons.circle_outlined,
                  size: 12,
                  color: player.isOnline ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  player.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: player.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                if (!player.isOnline && player.lastSeen != null)
                  Text(
                    'Last seen: ${_formatLastSeen(player.lastSeen!)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: player.isReady 
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            player.isReady ? '✅ Ready' : '⏳ Not Ready',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: player.isReady 
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onErrorContainer,
            ),
          ),
        ),
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}