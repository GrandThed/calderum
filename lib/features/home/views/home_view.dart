import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_app_bar.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../../../shared/widgets/calderum_text_field.dart';
import '../../../shared/constants/route_paths.dart';
import '../../room/viewmodels/room_viewmodel.dart';
import '../../room/services/room_service.dart';
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

  @override
  Widget build(BuildContext context) {
    final createRoomState = ref.watch(createRoomViewModelProvider);

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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                error: (_, __) => CalderumButton(
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
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
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
                              message: isEmpty ? 'Paste room code' : 'Join room',
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
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
    );
  }

  Future<void> _createRoom() async {
    // Create room immediately with default settings
    ref.read(createRoomViewModelProvider.notifier).createRoom();
  }

  Future<void> _joinRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isJoining = true);

    try {
      final roomCode = _roomCodeController.text.toUpperCase();
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Room code pasted: $cleanedText'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              duration: const Duration(seconds: 2),
            ),
          );
          
          // Auto-join if code is 6 characters
          if (cleanedText.length == 6) {
            _joinRoom();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid room code format'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No text found in clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to paste from clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}