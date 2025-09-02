import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    String? email,
    required String displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    @Default(false) bool isAnonymous,
    @Default(0) int gamesPlayed,
    @Default(0) int gamesWon,
    @Default(0) int totalPoints,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelExtension on UserModel {
  String get displayNameFormatted =>
      isAnonymous ? '$displayName (Anonymous)' : displayName;
}
