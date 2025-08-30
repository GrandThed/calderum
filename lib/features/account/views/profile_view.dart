import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/user_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_stat_card.dart';
import '../widgets/anonymous_login_prompt.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  void _toggleEdit(UserModel user) {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _displayNameController.text = user.displayName;
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(profileViewModelProvider.notifier)
          .updateProfile(displayName: _displayNameController.text.trim());
      setState(() {
        _isEditing = false;
      });
    }
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out', style: TextStyle(fontFamily: 'Caudex')),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(fontFamily: 'Caveat', fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(authViewModelProvider.notifier).signOut();
      if (mounted) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(currentUserModelProvider);
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'Caudex', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          // Show login prompt for anonymous users
          if (user.isAnonymous) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AnonymousLoginPrompt(
                    user: user,
                    context: 'profile',
                    onLoginSuccess: () {
                      // Refresh the profile view
                      ref.invalidate(currentUserModelProvider);
                    },
                  ),
                  const SizedBox(height: 24),
                  // Show limited stats for anonymous users
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Session Stats',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontFamily: 'Caudex',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ProfileStatCard(
                                  label: 'Games Played',
                                  value: user.gamesPlayed.toString(),
                                  icon: Icons.sports_esports,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ProfileStatCard(
                                  label: 'Games Won',
                                  value: user.gamesWon.toString(),
                                  icon: Icons.emoji_events,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ProfileStatCard(
                            label: 'Total Points',
                            value: user.totalPoints.toString(),
                            icon: Icons.stars,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ProfileAvatar(
                  photoUrl: user.photoUrl,
                  displayName: user.displayName,
                  size: 100,
                ),
                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Personal Information',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontFamily: 'Caudex',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (!_isEditing)
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _toggleEdit(user),
                                iconSize: 20,
                              )
                            else
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => _toggleEdit(user),
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: profileState.isLoading
                                        ? null
                                        : _saveProfile,
                                    child: profileState.isLoading
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text('Save'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_isEditing)
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _displayNameController,
                              decoration: const InputDecoration(
                                labelText: 'Display Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a display name';
                                }
                                if (value.length < 3) {
                                  return 'Name must be at least 3 characters';
                                }
                                return null;
                              },
                            ),
                          )
                        else ...[
                          _InfoRow(
                            label: 'Display Name',
                            value: user.displayName,
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(label: 'Email', value: user.email ?? 'Not provided'),
                          if (user.createdAt != null) ...[
                            const SizedBox(height: 12),
                            _InfoRow(
                              label: 'Member Since',
                              value: _formatDate(user.createdAt!),
                            ),
                          ],
                          if (user.lastLogin != null) ...[
                            const SizedBox(height: 12),
                            _InfoRow(
                              label: 'Last Login',
                              value: _formatDate(user.lastLogin!),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Game Statistics',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontFamily: 'Caudex',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ProfileStatCard(
                                icon: Icons.sports_esports,
                                label: 'Games Played',
                                value: user.gamesPlayed.toString(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ProfileStatCard(
                                icon: Icons.emoji_events,
                                label: 'Games Won',
                                value: user.gamesWon.toString(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ProfileStatCard(
                                icon: Icons.star,
                                label: 'Total Points',
                                value: user.totalPoints.toString(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ProfileStatCard(
                                icon: Icons.percent,
                                label: 'Win Rate',
                                value: user.gamesPlayed > 0
                                    ? '${((user.gamesWon / user.gamesPlayed) * 100).toStringAsFixed(1)}%'
                                    : '0%',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text(
                      'Change Password',
                      style: TextStyle(fontFamily: 'Caudex'),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to change password screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Change password feature coming soon'),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                TextButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Delete Account',
                          style: TextStyle(fontFamily: 'Caudex'),
                        ),
                        content: const Text(
                          'This action cannot be undone. All your data will be permanently deleted.',
                          style: TextStyle(fontFamily: 'Caveat', fontSize: 18),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                            ),
                            child: const Text('Delete Account'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      // TODO: Implement account deletion
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account deletion feature coming soon'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontFamily: 'Caudex',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Caveat',
              fontSize: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontFamily: 'Caudex', fontSize: 16),
          ),
        ),
      ],
    );
  }
}
