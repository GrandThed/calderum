import 'dart:math';

class AnonymousNameGenerator {
  static final Random _random = Random();
  
  static const List<String> _mageNames = [
    // Classic fantasy
    'Gandalf', 'Merlin', 'Radagast', 'Saruman', 'Elrond',
    
    // Harry Potter universe
    'Dumbledore', 'McGonagall', 'Snape', 'Hermione', 'Voldemort',
    'Flamel', 'Grindelwald', 'Newt', 'Hagrid',
    
    // Disney/Fairy tale
    'Jafar', 'Maleficent', 'Morgana', 'Prospero', 'Circe',
    
    // Marvel/DC
    'Strange', 'Scarlet', 'Zatanna', 'Constantine', 'Fate',
    
    // Mythology
    'Loki', 'Odin', 'Thoth', 'Isis', 'Hecate', 'Medea',
    
    // Literature/Games
    'Raistlin', 'Elminster', 'Khadgar', 'Jaina', 'Medivh',
    'Tyrande', 'Malfurion', 'Illidan', 'Azshara', 'Rhonin',
    
    // Additional fantasy names
    'Alaric', 'Celestine', 'Drakonis', 'Evangeline', 'Faelar',
    'Grimjaw', 'Hexana', 'Ignatius', 'Jinx', 'Korrigan',
    'Lunara', 'Mystral', 'Nightshade', 'Obsidian', 'Phoenix',
    'Quicksilver', 'Raven', 'Shadowmere', 'Tempest', 'Umbra',
    'Vex', 'Whisper', 'Xylo', 'Yggdrasil', 'Zephyr'
  ];
  
  static String generateRandomMageName() {
    final index = _random.nextInt(_mageNames.length);
    return _mageNames[index];
  }
  
  static String generateUniqueAnonymousId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = _random.nextInt(9999).toString().padLeft(4, '0');
    return 'anon_${timestamp}_$randomSuffix';
  }
}