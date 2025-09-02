import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_invitation_model.freezed.dart';
part 'room_invitation_model.g.dart';

@freezed
class RoomInvitationModel with _$RoomInvitationModel {
  const factory RoomInvitationModel({
    required String id,
    required String roomId,
    required String roomCode,
    required String fromUserId,
    required String fromUserName,
    required String toUserId,
    required InvitationStatus status,
    required DateTime createdAt,
    DateTime? respondedAt,
    String? message,
  }) = _RoomInvitationModel;

  factory RoomInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$RoomInvitationModelFromJson(json);
}

enum InvitationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
  @JsonValue('expired')
  expired,
}
