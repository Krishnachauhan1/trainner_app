import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole { member, trainer }

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required UserRole role,
    String? avatarUrl,
    String? trainerId,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
