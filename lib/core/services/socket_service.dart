import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';

import '../constants/api_constants.dart';
import '../../presentation/providers/auth_provider.dart';

/// Laravel Reverb (WebSocket) bilan ishlash uchun servis (Teacher App)
class SocketService {
  Echo? _echo;
  final String? _token;

  SocketService(this._token) {
    if (_token != null) {
      _initEcho();
    }
  }

  void _initEcho() {
    try {
      final options = PusherOptions(
        host: ApiConstants.reverbHost,
        wsPort: ApiConstants.reverbPort,
        wssPort: ApiConstants.reverbPort,
        encrypted: false,
        auth: PusherAuth(
          '${ApiConstants.baseUrl}/broadcasting/auth',
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          },
        ),
      );

      final pusherClient = PusherClient(
        ApiConstants.reverbKey,
        options,
        autoConnect: true,
      );

      _echo = Echo(
        client: pusherClient,
        broadcaster: EchoBroadcasterType.Pusher,
      );

      log('WebSocket: Echo initialized for Teacher App');
    } catch (e) {
      log('WebSocket: Initialization error: $e');
    }
  }

  /// Hususiy kanalga ulanish
  void listenPrivate(
    String channelName,
    String eventName,
    Function(Map<String, dynamic>) onEvent,
  ) {
    if (_echo == null) return;

    _echo!.private(channelName).listen(eventName, (data) {
      log('WebSocket Event [$eventName] on [$channelName]: $data');
      onEvent(Map<String, dynamic>.from(data));
    });
  }

  /// Kanalni tark etish
  void leaveChannel(String channelName) {
    _echo?.leave(channelName);
  }

  /// WebSocket ulanishini uzish
  void disconnect() {
    _echo?.disconnect();
    log('WebSocket: Disconnected');
  }
}

/// SocketService Provider
final socketServiceProvider = Provider<SocketService?>((ref) {
  final authState = ref.watch(authControllerProvider);

  if (!authState.isAuthenticated || authState.token == null) {
    return null;
  }

  return SocketService(authState.token);
});
