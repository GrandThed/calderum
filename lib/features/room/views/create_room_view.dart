import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/room_model.dart';
import '../viewmodels/room_viewmodel.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../../../shared/widgets/calderum_app_bar.dart';
import '../../../shared/utils/anonymous_name_generator.dart';
import '../../account/services/auth_service.dart';

class CreateRoomView extends ConsumerStatefulWidget {
  const CreateRoomView({super.key});

  @override
  ConsumerState<CreateRoomView> createState() => _CreateRoomViewState();
}

class _CreateRoomViewState extends ConsumerState<CreateRoomView> {
  IngredientSet _ingredientSet = IngredientSet.set1;
  bool _testTubeVariant = false;
  bool _allowMidGameJoins = false;
  bool _allowSpectators = false;
  String? _selectedMageName;
  final List<String> _availableMageNames = [
    'Gandalf', 'Merlin', 'Radagast', 'Saruman', 'Elrond',
    'Dumbledore', 'McGonagall', 'Snape', 'Hermione', 'Voldemort',
    'Flamel', 'Grindelwald', 'Newt', 'Hagrid',
    'Jafar', 'Maleficent', 'Morgana', 'Prospero', 'Circe',
    'Strange', 'Scarlet', 'Zatanna', 'Constantine', 'Fate',
    'Loki', 'Odin', 'Thoth', 'Isis', 'Hecate', 'Medea',
    'Raistlin', 'Elminster', 'Khadgar', 'Jaina', 'Medivh',
    'Tyrande', 'Malfurion', 'Illidan', 'Azshara', 'Rhonin',
    'Alaric', 'Celestine', 'Drakonis', 'Evangeline', 'Faelar',
    'Grimjaw', 'Hexana', 'Ignatius', 'Jinx', 'Korrigan',
    'Lunara', 'Mystral', 'Nightshade', 'Obsidian', 'Phoenix',
    'Quicksilver', 'Raven', 'Shadowmere', 'Tempest', 'Umbra',
    'Vex', 'Whisper', 'Xylo', 'Yggdrasil', 'Zephyr'
  ];

  @override
  Widget build(BuildContext context) {
    final createRoomState = ref.watch(createRoomViewModelProvider);
    final theme = Theme.of(context);

    ref.listen(createRoomViewModelProvider, (previous, next) {
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
              content: Text('Failed to create room: $error'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: const CalderumAppBar(
        title: '🏠 Create Room',
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🎮 Room Settings',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontFamily: 'Caudex',
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Game settings
                        _buildSectionTitle('⚗️ Game Settings'),
                        const SizedBox(height: 16),
                        
                        _buildDropdownSetting<IngredientSet>(
                          label: 'Ingredient Set',
                          value: _ingredientSet,
                          items: IngredientSet.values,
                          onChanged: (value) => setState(() => _ingredientSet = value!),
                          itemBuilder: (set) {
                            switch (set) {
                              case IngredientSet.set1:
                                return '🟦 Ingredient Set 1 (Beginner)';
                              case IngredientSet.set2:
                                return '🟩 Ingredient Set 2 (Intermediate)';
                              case IngredientSet.set3:
                                return '🟨 Ingredient Set 3 (Advanced)';
                              case IngredientSet.set4:
                                return '🟥 Ingredient Set 4 (Expert)';
                            }
                          },
                        ),
                        
                        _buildSwitchSetting(
                          label: 'Test Tube Variant',
                          subtitle: 'Advanced scoring rules',
                          value: _testTubeVariant,
                          onChanged: (value) => setState(() => _testTubeVariant = value),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Mage settings
                        _buildSectionTitle('🧙‍♂️ Mage Settings'),
                        const SizedBox(height: 16),
                        
                        _buildDropdownSetting<String?>(
                          label: 'Mage Name',
                          value: _selectedMageName,
                          items: [null, ..._availableMageNames],
                          onChanged: (value) => setState(() => _selectedMageName = value),
                          itemBuilder: (name) {
                            if (name == null) {
                              return '🎲 Random Mage Name';
                            }
                            return '🧙‍♂️ $name';
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Room settings
                        _buildSectionTitle('🔧 Room Settings'),
                        const SizedBox(height: 16),
                        
                        _buildSwitchSetting(
                          label: 'Allow Mid-Game Joins',
                          subtitle: 'Players can join during the game',
                          value: _allowMidGameJoins,
                          onChanged: (value) => setState(() => _allowMidGameJoins = value),
                        ),
                        
                        _buildSwitchSetting(
                          label: 'Allow Spectators',
                          subtitle: 'Others can watch the game',
                          value: _allowSpectators,
                          onChanged: (value) => setState(() => _allowSpectators = value),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Create button
                        createRoomState.when(
                          data: (_) => SizedBox(
                            width: double.infinity,
                            child: CalderumButton(
                              text: '🎯 Create Room',
                              onPressed: _createRoom,
                              style: CalderumButtonStyle.primary,
                            ),
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (_, __) => SizedBox(
                            width: double.infinity,
                            child: CalderumButton(
                              text: '🎯 Create Room',
                              onPressed: _createRoom,
                              style: CalderumButtonStyle.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontFamily: 'Caudex',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSliderSetting({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
    required String valueText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              valueText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdownSetting<T>({
    required String label,
    required T value,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(itemBuilder(item)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSwitchSetting({
    required String label,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(label),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _createRoom() async {
    final authService = ref.read(authServiceProvider);
    
    // Update mage name if selected
    if (_selectedMageName != null) {
      await authService.updateDisplayName(_selectedMageName!);
    } else {
      // Generate a random mage name if none selected
      final randomMageName = AnonymousNameGenerator.generateRandomMageName();
      await authService.updateDisplayName(randomMageName);
    }
    
    final settings = RoomSettingsModel(
      maxPlayers: 4, // Always 4 for Quacks of Quedlinburg
      minPlayers: 1, // Dynamic - players can join anytime
      ingredientSet: _ingredientSet,
      testTubeVariant: _testTubeVariant,
      allowMidGameJoins: _allowMidGameJoins,
      allowSpectators: _allowSpectators,
    );

    ref.read(createRoomViewModelProvider.notifier).createRoom(settings: settings);
  }
}