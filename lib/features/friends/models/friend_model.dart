import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_model.freezed.dart';
part 'friend_model.g.dart';

@freezed
class FriendModel with _$FriendModel {
  const factory FriendModel({
    required String userId,
    required String displayName,
    String? photoUrl,
    required DateTime addedAt,
    DateTime? lastSeen,
    required bool isOnline,
  }) = _FriendModel;

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);
}

@freezed
class FriendRequestModel with _$FriendRequestModel {
  const factory FriendRequestModel({
    required String id,
    required String fromUserId,
    required String fromDisplayName,
    String? fromPhotoUrl,
    required String toUserId,
    required String toDisplayName,
    String? toPhotoUrl,
    required DateTime sentAt,
    @Default(FriendRequestStatus.pending) FriendRequestStatus status,
  }) = _FriendRequestModel;

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestModelFromJson(json);
}

enum FriendRequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
}

@freezed
class RecentPlayerModel with _$RecentPlayerModel {
  const factory RecentPlayerModel({
    required String userId,
    required String displayName,
    String? photoUrl,
    required DateTime lastPlayedWith,
    required int gamesPlayed,
  }) = _RecentPlayerModel;

  factory RecentPlayerModel.fromJson(Map<String, dynamic> json) =>
      _$RecentPlayerModelFromJson(json);
}
