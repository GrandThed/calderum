import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/room_model.dart';
import '../../../shared/theme/app_theme.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: _getPlayerGradient(isCurrentUser, isHost),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getPlayerBorderColor(isCurrentUser, isHost),
          width: 2,
        ),
        boxShadow: [
          if (isCurrentUser)
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48, // Smaller width for compact design
            height: 48, // Smaller height for compact design
            child: Stack(
              clipBehavior: Clip.none, // Allow overflow for crown
              children: [
                Positioned(
                  bottom: 0,
                  left: 4,
                  right: 4,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: player.photoUrl != null
                        ? NetworkImage(player.photoUrl!)
                        : null,
                    backgroundColor: _getAvatarColor(player),
                    child: player.photoUrl == null
                        ? Text(
                            player.displayName.isNotEmpty
                                ? player.displayName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
                // Host crown indicator - positioned around top of avatar
                if (isHost)
                  Positioned(
                    top: -2,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/crown.svg',
                        width: 28,
                        height: 20,
                      ),
                    ),
                  ),
                // Online status indicator
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: player.isOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.displayName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isCurrentUser
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Caudex',
                  ),
                ),
                // Show last seen only if offline
                if (!player.isOnline && player.lastSeen != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Last seen: ${_formatLastSeen(player.lastSeen!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                      fontFamily: 'Caudex',
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Ready status - compact icon
          Icon(
            player.isReady ? Icons.check_circle : Icons.schedule,
            size: 24,
            color: player.isReady ? Colors.green : Colors.orange,
          ),
        ],
      ),
    );
  }

  LinearGradient _getPlayerGradient(bool isCurrentUser, bool isHost) {
    if (isCurrentUser) {
      return LinearGradient(
        colors: [
          AppTheme.primaryColor.withValues(alpha: 0.4),
          AppTheme.accentColor.withValues(alpha: 0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (isHost) {
      return LinearGradient(
        colors: [
          AppTheme.secondaryColor.withValues(alpha: 0.2),
          AppTheme.surfaceColor.withValues(alpha: 0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return LinearGradient(
        colors: [
          AppTheme.surfaceColor.withValues(alpha: 0.8),
          AppTheme.surfaceColor.withValues(alpha: 0.6),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  Color _getPlayerBorderColor(bool isCurrentUser, bool isHost) {
    if (isCurrentUser) {
      return AppTheme.primaryColor.withValues(alpha: 0.8);
    } else if (isHost) {
      return AppTheme.secondaryColor.withValues(alpha: 0.5);
    } else if (player.isReady) {
      return Colors.green.withValues(alpha: 0.6);
    } else {
      return Colors.orange.withValues(alpha: 0.6);
    }
  }

  Color _getAvatarColor(RoomPlayerModel player) {
    // Generate color based on player name for consistency
    final hash = player.displayName.hashCode;
    final colors = [
      AppTheme.primaryColor,
      AppTheme.accentColor,
      AppTheme.secondaryColor,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];
    return colors[hash.abs() % colors.length];
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
