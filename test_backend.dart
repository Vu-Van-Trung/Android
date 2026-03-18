import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:io';

const String baseUrl = 'http://127.0.0.1:3000/api';
const String wsUrl = 'http://127.0.0.1:3000';

void main() async {
  print('==== BẮT ĐẦU TEST API BACKEND ====');
  
  // Tạo tài khoản ngẫu nhiên để test
  final String testUser = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
  final String testPass = 'password123';
  
  // 1. Test Đăng ký
  print('\n1. Đang test Đăng ký tài khoản ($testUser)...');
  try {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': testUser, 'password': testPass}),
    );
    if (res.statusCode == 201) {
      print('✅ Đăng ký thành công!');
    } else {
      print('❌ Đăng ký thất bại: ${res.statusCode} - ${res.body}');
      return;
    }
  } catch (e) {
    print('❌ Lỗi kết nối (Server chưa bật?): $e');
    return;
  }
  
  // 2. Test Đăng nhập & Lấy Token
  print('\n2. Đang test Đăng nhập...');
  String token = '';
  String userId = '';
  try {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': testUser, 'password': testPass}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      token = data['token'];
      userId = data['user']['id'];
      print('✅ Đăng nhập thành công! Nhận được User ID: $userId');
    } else {
      print('❌ Đăng nhập thất bại: ${res.statusCode} - ${res.body}');
      return;
    }
  } catch (e) {
    print('❌ Lỗi kết nối: $e');
    return;
  }
  
  // 3. Test gửi tin nhắn (HTTP)
  print('\n3. Đang test Gửi tin nhắn qua API...');
  try {
    // Tự gửi tin nhắn cho bản thân
    final res = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'receiver': userId,
        'content': 'Hello, đây là tin nhắn test từ API!'
      }),
    );
    if (res.statusCode == 201) {
      print('✅ Gửi thông điệp lưu qua HTTP API thành công!');
    } else {
      print('❌ Gửi thông điệp thất bại: ${res.statusCode} - ${res.body}');
    }
  } catch (e) {
    print('❌ Lỗi kết nối API Messages: $e');
  }

  // 4. Test WebSocket Real-time
  print('\n4. Đang test kết nối WebSocket Realtime...');
  
  IO.Socket socket = IO.io(wsUrl, IO.OptionBuilder()
      .setTransports(['websocket']) 
      .disableAutoConnect()  
      .build());

  socket.connect();

  socket.onConnect((_) {
    print('✅ Đã kết nối Socket.io với server (ID: ${socket.id})');
    socket.emit('join', userId);
    print('=> Đã join room: $userId. Chuẩn bị nhận tin nhắn test...');
    
    // Đợi 1 giây rồi gửi 1 tin qua socket, lúc đó nó sẽ bắn lại qua listener
    Future.delayed(Duration(seconds: 1), () {
      print('=> Đang phát tin nhắn test qua Socket...');
      socket.emit('sendMessage', {
        'sender': userId,
        'receiver': userId, // Tự chat với chính mình để test listener
        'text': 'Ping Pong qua WebSocket!'
      });
    });
  });

  socket.on('receiveMessage', (data) {
    print('✅ Có tin nhắn báo về (Realtime): "${data['text']}"');
    
    // Đóng Socket. hoàn thành!
    print('\n==== TOÀN BỘ BÀI TEST THÀNH CÔNG ====');
    socket.disconnect();
    exit(0);
  });

  socket.onConnectError((data) {
    print('❌ Lỗi kết nối Socket: $data');
    exit(1);
  });
}
