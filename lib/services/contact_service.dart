import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'api_client.dart';

class ContactService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> addFriend(String phone) async {
    try {
      final response = await _apiClient.post('/api/users/friends', {
        'phone': phone,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true, 
          'message': data['message'] ?? 'Thêm bạn thành công',
          'friend_id': data['friend_id']
        };
      } else {
        try {
          final err = jsonDecode(response.body);
          return {'success': false, 'message': err['detail'] ?? 'Lỗi thêm bạn'};
        } catch (_) {
          return {'success': false, 'message': 'Lỗi thêm bạn: ${response.statusCode}'};
        }
      }
    } catch (e) {
      debugPrint('Error adding friend: $e');
      return {'success': false, 'message': 'Lỗi mạng khi kết bạn'};
    }
  }
}
