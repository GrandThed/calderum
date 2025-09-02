import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_app_bar.dart';
import '../../../shared/widgets/calderum_text_field.dart';
import '../../../shared/widgets/animated_refresh_button.dart';
import '../../../shared/widgets/create_room_card.dart';
import '../../../shared/constants/route_paths.dart';
import '../../room/viewmodels/room_viewmodel.dart';
import '../../room/services/room_service.dart';
import '../../room/models/room_model.dart';
import '../../account/services/auth_service.dart';
import '../../account/viewmodels/auth_viewmodel.dart';

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
    final authState = ref.read(authViewModelProvider);
    final currentUserId = authState.when(
      initial: () => null,
      loading: () => null,
      error: (message) => null,
      anonymous: (user) => user.uid,
      authenticated: (user) => user.uid,
      unauthenticated: () => null,
    );
    if (currentUserId != null) {
      ref.invalidate(userRoomsStreamProvider(currentUserId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final createRoomState = ref.watch(createRoomViewModelProvider);

    // Use the AuthViewModel which has stable auth state management
    final authState = ref.watch(authViewModelProvider);

    // Extract user ID from auth state
    final currentUserId = authState.when(
      initial: () => null,
      loading: () => null,
      error: (message) => null,
      anonymous: (user) => user.uid,
      authenticated: (user) => user.uid,
      unauthenticated: () => null,
    );

    // Only watch the stream if we have a stable user ID
    final userRoomsAsync = currentUserId != null
        ? ref.watch(userRoomsStreamProvider(currentUserId))
        : const AsyncValue<List<RoomModel>>.data([]);

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
                // Build UI based on room data
                Builder(
                  builder: (context) {
                    return userRoomsAsync.when(
                      data: (rooms) {
                        final activeRooms = rooms
                            .where((room) => room.status != RoomStatus.finished)
                            .toList();

                        final hasActiveRooms = activeRooms.isNotEmpty;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Active Rooms Section
                            if (hasActiveRooms) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Your Active Rooms',
                                    style: AppTheme.titleStyle.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  AnimatedRefreshButton(
                                    onPressed: _refreshRooms,
                                    color: Colors.white70,
                                    tooltip: 'Refresh rooms',
                                    iconSize: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...activeRooms.map(
                                (room) => _buildRoomCard(room),
                              ),
                              const SizedBox(height: 24),
                              Divider(
                                color: Colors.white.withValues(alpha: 0.2),
                                thickness: 1,
                              ),
                              const SizedBox(height: 24),
                            ],

                            // "Ready to Brew?" container - only show when no active rooms
                            if (!hasActiveRooms) ...[
                              Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppTheme.primaryColor.withValues(
                                      alpha: 0.3,
                                    ),
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
                                    Text(
                                      'Ready to Brew?',
                                      style: AppTheme.headlineStyle,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Create a new brewing session or join with a room code',
                                      style: AppTheme.bodyStyle.copyWith(
                                        color: Colors.white60,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],

                            // Create Room Card
                            createRoomState.when(
                              data: (_) =>
                                  CreateRoomCard(onPressed: _createRoom),
                              loading: () => const CreateRoomCard(
                                onPressed: null,
                                isLoading: true,
                              ),
                              error: (_, _) =>
                                  CreateRoomCard(onPressed: _createRoom),
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
                                      textCapitalization:
                                          TextCapitalization.characters,
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
                                        return AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isEmpty
                                                ? AppTheme.secondaryColor
                                                      .withValues(alpha: 0.8)
                                                : AppTheme.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    (isEmpty
                                                            ? AppTheme
                                                                  .secondaryColor
                                                            : AppTheme
                                                                  .primaryColor)
                                                        .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Tooltip(
                                              message: isEmpty
                                                  ? 'Paste room code'
                                                  : 'Join room',
                                              child: InkWell(
                                                onTap: isEmpty
                                                    ? _pasteFromClipboard
                                                    : (_isJoining
                                                          ? null
                                                          : _joinRoom),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: SizedBox(
                                                  width: 56,
                                                  height: 56,
                                                  child: Center(
                                                    child: _isJoining
                                                        ? const SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                    Color
                                                                  >(
                                                                    Colors
                                                                        .white,
                                                                  ),
                                                            ),
                                                          )
                                                        : Icon(
                                                            isEmpty
                                                                ? Icons.paste
                                                                : Icons
                                                                      .arrow_forward,
                                                            color: Colors.white,
                                                            size: 24,
                                                          ),
                                                  ),
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
                        );
                      },
                      loading: () {
                        return const SizedBox.shrink();
                      },
                      error: (error, _) {
                        return const SizedBox.shrink();
                      },
                    );
                  },
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
                  color: _getRoomStatusColor(
                    room.status,
                  ).withValues(alpha: 0.2),
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
      case RoomStatus.inProgress:
        return 'Game in progress';
      case RoomStatus.paused:
        return 'Game paused';
      case RoomStatus.finished:
        return 'Game finished';
    }
  }
}
