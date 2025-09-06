class PotScoringData {
  final int potNumber;
  final int points;
  final bool hasRuby;

  const PotScoringData({
    required this.potNumber,
    required this.points,
    required this.hasRuby,
  });
}

class PotScoring {
  static const Map<int, PotScoringData> _scoringMap = {
    1: PotScoringData(potNumber: 1, points: 0, hasRuby: false),
    2: PotScoringData(potNumber: 2, points: 0, hasRuby: false),
    3: PotScoringData(potNumber: 3, points: 0, hasRuby: false),
    4: PotScoringData(potNumber: 4, points: 0, hasRuby: false),
    5: PotScoringData(potNumber: 5, points: 0, hasRuby: true),
    6: PotScoringData(potNumber: 6, points: 1, hasRuby: false),
    7: PotScoringData(potNumber: 7, points: 1, hasRuby: false),
    8: PotScoringData(potNumber: 8, points: 1, hasRuby: false),
    9: PotScoringData(potNumber: 9, points: 1, hasRuby: true),
    10: PotScoringData(potNumber: 10, points: 2, hasRuby: false),
    11: PotScoringData(potNumber: 11, points: 2, hasRuby: false),
    12: PotScoringData(potNumber: 12, points: 2, hasRuby: false),
    13: PotScoringData(potNumber: 13, points: 2, hasRuby: true),
    14: PotScoringData(potNumber: 14, points: 3, hasRuby: false),
    15: PotScoringData(potNumber: 15, points: 3, hasRuby: false),
    16: PotScoringData(potNumber: 15, points: 3, hasRuby: true),
    17: PotScoringData(potNumber: 16, points: 3, hasRuby: false),
    18: PotScoringData(potNumber: 16, points: 4, hasRuby: false),
    19: PotScoringData(potNumber: 17, points: 4, hasRuby: false),
    20: PotScoringData(potNumber: 17, points: 4, hasRuby: true),
    21: PotScoringData(potNumber: 18, points: 4, hasRuby: false),
    22: PotScoringData(potNumber: 18, points: 5, hasRuby: false),
    23: PotScoringData(potNumber: 19, points: 5, hasRuby: false),
    24: PotScoringData(potNumber: 19, points: 5, hasRuby: true),
    25: PotScoringData(potNumber: 20, points: 5, hasRuby: false),
    26: PotScoringData(potNumber: 20, points: 6, hasRuby: false),
    27: PotScoringData(potNumber: 21, points: 6, hasRuby: false),
    28: PotScoringData(potNumber: 21, points: 6, hasRuby: true),
    29: PotScoringData(potNumber: 22, points: 7, hasRuby: false),
    30: PotScoringData(potNumber: 22, points: 7, hasRuby: true),
    31: PotScoringData(potNumber: 23, points: 7, hasRuby: false),
    32: PotScoringData(potNumber: 23, points: 8, hasRuby: false),
    33: PotScoringData(potNumber: 24, points: 8, hasRuby: false),
    34: PotScoringData(potNumber: 24, points: 8, hasRuby: true),
    35: PotScoringData(potNumber: 25, points: 9, hasRuby: false),
    36: PotScoringData(potNumber: 25, points: 9, hasRuby: true),
    37: PotScoringData(potNumber: 26, points: 9, hasRuby: false),
    38: PotScoringData(potNumber: 26, points: 10, hasRuby: false),
    39: PotScoringData(potNumber: 27, points: 10, hasRuby: false),
    40: PotScoringData(potNumber: 27, points: 10, hasRuby: true),
    41: PotScoringData(potNumber: 28, points: 11, hasRuby: false),
    42: PotScoringData(potNumber: 28, points: 11, hasRuby: true),
    43: PotScoringData(potNumber: 29, points: 11, hasRuby: false),
    44: PotScoringData(potNumber: 29, points: 12, hasRuby: false),
    45: PotScoringData(potNumber: 30, points: 12, hasRuby: false),
    46: PotScoringData(potNumber: 30, points: 12, hasRuby: true),
    47: PotScoringData(potNumber: 31, points: 12, hasRuby: false),
    48: PotScoringData(potNumber: 31, points: 13, hasRuby: false),
    49: PotScoringData(potNumber: 32, points: 13, hasRuby: false),
    50: PotScoringData(potNumber: 32, points: 13, hasRuby: true),
    51: PotScoringData(potNumber: 33, points: 14, hasRuby: false),
    52: PotScoringData(potNumber: 33, points: 14, hasRuby: true),
    53: PotScoringData(potNumber: 35, points: 15, hasRuby: false),
  };

  static PotScoringData? getScoringData(int position) {
    return _scoringMap[position];
  }

  static int getVictoryPoints(int position) {
    return _scoringMap[position]?.points ?? 0;
  }

  static int getPotNumber(int position) {
    return _scoringMap[position]?.potNumber ?? position;
  }

  static bool hasRuby(int position) {
    return _scoringMap[position]?.hasRuby ?? false;
  }

  static int getCoins(int potNumber, bool hasExploded) {
    if (hasExploded) {
      return potNumber ~/ 2;
    }
    return potNumber;
  }

  static List<int> getRubyPositions() {
    return _scoringMap.entries
        .where((entry) => entry.value.hasRuby)
        .map((entry) => entry.key)
        .toList();
  }

  static int getMaxPosition() => 53;
}