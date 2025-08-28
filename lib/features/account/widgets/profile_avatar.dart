import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final String displayName;
  final double size;

  const ProfileAvatar({
    super.key,
    this.photoUrl,
    required this.displayName,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primaryContainer,
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 3,
        ),
      ),
      child: photoUrl != null && photoUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildInitial(initial, theme),
              ),
            )
          : _buildInitial(initial, theme),
    );
  }

  Widget _buildInitial(String initial, ThemeData theme) {
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          fontFamily: 'Caudex',
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}