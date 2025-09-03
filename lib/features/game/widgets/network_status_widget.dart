import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sync_model.dart';
import '../providers/game_providers.dart';
import '../../../shared/theme/app_theme.dart';

/// Widget that displays current network and sync status
class NetworkStatusWidget extends ConsumerStatefulWidget {
  final bool showDetailed;
  final EdgeInsets? padding;

  const NetworkStatusWidget({
    super.key,
    this.showDetailed = false,
    this.padding,
  });

  @override
  ConsumerState<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends ConsumerState<NetworkStatusWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionStatus = ref.watch(connectionStatusProvider);

    // Show/hide based on status
    if (connectionStatus == ConnectionStatus.connected && !widget.showDetailed) {
      _slideController.reverse();
      _pulseController.stop();
      return const SizedBox();
    } else {
      _slideController.forward();
      if (connectionStatus == ConnectionStatus.syncing ||
          connectionStatus == ConnectionStatus.disconnected) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
      }
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(8),
        child: widget.showDetailed
            ? _buildDetailedStatus(connectionStatus)
            : _buildCompactStatus(connectionStatus),
      ),
    );
  }

  Widget _buildCompactStatus(ConnectionStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _shouldPulse(status) ? _pulseAnimation.value : 1.0,
                child: Icon(
                  _getStatusIcon(status),
                  size: 16,
                  color: _getStatusColor(status),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            _getStatusMessage(status),
            style: AppTheme.bodyStyle.copyWith(
              fontSize: 12,
              color: _getStatusColor(status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStatus(ConnectionStatus status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status header
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _shouldPulse(status) ? _pulseAnimation.value : 1.0,
                    child: Icon(
                      _getStatusIcon(status),
                      size: 20,
                      color: _getStatusColor(status),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusMessage(status),
                      style: AppTheme.titleStyle.copyWith(
                        color: _getStatusColor(status),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getStatusDescription(status),
                      style: AppTheme.bodyStyle.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Status details
          _buildStatusDetails(status),

          // Action buttons for certain statuses
          if (_needsActionButton(status)) ...[
            const SizedBox(height: 16),
            _buildActionButton(status),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusDetails(ConnectionStatus status) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Connection details
          _buildDetailRow('Connection', _getConnectionDetails(status)),
          const SizedBox(height: 8),
          _buildDetailRow('Sync Status', _getSyncDetails(status)),
          const SizedBox(height: 8),
          _buildDetailRow('Last Update', _getLastUpdateTime()),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: AppTheme.bodyStyle.copyWith(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyStyle.copyWith(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(ConnectionStatus status) {
    final buttonData = _getActionButtonData(status);
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: buttonData['action'],
        style: ElevatedButton.styleFrom(
          backgroundColor: _getStatusColor(status),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(buttonData['icon'], size: 16),
            const SizedBox(width: 8),
            Text(
              buttonData['text'],
              style: AppTheme.bodyStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return Colors.green;
      case ConnectionStatus.disconnected:
        return Colors.red;
      case ConnectionStatus.synced:
        return Colors.blue;
      case ConnectionStatus.syncing:
        return Colors.orange;
      case ConnectionStatus.error:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return Icons.wifi;
      case ConnectionStatus.disconnected:
        return Icons.wifi_off;
      case ConnectionStatus.synced:
        return Icons.sync;
      case ConnectionStatus.syncing:
        return Icons.sync;
      case ConnectionStatus.error:
        return Icons.error;
    }
  }

  String _getStatusMessage(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return 'Connected';
      case ConnectionStatus.disconnected:
        return 'Disconnected';
      case ConnectionStatus.synced:
        return 'Synced';
      case ConnectionStatus.syncing:
        return 'Syncing...';
      case ConnectionStatus.error:
        return 'Connection Error';
    }
  }

  String _getStatusDescription(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return 'Game is connected and running smoothly';
      case ConnectionStatus.disconnected:
        return 'Unable to connect to the game server';
      case ConnectionStatus.synced:
        return 'Game state is synchronized with all players';
      case ConnectionStatus.syncing:
        return 'Updating game state with other players';
      case ConnectionStatus.error:
        return 'Network error occurred, attempting to reconnect';
    }
  }

  String _getConnectionDetails(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
      case ConnectionStatus.synced:
        return 'Online';
      case ConnectionStatus.syncing:
        return 'Connecting';
      case ConnectionStatus.disconnected:
      case ConnectionStatus.error:
        return 'Offline';
    }
  }

  String _getSyncDetails(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.synced:
        return 'Up to date';
      case ConnectionStatus.syncing:
        return 'Updating...';
      case ConnectionStatus.connected:
        return 'Ready';
      case ConnectionStatus.disconnected:
      case ConnectionStatus.error:
        return 'Out of sync';
    }
  }

  String _getLastUpdateTime() {
    // This would typically come from the sync service
    return 'Just now';
  }

  bool _shouldPulse(ConnectionStatus status) {
    return status == ConnectionStatus.syncing || 
           status == ConnectionStatus.disconnected;
  }

  bool _needsActionButton(ConnectionStatus status) {
    return status == ConnectionStatus.disconnected || 
           status == ConnectionStatus.error;
  }

  Map<String, dynamic> _getActionButtonData(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.disconnected:
      case ConnectionStatus.error:
        return {
          'text': 'Retry Connection',
          'icon': Icons.refresh,
          'action': () => _retryConnection(),
        };
      default:
        return {
          'text': 'OK',
          'icon': Icons.check,
          'action': () {},
        };
    }
  }

  void _retryConnection() {
    // This would trigger reconnection logic in the sync service
    // For now, just update the status to show we're trying
    ref.read(connectionStatusProvider.notifier).updateStatus(
      ConnectionStatus.syncing,
    );

    // Simulate reconnection attempt
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ref.read(connectionStatusProvider.notifier).updateStatus(
          ConnectionStatus.connected,
        );
      }
    });
  }
}

/// Full-screen overlay for connection issues
class NetworkStatusOverlay extends StatelessWidget {
  final Widget child;

  const NetworkStatusOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final connectionStatus = ref.watch(connectionStatusProvider);
        
        return Stack(
          children: [
            child,
            
            // Overlay for severe connection issues
            if (_shouldShowOverlay(connectionStatus))
              _buildConnectionOverlay(context, connectionStatus, ref),
              
            // Status indicator at top
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              child: NetworkStatusWidget(showDetailed: false),
            ),
          ],
        );
      },
    );
  }

  bool _shouldShowOverlay(ConnectionStatus status) {
    return status == ConnectionStatus.disconnected;
  }

  Widget _buildConnectionOverlay(
    BuildContext context, 
    ConnectionStatus status, 
    WidgetRef ref,
  ) {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.red.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Error icon
              const Icon(
                Icons.wifi_off,
                size: 64,
                color: Colors.red,
              ),
              
              const SizedBox(height: 24),
              
              // Title
              Text(
                'Connection Lost',
                style: AppTheme.titleStyle.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                'You have been disconnected from the game server. '
                'Your progress is saved and will be restored when you reconnect.',
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Status indicator
              NetworkStatusWidget(
                showDetailed: true,
                padding: EdgeInsets.zero,
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Leave Game',
                        style: AppTheme.bodyStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _retryConnection(ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Retry',
                        style: AppTheme.bodyStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _retryConnection(WidgetRef ref) {
    ref.read(connectionStatusProvider.notifier).updateStatus(
      ConnectionStatus.syncing,
    );

    // Simulate reconnection attempt
    Future.delayed(const Duration(seconds: 2), () {
      ref.read(connectionStatusProvider.notifier).updateStatus(
        ConnectionStatus.connected,
      );
    });
  }
}

/// Compact connection indicator for use in app bars
class ConnectionIndicator extends ConsumerWidget {
  final double size;

  const ConnectionIndicator({super.key, this.size = 16});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(connectionStatusProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getStatusColor(connectionStatus),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(connectionStatus).withValues(alpha: 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          _getStatusIcon(connectionStatus),
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getStatusColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
      case ConnectionStatus.synced:
        return Colors.green;
      case ConnectionStatus.syncing:
        return Colors.orange;
      case ConnectionStatus.disconnected:
      case ConnectionStatus.error:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
      case ConnectionStatus.synced:
        return Icons.check;
      case ConnectionStatus.syncing:
        return Icons.sync;
      case ConnectionStatus.disconnected:
      case ConnectionStatus.error:
        return Icons.close;
    }
  }
}