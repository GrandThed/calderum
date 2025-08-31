import 'package:freezed_annotation/freezed_annotation.dart';

part 'emote_model.freezed.dart';
part 'emote_model.g.dart';

enum EmoteType {
  @JsonValue('thumbsUp')
  thumbsUp,
  @JsonValue('thumbsDown')
  thumbsDown,
  @JsonValue('laugh')
  laugh,
  @JsonValue('wow')
  wow,
  @JsonValue('sad')
  sad,
  @JsonValue('angry')
  angry,
  @JsonValue('heart')
  heart,
  @JsonValue('fire')
  fire,
  @JsonValue('think')
  think,
  @JsonValue('celebrate')
  celebrate,
}

@freezed
class EmoteModel with _$EmoteModel {
  const factory EmoteModel({
    required String userId,
    required String displayName,
    required EmoteType type,
    required DateTime timestamp,
  }) = _EmoteModel;

  factory EmoteModel.fromJson(Map<String, dynamic> json) =>
      _$EmoteModelFromJson(json);
}

extension EmoteTypeExtension on EmoteType {
  String get emoji {
    switch (this) {
      case EmoteType.thumbsUp:
        return '👍';
      case EmoteType.thumbsDown:
        return '👎';
      case EmoteType.laugh:
        return '😂';
      case EmoteType.wow:
        return '😮';
      case EmoteType.sad:
        return '😢';
      case EmoteType.angry:
        return '😠';
      case EmoteType.heart:
        return '❤️';
      case EmoteType.fire:
        return '🔥';
      case EmoteType.think:
        return '🤔';
      case EmoteType.celebrate:
        return '🎉';
    }
  }

  String get label {
    switch (this) {
      case EmoteType.thumbsUp:
        return 'Good';
      case EmoteType.thumbsDown:
        return 'Bad';
      case EmoteType.laugh:
        return 'Funny';
      case EmoteType.wow:
        return 'Wow';
      case EmoteType.sad:
        return 'Sad';
      case EmoteType.angry:
        return 'Angry';
      case EmoteType.heart:
        return 'Love';
      case EmoteType.fire:
        return 'Fire';
      case EmoteType.think:
        return 'Thinking';
      case EmoteType.celebrate:
        return 'Celebrate';
    }
  }
}