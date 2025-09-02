import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_app_bar.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../../../shared/widgets/calderum_text_field.dart';
import '../../../shared/constants/route_paths.dart';
import '../../../shared/providers/providers.dart';
import '../../room/viewmodels/room_viewmodel.dart';
import '../../room/services/room_service.dart';
import '../../room/models/room_model.dart';
import '../../account/services/auth_service.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _roomCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isJoining = false;

  @override
  void dispose() {
    _roomCodeController.dispose();
    super.dispose();
  }

  Future<void> _refreshRooms() async {
    // Force refresh by invalidating the specific provider instance
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      ref.invalidate(userRoomsStreamProvider(currentUser.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final createRoomState = ref.watch(createRoomViewModelProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    print('🏠 Home: Current user: ${currentUser?.uid ?? "null"}');
    
    // Only watch the stream if we have a stable user ID
    final userRoomsAsync = currentUser?.uid != null
        ? ref.watch(userRoomsStreamProvider(currentUser!.uid))
        : const AsyncValue<List<RoomModel>>.data([]);
    
    print('🏠 Home: userRoomsAsync state: ${userRoomsAsync.runtimeType}');

    // Listen for successful room creation
    ref.listen(createRoomViewModelProvider, (previous, next) {
      next.when(
        data: (room) {
          if (room != null) {
            // Navigate to the created room immediately
            context.go('/room/${room.id}');
          }
        },
        loading: () {},
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create room: $error'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CalderumAppBar(
        title: 'Calderum',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => context.push(RoutePaths.profile),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshRooms,
          color: AppTheme.primaryColor,
          backgroundColor: AppTheme.surfaceColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User's Active Rooms Section
                userRoomsAsync.when(
                data: (rooms) {
                  print('🏠 Home: Received ${rooms.length} total rooms');
                  final activeRooms = rooms
                      .where(
                        (room) => room.status != RoomStatus.finished,
                      )
                      .toList();
                  
                  print('🏠 Home: Filtered to ${activeRooms.length} active rooms');
                  for (final room in activeRooms) {
                    print('   - Room ${room.code}: ${room.status.name}');
                  }

                  if (activeRooms.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Active Rooms',
                            style: AppTheme.titleStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: _refreshRooms,
                            icon: const Icon(Icons.refresh),
                            color: Colors.white70,
                            tooltip: 'Refresh rooms',
                            iconSize: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...activeRooms.map((room) => _buildRoomCard(room)),
                      const SizedBox(height: 24),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.2),
                        thickness: 1,
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
                loading: () {
                  print('🏠 Home: Room list is loading...');
                  return const SizedBox.shrink();
                },
                error: (error, _) {
                  print('🏠 Home: Room list error: $error');
                  return const SizedBox.shrink();
                },
              ),

              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.science,
                      size: 80,
                      color: AppTheme.secondaryColor,
                    ),
                    const SizedBox(height: 20),
                    Text('Ready to Brew?', style: AppTheme.headlineStyle),
                    const SizedBox(height: 8),
                    Text(
                      'Create a new brewing session or join with a room code',
                      style: AppTheme.bodyStyle.copyWith(color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Create Room Button
              createRoomState.when(
                data: (_) => CalderumButton(
                  text: 'Create Room',
                  onPressed: _createRoom,
                  icon: Icons.add_circle_outline,
                ),
                loading: () => CalderumButton(
                  text: 'Creating Room...',
                  onPressed: null, // Disabled while loading
                  icon: Icons.add_circle_outline,
                ),
                error: (_, _) => CalderumButton(
                  text: 'Create Room',
                  onPressed: _createRoom,
                  icon: Icons.add_circle_outline,
                ),
              ),

              const SizedBox(height: 24),

              // OR divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.white.withValues(alpha: 0.3),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: AppTheme.bodyStyle.copyWith(
                        color: Colors.white60,
                        fontFamily: 'Caveat',
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.white.withValues(alpha: 0.3),
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Join Room Section
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: CalderumTextField(
                        controller: _roomCodeController,
                        label: 'Room Code',
                        hint: 'Enter 6-digit room code',
                        prefixIcon: Icons.vpn_key,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[A-Z0-9]'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a room code';
                          }
                          if (value.length != 6) {
                            return 'Room code must be 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _roomCodeController,
                        builder: (context, value, _) {
                          final isEmpty = value.text.isEmpty;
                          return Material(
                            color: isEmpty
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                            child: Tooltip(
                              message: isEmpty
                                  ? 'Paste room code'
                                  : 'Join room',
                              child: InkWell(
                                onTap: isEmpty
                                    ? _pasteFromClipboard
                                    : (_isJoining ? null : _joinRoom),
                                borderRadius: BorderRadius.circular(12),
                                child: Center(
                                  child: _isJoining
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Icon(
                                          isEmpty
                                              ? Icons.paste
                                              : Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Future<void> _createRoom() async {
    // Create room instantly with default settings
    ref.read(createRoomViewModelProvider.notifier).createRoom();
  }

  Future<void> _joinRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isJoining = true);

    try {
      final roomCode = _roomCodeController.text.toUpperCase();
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);

      // Get current user from Firestore (works for both anonymous and authenticated users)
      final currentUser = await authService.getCurrentUserModel();
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      final room = await roomService.joinRoomByCode(
        roomCode: roomCode,
        user: currentUser,
      );

      if (mounted) {
        // Navigate to the joined room
        context.go('/room/${room.id}');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join room: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData != null && clipboardData.text != null) {
        final text = clipboardData.text!.trim().toUpperCase();

        // Clean up the text to only include alphanumeric characters
        final cleanedText = text.replaceAll(RegExp(r'[^A-Z0-9]'), '');

        if (cleanedText.length <= 6) {
          _roomCodeController.text = cleanedText;

          // Show feedback
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Room code pasted: $cleanedText'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                duration: const Duration(seconds: 2),
              ),
            );
          }

          // Auto-join if code is 6 characters
          if (cleanedText.length == 6) {
            _joinRoom();
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid room code format'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No text found in clipboard'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to paste from clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildRoomCard(RoomModel room) {
    final isHost =
        room.hostId == ref.read(authServiceProvider).currentUser?.uid;
    final playerCount = room.players.length;
    final maxPlayers = room.settings.maxPlayers;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.surfaceColor.withValues(alpha: 0.8),
      child: InkWell(
        onTap: () => context.go('/room/${room.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getRoomStatusColor(room.status).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getRoomStatusIcon(room.status),
                  color: _getRoomStatusColor(room.status),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Room ${room.code}',
                          style: AppTheme.bodyStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (isHost) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'HOST',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getRoomStatusText(room.status),
                      style: AppTheme.bodyStyle.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(Icons.people, color: Colors.white54, size: 20),
                  const SizedBox(height: 2),
                  Text(
                    '$playerCount/$maxPlayers',
                    style: AppTheme.bodyStyle.copyWith(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoomStatusColor(RoomStatus status) {
    switch (status) {
      case RoomStatus.waiting:
        return Colors.orange;
      case RoomStatus.starting:
        return Colors.blue;
      case RoomStatus.inProgress:
        return Colors.green;
      case RoomStatus.paused:
        return Colors.yellow;
      case RoomStatus.finished:
        return Colors.grey;
    }
  }

  IconData _getRoomStatusIcon(RoomStatus status) {
    switch (status) {
      case RoomStatus.waiting:
        return Icons.hourglass_empty;
      case RoomStatus.starting:
        return Icons.rocket_launch;
      case RoomStatus.inProgress:
        return Icons.play_arrow;
      case RoomStatus.paused:
        return Icons.pause;
      case RoomStatus.finished:
        return Icons.check_circle;
    }
  }

  String _getRoomStatusText(RoomStatus status) {
    switch (status) {
      case RoomStatus.waiting:
        return 'Waiting for players';
      case RoomStatus.starting:
        return 'Game starting';
      case RoomStatus.inProgress:
        return 'Game in progress';
      case RoomStatus.paused:
        return 'Game paused';
      case RoomStatus.finished:
        return 'Game finished';
    }
  }
}
