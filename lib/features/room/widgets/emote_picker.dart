import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/emote_model.dart';
import '../services/room_service.dart';
import '../../account/services/auth_service.dart';

class EmotePicker extends ConsumerStatefulWidget {
  final String roomId;

  const EmotePicker({required this.roomId, super.key});

  @override
  ConsumerState<EmotePicker> createState() => _EmotePickerState();
}

class _EmotePickerState extends ConsumerState<EmotePicker> {
  bool _isExpanded = false;
  DateTime? _lastEmoteTime;

  bool get _canSendEmote {
    if (_lastEmoteTime == null) return true;
    return DateTime.now().difference(_lastEmoteTime!) >
        const Duration(seconds: 2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isExpanded ? 320 : 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _isExpanded ? _buildExpandedView() : _buildCollapsedView(),
    );
  }

  Widget _buildCollapsedView() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = true;
          });
        },
        borderRadius: BorderRadius.circular(28),
        child: Center(
          child: Icon(
            Icons.emoji_emotions,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedView() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            setState(() {
              _isExpanded = false;
            });
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: EmoteType.values.map((type) {
                return _buildEmoteButton(type);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmoteButton(EmoteType type) {
    final canSend = _canSendEmote;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canSend ? () => _sendEmote(type) : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: canSend
                  ? Colors.transparent
                  : Colors.grey.withValues(alpha: 0.2),
            ),
            child: Center(
              child: Text(
                type.emoji,
                style: TextStyle(
                  fontSize: 24,
                  color: canSend ? null : Colors.grey.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendEmote(EmoteType type) async {
    if (!_canSendEmote) return;

    try {
      final authService = ref.read(authServiceProvider);
      final roomService = ref.read(roomServiceProvider);
      final currentUser = await authService.getCurrentUserModel();

      if (currentUser == null) return;

      await roomService.sendEmote(
        roomId: widget.roomId,
        userId: currentUser.uid,
        displayName: currentUser.displayName,
        type: type,
      );

      setState(() {
        _lastEmoteTime = DateTime.now();
        _isExpanded = false;
      });

      // Show feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${type.emoji} sent!'),
            duration: const Duration(seconds: 1),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
