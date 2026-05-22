// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CallRequest _$CallRequestFromJson(Map<String, dynamic> json) {
  return _CallRequest.fromJson(json);
}

/// @nodoc
mixin _$CallRequest {
  String get id => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  String get memberName => throw _privateConstructorUsedError;
  String get trainerId => throw _privateConstructorUsedError;
  DateTime get slotStart => throw _privateConstructorUsedError;
  DateTime get slotEnd => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  CallRequestStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get declineReason => throw _privateConstructorUsedError;
  String? get roomId => throw _privateConstructorUsedError;

  /// Serializes this CallRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CallRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CallRequestCopyWith<CallRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallRequestCopyWith<$Res> {
  factory $CallRequestCopyWith(
    CallRequest value,
    $Res Function(CallRequest) then,
  ) = _$CallRequestCopyWithImpl<$Res, CallRequest>;
  @useResult
  $Res call({
    String id,
    String memberId,
    String memberName,
    String trainerId,
    DateTime slotStart,
    DateTime slotEnd,
    String note,
    CallRequestStatus status,
    DateTime createdAt,
    String? declineReason,
    String? roomId,
  });
}

/// @nodoc
class _$CallRequestCopyWithImpl<$Res, $Val extends CallRequest>
    implements $CallRequestCopyWith<$Res> {
  _$CallRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CallRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? memberName = null,
    Object? trainerId = null,
    Object? slotStart = null,
    Object? slotEnd = null,
    Object? note = null,
    Object? status = null,
    Object? createdAt = null,
    Object? declineReason = freezed,
    Object? roomId = freezed,
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
            slotStart: null == slotStart
                ? _value.slotStart
                : slotStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            slotEnd: null == slotEnd
                ? _value.slotEnd
                : slotEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            note: null == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as CallRequestStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            declineReason: freezed == declineReason
                ? _value.declineReason
                : declineReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            roomId: freezed == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CallRequestImplCopyWith<$Res>
    implements $CallRequestCopyWith<$Res> {
  factory _$$CallRequestImplCopyWith(
    _$CallRequestImpl value,
    $Res Function(_$CallRequestImpl) then,
  ) = __$$CallRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String memberId,
    String memberName,
    String trainerId,
    DateTime slotStart,
    DateTime slotEnd,
    String note,
    CallRequestStatus status,
    DateTime createdAt,
    String? declineReason,
    String? roomId,
  });
}

/// @nodoc
class __$$CallRequestImplCopyWithImpl<$Res>
    extends _$CallRequestCopyWithImpl<$Res, _$CallRequestImpl>
    implements _$$CallRequestImplCopyWith<$Res> {
  __$$CallRequestImplCopyWithImpl(
    _$CallRequestImpl _value,
    $Res Function(_$CallRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CallRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? memberName = null,
    Object? trainerId = null,
    Object? slotStart = null,
    Object? slotEnd = null,
    Object? note = null,
    Object? status = null,
    Object? createdAt = null,
    Object? declineReason = freezed,
    Object? roomId = freezed,
  }) {
    return _then(
      _$CallRequestImpl(
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
        slotStart: null == slotStart
            ? _value.slotStart
            : slotStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        slotEnd: null == slotEnd
            ? _value.slotEnd
            : slotEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        note: null == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as CallRequestStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        declineReason: freezed == declineReason
            ? _value.declineReason
            : declineReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        roomId: freezed == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CallRequestImpl implements _CallRequest {
  const _$CallRequestImpl({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.trainerId,
    required this.slotStart,
    required this.slotEnd,
    required this.note,
    required this.status,
    required this.createdAt,
    this.declineReason,
    this.roomId,
  });

  factory _$CallRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String memberId;
  @override
  final String memberName;
  @override
  final String trainerId;
  @override
  final DateTime slotStart;
  @override
  final DateTime slotEnd;
  @override
  final String note;
  @override
  final CallRequestStatus status;
  @override
  final DateTime createdAt;
  @override
  final String? declineReason;
  @override
  final String? roomId;

  @override
  String toString() {
    return 'CallRequest(id: $id, memberId: $memberId, memberName: $memberName, trainerId: $trainerId, slotStart: $slotStart, slotEnd: $slotEnd, note: $note, status: $status, createdAt: $createdAt, declineReason: $declineReason, roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.slotStart, slotStart) ||
                other.slotStart == slotStart) &&
            (identical(other.slotEnd, slotEnd) || other.slotEnd == slotEnd) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.declineReason, declineReason) ||
                other.declineReason == declineReason) &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    memberId,
    memberName,
    trainerId,
    slotStart,
    slotEnd,
    note,
    status,
    createdAt,
    declineReason,
    roomId,
  );

  /// Create a copy of CallRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CallRequestImplCopyWith<_$CallRequestImpl> get copyWith =>
      __$$CallRequestImplCopyWithImpl<_$CallRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallRequestImplToJson(this);
  }
}

abstract class _CallRequest implements CallRequest {
  const factory _CallRequest({
    required final String id,
    required final String memberId,
    required final String memberName,
    required final String trainerId,
    required final DateTime slotStart,
    required final DateTime slotEnd,
    required final String note,
    required final CallRequestStatus status,
    required final DateTime createdAt,
    final String? declineReason,
    final String? roomId,
  }) = _$CallRequestImpl;

  factory _CallRequest.fromJson(Map<String, dynamic> json) =
      _$CallRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get memberId;
  @override
  String get memberName;
  @override
  String get trainerId;
  @override
  DateTime get slotStart;
  @override
  DateTime get slotEnd;
  @override
  String get note;
  @override
  CallRequestStatus get status;
  @override
  DateTime get createdAt;
  @override
  String? get declineReason;
  @override
  String? get roomId;

  /// Create a copy of CallRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CallRequestImplCopyWith<_$CallRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
