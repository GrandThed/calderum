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
  final _joinRoomFormKey = GlobalKey<FormState>();
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

    // Check if we're still in initial loading phase
    final isInitialLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    // Extract user ID from auth state
    final currentUserId = authState.when(
      initial: () => null,
      loading: () => null,
      error: (message) => null,
      anonymous: (user) => user.uid,
      authenticated: (user) => user.uid,
      unauthenticated: () => null,
    );

    // Handle rooms stream based on auth state
    final AsyncValue<List<RoomModel>> userRoomsAsync;
    if (isInitialLoading) {
      // Always show loading state while auth is loading
      userRoomsAsync = const AsyncValue.loading();
    } else if (currentUserId != null) {
      userRoomsAsync = ref.watch(userRoomsStreamProvider(currentUserId));
    } else {
      // Only show empty data when auth is actually unauthenticated
      userRoomsAsync = const AsyncValue.data([]);
    }

    // Listen for successful room creation
    ref.listen(createRoomViewModelProvider, (previous, next) {
      next.when(
        data: (room) {
          if (room != null) {
            // Navigate to the created room immediately
            _navigateToRoom(room);
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
            onPressed: () => context.push('/profile'),
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
                    // Show loading state if auth is loading OR if rooms haven't been checked yet
                    if (isInitialLoading || 
                        (currentUserId != null && userRoomsAsync.isLoading)) {
                      // Show loading skeleton
                      return _buildLoadingSkeleton(createRoomState);
                    }
                    
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
                            _buildJoinRoomSection(),
                          ],
                        );
                      },
                      loading: () => _buildLoadingSkeleton(createRoomState),
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
    if (!_joinRoomFormKey.currentState!.validate()) return;

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
        _navigateToRoom(room);
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

  Future<void> _showDeleteConfirmation(RoomModel room) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => _buildDeleteConfirmationDialog(room),
    );

    if (shouldDelete == true) {
      await _deleteRoom(room);
    }
  }

  Widget _buildDeleteConfirmationDialog(RoomModel room) {
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
            style: AppTheme.bodyStyle.copyWith(color: Colors.white70),
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

  Future<void> _deleteRoom(RoomModel room) async {
    try {
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      final currentUser = authService.currentUser;

      if (currentUser == null) {
        throw 'User not authenticated';
      }

      await roomService.deleteRoom(room.id, currentUser.uid);

      if (mounted) {
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
      }
    } catch (error) {
      if (mounted) {
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

  Widget _buildLoadingSkeleton(AsyncValue<RoomModel?> createRoomState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Loading skeleton for rooms section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Loading skeleton room cards
        ...List.generate(
          2,
          (index) => _buildLoadingRoomCard(),
        ),

        const SizedBox(height: 24),
        Container(
          height: 1,
          color: Colors.white.withValues(alpha: 0.1),
        ),
        const SizedBox(height: 24),

        // Create room card (still functional during loading)
        createRoomState.when(
          data: (_) => CreateRoomCard(onPressed: _createRoom),
          loading: () => const CreateRoomCard(
            onPressed: null,
            isLoading: true,
          ),
          error: (_, __) => CreateRoomCard(onPressed: _createRoom),
        ),

        const SizedBox(height: 24),

        // Join Room Section (also shown during loading)
        _buildJoinRoomSection(),
      ],
    );
  }

  Widget _buildJoinRoomSection() {
    return Form(
      key: _joinRoomFormKey,
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
                  RegExp(r'[A-Za-z0-9]'),
                ),
                TextInputFormatter.withFunction((
                  oldValue,
                  newValue,
                ) {
                  return newValue.copyWith(
                    text: newValue.text.toUpperCase(),
                  );
                }),
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
                        ? AppTheme.secondaryColor.withValues(alpha: 0.8)
                        : AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (isEmpty
                                ? AppTheme.secondaryColor
                                : AppTheme.primaryColor)
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Tooltip(
                      message: isEmpty ? 'Paste room code' : 'Join room',
                      child: InkWell(
                        onTap: isEmpty
                            ? _pasteFromClipboard
                            : (_isJoining ? null : _joinRoom),
                        borderRadius: BorderRadius.circular(12),
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
                                          AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    isEmpty ? Icons.paste : Icons.arrow_forward,
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
    );
  }

  Widget _buildLoadingRoomCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.surfaceColor.withValues(alpha: 0.8),
      elevation: 4,
      shadowColor: AppTheme.primaryColor.withValues(alpha: 0.3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.05),
              Colors.white.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Status icon skeleton
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Content skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room code skeleton
                    Container(
                      width: 80,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Status text skeleton
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Players text skeleton
                    Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow skeleton
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard(RoomModel room) {
    final isHost =
        room.hostId == ref.read(authServiceProvider).currentUser?.uid;
    final playerCount = room.players.length;
    final maxPlayers = room.settings.maxPlayers;
    final canDelete = isHost && room.status == RoomStatus.waiting;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.surfaceColor.withValues(alpha: 0.8),
      child: InkWell(
        onTap: () => _navigateToRoom(room),
        onLongPress: canDelete ? () => _showDeleteConfirmation(room) : null,
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

  void _navigateToRoom(RoomModel room) {
    // Navigate directly to game if room is in progress
    if (room.status == RoomStatus.inProgress && room.currentGameId != null) {
      context.push('/game/${room.currentGameId}');
    } else {
      // Navigate to room lobby for waiting rooms
      context.push('/room/${room.id}');
    }
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
      default:
        return Colors.grey; // Fallback color
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
