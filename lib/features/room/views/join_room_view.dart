import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/room_viewmodel.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../../../shared/widgets/calderum_app_bar.dart';
import '../../../shared/widgets/calderum_text_field.dart';

class JoinRoomView extends ConsumerStatefulWidget {
  const JoinRoomView({super.key});

  @override
  ConsumerState<JoinRoomView> createState() => _JoinRoomViewState();
}

class _JoinRoomViewState extends ConsumerState<JoinRoomView> {
  final _formKey = GlobalKey<FormState>();
  final _roomCodeController = TextEditingController();

  @override
  void dispose() {
    _roomCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final joinRoomState = ref.watch(joinRoomViewModelProvider);
    final theme = Theme.of(context);

    ref.listen(joinRoomViewModelProvider, (previous, next) {
      next.when(
        data: (room) {
          if (room != null) {
            context.go('/room/${room.id}');
          }
        },
        loading: () {},
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

    return Scaffold(
      appBar: const CalderumAppBar(title: '🚪 Join Room'),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.meeting_room,
                          size: 80,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 24),

                        Text(
                          '🎮 Join a Room',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontFamily: 'Caudex',
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          '🔗 Enter the room code to join',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'Caveat',
                            fontSize: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),

                        CalderumTextField(
                          controller: _roomCodeController,
                          label: 'Room Code',
                          hint: 'Enter 6-character code',
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z0-9]'),
                            ),
                            LengthLimitingTextInputFormatter(6),
                          ],
                          prefixIcon: Icons.vpn_key,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a room code';
                            }
                            if (value.length != 6) {
                              return 'Room code must be 6 characters';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            // Auto-format to uppercase
                            final upperValue = value.toUpperCase();
                            if (upperValue != value) {
                              _roomCodeController.value = TextEditingValue(
                                text: upperValue,
                                selection: TextSelection.collapsed(
                                  offset: upperValue.length,
                                ),
                              );
                            }
                          },
                          onFieldSubmitted: (_) => _joinRoom(),
                        ),

                        const SizedBox(height: 24),

                        joinRoomState.when(
                          data: (_) => SizedBox(
                            width: double.infinity,
                            child: CalderumButton(
                              text: '🚀 Join Room',
                              onPressed: _joinRoom,
                              style: CalderumButtonStyle.primary,
                            ),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (_, _) => SizedBox(
                            width: double.infinity,
                            child: CalderumButton(
                              text: '🚀 Join Room',
                              onPressed: _joinRoom,
                              style: CalderumButtonStyle.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            'Back to Home',
                            style: TextStyle(
                              fontFamily: 'Caveat',
                              fontSize: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: theme.colorScheme.onPrimaryContainer,
                                size: 20,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Room codes are 6 characters long and contain letters and numbers. Ask the host to share the code!',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'Caveat',
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _joinRoom() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(joinRoomViewModelProvider.notifier)
          .joinRoom(_roomCodeController.text.toUpperCase().trim());
    }
  }
}
