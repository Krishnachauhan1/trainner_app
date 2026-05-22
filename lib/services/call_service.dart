import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../models/room_meta.dart';
import '../models/user.dart';
import '../utils/app_logger.dart';
import '../utils/env_config.dart';

enum CallState {
  idle,
  preview,
  joining,
  inCall,
  reconnecting,
  ended,
  error,
}

class CallParticipant {
  CallParticipant({
    required this.peerId,
    required this.name,
    required this.isLocal,
    this.isVideoOn = true,
    this.isAudioOn = true,
  });

  final String peerId;
  final String name;
  final bool isLocal;
  final bool isVideoOn;
  final bool isAudioOn;
}

abstract class CallService {
  Stream<CallState> get stateStream;
  Stream<List<CallParticipant>> get participantsStream;
  CallState get state;
  DateTime? get callStartedAt;
  Future<String> fetchAuthToken({
    required String userId,
    required UserRole role,
    required String roomId,
  });
  Future<bool> requestPermissions();
  Future<void> startPreview({
    required String userName,
    required String authToken,
  });
  Future<void> joinRoom({
    required String userName,
    required String authToken,
    required RoomMeta meta,
  });
  Future<void> toggleMute();
  Future<void> toggleVideo();
  Future<void> flipCamera();
  Future<void> leaveRoom();
  void dispose();
}

class HmsCallService implements CallService {
  HmsCallService(this._env);

  final EnvConfig _env;
  HMSSDK? _hms;
  _HmsListener? _listener;
  CallState _state = CallState.idle;
  DateTime? _callStartedAt;
  final _stateCtrl = StreamController<CallState>.broadcast();
  final _participantsCtrl =
      StreamController<List<CallParticipant>>.broadcast();

  @override
  Stream<CallState> get stateStream => _stateCtrl.stream;

  @override
  Stream<List<CallParticipant>> get participantsStream =>
      _participantsCtrl.stream;

  @override
  CallState get state => _state;

  @override
  DateTime? get callStartedAt => _callStartedAt;

  Future<HMSSDK> get _sdk async {
    if (_hms == null) {
      _hms = HMSSDK();
      await _hms!.build();
    }
    return _hms!;
  }

  void _setState(CallState s) {
    _state = s;
    _stateCtrl.add(s);
    AppLogger.instance.log(LogCategory.rtc, s.name);
  }

  @override
  Future<String> fetchAuthToken({
    required String userId,
    required UserRole role,
    required String roomId,
  }) async {
    final roleStr = role == UserRole.trainer ? 'trainer' : 'member';
    final uri = Uri.parse(
      '${_env.tokenServerUrl}/token?userId=$userId&role=$roleStr&roomId=$roomId',
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Token fetch failed: ${res.body}');
    }
    final body = res.body.trim();
    if (body.startsWith('{')) {
      final map = jsonDecode(body) as Map<String, dynamic>;
      final token = map['token'] as String?;
      if (token != null) {
        AppLogger.instance.log(LogCategory.rtc, 'Token fetched');
        return token;
      }
    }
    AppLogger.instance.log(LogCategory.rtc, 'Token fetched (raw)');
    return body;
  }

  @override
  Future<bool> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();
    final cam = await Permission.camera.status;
    final mic = await Permission.microphone.status;
    return cam.isGranted && mic.isGranted;
  }

  @override
  Future<void> startPreview({
    required String userName,
    required String authToken,
  }) async {
    _setState(CallState.preview);
    final sdk = await _sdk;
    _listener = _HmsListener(this, userName);
    sdk.addUpdateListener(listener: _listener!);
    await sdk.preview(
      config: HMSConfig(authToken: authToken, userName: userName),
    );
    _emitParticipants([
      CallParticipant(peerId: 'local', name: userName, isLocal: true),
    ]);
  }

  @override
  Future<void> joinRoom({
    required String userName,
    required String authToken,
    required RoomMeta meta,
  }) async {
    _setState(CallState.joining);
    final sdk = await _sdk;
    _listener ??= _HmsListener(this, userName);
    sdk.addUpdateListener(listener: _listener!);
    await sdk.join(
      config: HMSConfig(
        authToken: authToken,
        userName: userName,
        metaData: '{"room":"${meta.roomId}"}',
      ),
    );
    _callStartedAt = DateTime.now();
    _setState(CallState.inCall);
  }

  void _emitParticipants(List<CallParticipant> list) =>
      _participantsCtrl.add(list);

  void onPeers(List<HMSPeer> peers, String localName) {
    if (peers.isEmpty) {
      _emitParticipants([
        CallParticipant(peerId: 'local', name: localName, isLocal: true),
      ]);
      return;
    }
    _emitParticipants(
      peers
          .map(
            (p) => CallParticipant(
              peerId: p.peerId,
              name: p.name,
              isLocal: p.isLocal,
              isVideoOn: !(p.videoTrack?.isMute ?? false),
              isAudioOn: !(p.audioTrack?.isMute ?? false),
            ),
          )
          .toList(),
    );
  }

  void onReconnecting() => _setState(CallState.reconnecting);

  void onReconnected() => _setState(CallState.inCall);

  void onError() => _setState(CallState.error);

  @override
  Future<void> toggleMute() async {
    final sdk = await _sdk;
    await sdk.toggleMicMuteState();
  }

  @override
  Future<void> toggleVideo() async {
    final sdk = await _sdk;
    await sdk.toggleCameraMuteState();
  }

  @override
  Future<void> flipCamera() async {
    final sdk = await _sdk;
    await sdk.switchCamera();
  }

  @override
  Future<void> leaveRoom() async {
    final sdk = await _sdk;
    await sdk.leave();
    _setState(CallState.ended);
    _emitParticipants([]);
  }

  @override
  void dispose() {
    _stateCtrl.close();
    _participantsCtrl.close();
  }
}

class _HmsListener implements HMSUpdateListener {
  _HmsListener(this._service, this._localName);

  final HmsCallService _service;
  final String _localName;

  @override
  void onJoin({required HMSRoom room}) {
    _service.onPeers(room.peers ?? [], _localName);
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {}

  @override
  void onReconnected() => _service.onReconnected();

  @override
  void onReconnecting() => _service.onReconnecting();

  @override
  void onHMSError({required HMSException error}) => _service.onError();

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    if (room.peers != null) {
      _service.onPeers(room.peers!, _localName);
    }
  }

  @override
  void onTrackUpdate({
    required HMSTrack track,
    required HMSTrackUpdate trackUpdate,
    required HMSPeer peer,
  }) {}

  @override
  void onAudioDeviceChanged({
    HMSAudioDevice? currentAudioDevice,
    List<HMSAudioDevice>? availableAudioDevice,
  }) {}

  @override
  void onChangeTrackStateRequest({
    required HMSTrackChangeRequest hmsTrackChangeRequest,
  }) {}

  @override
  void onMessage({required HMSMessage message}) {}

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}

  @override
  void onRemovedFromRoom({
    required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer,
  }) {
    _service.leaveRoom();
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {}

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}

  @override
  void onPeerListUpdate({
    required List<HMSPeer> addedPeers,
    required List<HMSPeer> removedPeers,
  }) {}
}
