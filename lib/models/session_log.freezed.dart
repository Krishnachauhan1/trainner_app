// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SessionLog _$SessionLogFromJson(Map<String, dynamic> json) {
  return _SessionLog.fromJson(json);
}

/// @nodoc
mixin _$SessionLog {
  String get id => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  String get memberName => throw _privateConstructorUsedError;
  String get trainerId => throw _privateConstructorUsedError;
  String get trainerName => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime get endedAt => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int get memberRating => throw _privateConstructorUsedError;
  int get trainerRating => throw _privateConstructorUsedError;

  /// Serializes this SessionLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionLogCopyWith<SessionLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionLogCopyWith<$Res> {
  factory $SessionLogCopyWith(
    SessionLog value,
    $Res Function(SessionLog) then,
  ) = _$SessionLogCopyWithImpl<$Res, SessionLog>;
  @useResult
  $Res call({
    String id,
    String memberId,
    String memberName,
    String trainerId,
    String trainerName,
    String roomId,
    DateTime startedAt,
    DateTime endedAt,
    int durationSeconds,
    String? notes,
    int memberRating,
    int trainerRating,
  });
}

/// @nodoc
class _$SessionLogCopyWithImpl<$Res, $Val extends SessionLog>
    implements $SessionLogCopyWith<$Res> {
  _$SessionLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? memberName = null,
    Object? trainerId = null,
    Object? trainerName = null,
    Object? roomId = null,
    Object? startedAt = null,
    Object? endedAt = null,
    Object? durationSeconds = null,
    Object? notes = freezed,
    Object? memberRating = null,
    Object? trainerRating = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            memberId: null == memberId
                ? _value.memberId
                : memberId // ignore: cast_nullable_to_non_nullable
                      as String,
            memberName: null == memberName
                ? _value.memberName
                : memberName // ignore: cast_nullable_to_non_nullable
                      as String,
            trainerId: null == trainerId
                ? _value.trainerId
                : trainerId // ignore: cast_nullable_to_non_nullable
                      as String,
            trainerName: null == trainerName
                ? _value.trainerName
                : trainerName // ignore: cast_nullable_to_non_nullable
                      as String,
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endedAt: null == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            durationSeconds: null == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            memberRating: null == memberRating
                ? _value.memberRating
                : memberRating // ignore: cast_nullable_to_non_nullable
                      as int,
            trainerRating: null == trainerRating
                ? _value.trainerRating
                : trainerRating // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionLogImplCopyWith<$Res>
    implements $SessionLogCopyWith<$Res> {
  factory _$$SessionLogImplCopyWith(
    _$SessionLogImpl value,
    $Res Function(_$SessionLogImpl) then,
  ) = __$$SessionLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String memberId,
    String memberName,
    String trainerId,
    String trainerName,
    String roomId,
    DateTime startedAt,
    DateTime endedAt,
    int durationSeconds,
    String? notes,
    int memberRating,
    int trainerRating,
  });
}

/// @nodoc
class __$$SessionLogImplCopyWithImpl<$Res>
    extends _$SessionLogCopyWithImpl<$Res, _$SessionLogImpl>
    implements _$$SessionLogImplCopyWith<$Res> {
  __$$SessionLogImplCopyWithImpl(
    _$SessionLogImpl _value,
    $Res Function(_$SessionLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? memberName = null,
    Object? trainerId = null,
    Object? trainerName = null,
    Object? roomId = null,
    Object? startedAt = null,
    Object? endedAt = null,
    Object? durationSeconds = null,
    Object? notes = freezed,
    Object? memberRating = null,
    Object? trainerRating = null,
  }) {
    return _then(
      _$SessionLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        memberId: null == memberId
            ? _value.memberId
            : memberId // ignore: cast_nullable_to_non_nullable
                  as String,
        memberName: null == memberName
            ? _value.memberName
            : memberName // ignore: cast_nullable_to_non_nullable
                  as String,
        trainerId: null == trainerId
            ? _value.trainerId
            : trainerId // ignore: cast_nullable_to_non_nullable
                  as String,
        trainerName: null == trainerName
            ? _value.trainerName
            : trainerName // ignore: cast_nullable_to_non_nullable
                  as String,
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endedAt: null == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        durationSeconds: null == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        memberRating: null == memberRating
            ? _value.memberRating
            : memberRating // ignore: cast_nullable_to_non_nullable
                  as int,
        trainerRating: null == trainerRating
            ? _value.trainerRating
            : trainerRating // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionLogImpl implements _SessionLog {
  const _$SessionLogImpl({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.trainerId,
    required this.trainerName,
    required this.roomId,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
    this.notes,
    this.memberRating = 0,
    this.trainerRating = 0,
  });

  factory _$SessionLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionLogImplFromJson(json);

  @override
  final String id;
  @override
  final String memberId;
  @override
  final String memberName;
  @override
  final String trainerId;
  @override
  final String trainerName;
  @override
  final String roomId;
  @override
  final DateTime startedAt;
  @override
  final DateTime endedAt;
  @override
  final int durationSeconds;
  @override
  final String? notes;
  @override
  @JsonKey()
  final int memberRating;
  @override
  @JsonKey()
  final int trainerRating;

  @override
  String toString() {
    return 'SessionLog(id: $id, memberId: $memberId, memberName: $memberName, trainerId: $trainerId, trainerName: $trainerName, roomId: $roomId, startedAt: $startedAt, endedAt: $endedAt, durationSeconds: $durationSeconds, notes: $notes, memberRating: $memberRating, trainerRating: $trainerRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.memberRating, memberRating) ||
                other.memberRating == memberRating) &&
            (identical(other.trainerRating, trainerRating) ||
                other.trainerRating == trainerRating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    memberId,
    memberName,
    trainerId,
    trainerName,
    roomId,
    startedAt,
    endedAt,
    durationSeconds,
    notes,
    memberRating,
    trainerRating,
  );

  /// Create a copy of SessionLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionLogImplCopyWith<_$SessionLogImpl> get copyWith =>
      __$$SessionLogImplCopyWithImpl<_$SessionLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionLogImplToJson(this);
  }
}

abstract class _SessionLog implements SessionLog {
  const factory _SessionLog({
    required final String id,
    required final String memberId,
    required final String memberName,
    required final String trainerId,
    required final String trainerName,
    required final String roomId,
    required final DateTime startedAt,
    required final DateTime endedAt,
    required final int durationSeconds,
    final String? notes,
    final int memberRating,
    final int trainerRating,
  }) = _$SessionLogImpl;

  factory _SessionLog.fromJson(Map<String, dynamic> json) =
      _$SessionLogImpl.fromJson;

  @override
  String get id;
  @override
  String get memberId;
  @override
  String get memberName;
  @override
  String get trainerId;
  @override
  String get trainerName;
  @override
  String get roomId;
  @override
  DateTime get startedAt;
  @override
  DateTime get endedAt;
  @override
  int get durationSeconds;
  @override
  String? get notes;
  @override
  int get memberRating;
  @override
  int get trainerRating;

  /// Create a copy of SessionLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionLogImplCopyWith<_$SessionLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
