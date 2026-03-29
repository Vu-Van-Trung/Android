import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'api_client.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  io.Socket? _socket;
  String? currentChatId;
  bool get isConnected => _socket?.connected ?? false;
  
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onMessage => _messageController.stream;

  void connect() {
    if (_socket != null && _socket!.connected) return;
    
    final userId = ApiClient().userId;
    if (userId == null) return;

    // Default to port 3000 on the same host if baseUrl uses 8000
    final socketUrl = ApiClient.baseUrl.replaceFirst(':8000', ':3000');

    _socket = io.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.onConnect((_) {
      debugPrint('====> GLOBAL SOCKET CONNECTED <====');
      _socket!.emit('join', userId);
    });

    _socket!.on('receiveMessage', (data) {
      if (data is Map) {
        _messageController.add(Map<String, dynamic>.from(data));
      } else {
        debugPrint('Socket receiveMessage payload is not a Map: $data');
      }
    });

    _socket!.onDisconnect((_) {
      debugPrint('====> GLOBAL SOCKET DISCONNECTED <====');
    });
  }

  void sendMessage(Map<String, dynamic> payload) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('sendMessage', payload);
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
