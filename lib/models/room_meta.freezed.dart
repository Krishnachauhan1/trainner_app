// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoomMeta _$RoomMetaFromJson(Map<String, dynamic> json) {
  return _RoomMeta.fromJson(json);
}

/// @nodoc
mixin _$RoomMeta {
  String get roomId => throw _privateConstructorUsedError;
  String get templateId => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  String get trainerId => throw _privateConstructorUsedError;
  UserRole get memberRole => throw _privateConstructorUsedError;
  DateTime get scheduledAt => throw _privateConstructorUsedError;
  String? get callRequestId => throw _privateConstructorUsedError;

  /// Serializes this RoomMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoomMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomMetaCopyWith<RoomMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomMetaCopyWith<$Res> {
  factory $RoomMetaCopyWith(RoomMeta value, $Res Function(RoomMeta) then) =
      _$RoomMetaCopyWithImpl<$Res, RoomMeta>;
  @useResult
  $Res call({
    String roomId,
    String templateId,
    String memberId,
    String trainerId,
    UserRole memberRole,
    DateTime scheduledAt,
    String? callRequestId,
  });
}

/// @nodoc
class _$RoomMetaCopyWithImpl<$Res, $Val extends RoomMeta>
    implements $RoomMetaCopyWith<$Res> {
  _$RoomMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? templateId = null,
    Object? memberId = null,
    Object? trainerId = null,
    Object? memberRole = null,
    Object? scheduledAt = null,
    Object? callRequestId = freezed,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            templateId: null == templateId
                ? _value.templateId
                : templateId // ignore: cast_nullable_to_non_nullable
                      as String,
            memberId: null == memberId
                ? _value.memberId
                : memberId // ignore: cast_nullable_to_non_nullable
                      as String,
            trainerId: null == trainerId
                ? _value.trainerId
                : trainerId // ignore: cast_nullable_to_non_nullable
                      as String,
            memberRole: null == memberRole
                ? _value.memberRole
                : memberRole // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            scheduledAt: null == scheduledAt
                ? _value.scheduledAt
                : scheduledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            callRequestId: freezed == callRequestId
                ? _value.callRequestId
                : callRequestId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoomMetaImplCopyWith<$Res>
    implements $RoomMetaCopyWith<$Res> {
  factory _$$RoomMetaImplCopyWith(
    _$RoomMetaImpl value,
    $Res Function(_$RoomMetaImpl) then,
  ) = __$$RoomMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    String templateId,
    String memberId,
    String trainerId,
    UserRole memberRole,
    DateTime scheduledAt,
    String? callRequestId,
  });
}

/// @nodoc
class __$$RoomMetaImplCopyWithImpl<$Res>
    extends _$RoomMetaCopyWithImpl<$Res, _$RoomMetaImpl>
    implements _$$RoomMetaImplCopyWith<$Res> {
  __$$RoomMetaImplCopyWithImpl(
    _$RoomMetaImpl _value,
    $Res Function(_$RoomMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? templateId = null,
    Object? memberId = null,
    Object? trainerId = null,
    Object? memberRole = null,
    Object? scheduledAt = null,
    Object? callRequestId = freezed,
  }) {
    return _then(
      _$RoomMetaImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        templateId: null == templateId
            ? _value.templateId
            : templateId // ignore: cast_nullable_to_non_nullable
                  as String,
        memberId: null == memberId
            ? _value.memberId
            : memberId // ignore: cast_nullable_to_non_nullable
                  as String,
        trainerId: null == trainerId
            ? _value.trainerId
            : trainerId // ignore: cast_nullable_to_non_nullable
                  as String,
        memberRole: null == memberRole
            ? _value.memberRole
            : memberRole // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        scheduledAt: null == scheduledAt
            ? _value.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        callRequestId: freezed == callRequestId
            ? _value.callRequestId
            : callRequestId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomMetaImpl implements _RoomMeta {
  const _$RoomMetaImpl({
    required this.roomId,
    required this.templateId,
    required this.memberId,
    required this.trainerId,
    required this.memberRole,
    required this.scheduledAt,
    this.callRequestId,
  });

  factory _$RoomMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomMetaImplFromJson(json);

  @override
  final String roomId;
  @override
  final String templateId;
  @override
  final String memberId;
  @override
  final String trainerId;
  @override
  final UserRole memberRole;
  @override
  final DateTime scheduledAt;
  @override
  final String? callRequestId;

  @override
  String toString() {
    return 'RoomMeta(roomId: $roomId, templateId: $templateId, memberId: $memberId, trainerId: $trainerId, memberRole: $memberRole, scheduledAt: $scheduledAt, callRequestId: $callRequestId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomMetaImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.memberRole, memberRole) ||
                other.memberRole == memberRole) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.callRequestId, callRequestId) ||
                other.callRequestId == callRequestId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    templateId,
    memberId,
    trainerId,
    memberRole,
    scheduledAt,
    callRequestId,
  );

  /// Create a copy of RoomMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomMetaImplCopyWith<_$RoomMetaImpl> get copyWith =>
      __$$RoomMetaImplCopyWithImpl<_$RoomMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomMetaImplToJson(this);
  }
}

abstract class _RoomMeta implements RoomMeta {
  const factory _RoomMeta({
    required final String roomId,
    required final String templateId,
    required final String memberId,
    required final String trainerId,
    required final UserRole memberRole,
    required final DateTime scheduledAt,
    final String? callRequestId,
  }) = _$RoomMetaImpl;

  factory _RoomMeta.fromJson(Map<String, dynamic> json) =
      _$RoomMetaImpl.fromJson;

  @override
  String get roomId;
  @override
  String get templateId;
  @override
  String get memberId;
  @override
  String get trainerId;
  @override
  UserRole get memberRole;
  @override
  DateTime get scheduledAt;
  @override
  String? get callRequestId;

  /// Create a copy of RoomMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomMetaImplCopyWith<_$RoomMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
