import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:crypto/crypto.dart';

class RemoteControlState {
  final bool isConnected;
  final bool isAuthenticated;
  final Uint8List? frameBytes;
  final String? error;
  final int latency;
  final String salt;
  final int quality;

  RemoteControlState({
    this.isConnected = false,
    this.isAuthenticated = false,
    this.frameBytes,
    this.error,
    this.latency = 0,
    this.salt = '',
    this.quality = 60,
  });

  RemoteControlState copyWith({
    bool? isConnected,
    bool? isAuthenticated,
    Uint8List? frameBytes,
    String? error,
    int? latency,
    String? salt,
    int? quality,
  }) {
    return RemoteControlState(
      isConnected: isConnected ?? this.isConnected,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      frameBytes: frameBytes ?? this.frameBytes,
      error: error ?? this.error,
      latency: latency ?? this.latency,
      salt: salt ?? this.salt,
      quality: quality ?? this.quality,
    );
  }
}

class RemoteControlNotifier extends StateNotifier<RemoteControlState> {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  DateTime? _pingTime;

  RemoteControlNotifier() : super(RemoteControlState());

  Future<void> connect(String ipAddress, String port, String password) async {
    state = RemoteControlState(isConnected: false, error: null);
    
    final url = 'ws://$ipAddress:$port';
    try {
      final wsUri = Uri.parse(url);
      _channel = WebSocketChannel.connect(wsUri);
      
      state = state.copyWith(isConnected: true);
      
      _subscription = _channel!.stream.listen(
        (data) {
          if (data is Uint8List) {
            // Binary data -> video frame
            if (_pingTime != null) {
              final lat = DateTime.now().difference(_pingTime!).inMilliseconds;
              state = state.copyWith(frameBytes: data, latency: lat, error: null);
              _pingTime = null;
            } else {
              state = state.copyWith(frameBytes: data, error: null);
            }
          } else if (data is String) {
            // Text data -> control payload or handshake
            _handleTextPayload(data, password);
          }
        },
        onError: (err) {
          state = state.copyWith(
            isConnected: false,
            isAuthenticated: false,
            error: 'Помилка підключення: ${err.toString()}',
          );
          disconnect();
        },
        onDone: () {
          state = state.copyWith(
            isConnected: false,
            isAuthenticated: false,
            error: 'З\'єднання закрито сервером.',
          );
          disconnect();
        },
      );
    } catch (e) {
      state = state.copyWith(
        isConnected: false,
        isAuthenticated: false,
        error: 'Не вдалося підключитися: ${e.toString()}',
      );
    }
  }

  void _handleTextPayload(String data, String password) {
    try {
      final payload = jsonDecode(data) as Map<String, dynamic>;
      final type = payload['type'] as String?;

      if (type == 'challenge') {
        final salt = payload['salt'] as String? ?? '';
        state = state.copyWith(salt: salt);
        _respondToChallenge(password, salt);
      } else if (type == 'auth_success') {
        state = state.copyWith(isAuthenticated: true, error: null);
        // Request initial frame quality
        setQuality(state.quality);
      } else if (type == 'auth_failure') {
        final reason = payload['reason'] as String? ?? 'Невірний пароль';
        state = state.copyWith(
          isAuthenticated: false,
          error: 'Помилка входу: $reason',
        );
        disconnect();
      }
    } catch (e) {
      debugPrint('Failed to parse text payload: $e');
    }
  }

  void _respondToChallenge(String password, String salt) {
    if (_channel == null) return;
    
    // Hash password + salt using SHA-256
    final bytes = utf8.encode(password + salt);
    final hash = sha256.convert(bytes).toString();

    final response = {
      'type': 'auth',
      'hash': hash,
    };
    _channel!.sink.add(jsonEncode(response));
  }

  void sendMouseMove(double x, double y) {
    if (_channel == null || !state.isAuthenticated) return;
    
    final payload = {
      'type': 'mouse_move',
      'x': x.clamp(0.0, 1.0),
      'y': y.clamp(0.0, 1.0),
    };
    _channel!.sink.add(jsonEncode(payload));
  }

  void sendMouseClick(String button, {bool doubleClick = false}) {
    if (_channel == null || !state.isAuthenticated) return;
    
    final payload = {
      'type': 'mouse_click',
      'button': button,
      'double': doubleClick,
    };
    _channel!.sink.add(jsonEncode(payload));
  }

  void sendMouseScroll(int dy) {
    if (_channel == null || !state.isAuthenticated) return;
    
    final payload = {
      'type': 'mouse_scroll',
      'dy': dy,
    };
    _channel!.sink.add(jsonEncode(payload));
  }

  void sendKeyPress(String key, {List<String> modifiers = const []}) {
    if (_channel == null || !state.isAuthenticated) return;
    
    final payload = {
      'type': 'key_press',
      'key': key,
      'modifiers': modifiers,
    };
    _channel!.sink.add(jsonEncode(payload));
  }

  void setQuality(int newQuality) {
    if (_channel == null || !state.isAuthenticated) return;
    
    final q = newQuality.clamp(10, 100);
    state = state.copyWith(quality: q);
    
    final payload = {
      'type': 'set_quality',
      'quality': q,
    };
    _channel!.sink.add(jsonEncode(payload));
  }

  void measureLatency() {
    _pingTime = DateTime.now();
  }

  void disconnect() {
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
    state = RemoteControlState();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}

final remoteControlProvider = StateNotifierProvider<RemoteControlNotifier, RemoteControlState>((ref) {
  return RemoteControlNotifier();
});
