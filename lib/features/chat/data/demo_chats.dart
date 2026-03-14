import '../../contacts/data/demo_contacts.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

final List<Conversation> demoConversations = [
  Conversation(
    id: 'conv_1',
    partner: demoContacts[0], // Nguyễn Văn An
    unreadCount: 2,
    messages: [
      Message(
        id: 'msg_1',
        text: 'Chào tuần mới nhé!',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        isSender: false,
      ),
      Message(
        id: 'msg_2',
        text: 'Chào bạn, tuần này có plan gì chưa?',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isSender: true,
      ),
      Message(
        id: 'msg_3',
        text: 'Mình đang check lại các specs hôm qua.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isSender: false,
        isRead: false,
      ),
      Message(
        id: 'msg_4',
        text: 'Chút nữa họp team mình thống nhất nhé.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isSender: false,
        isRead: false,
      ),
    ],
  ),
  Conversation(
    id: 'conv_2',
    partner: demoContacts[1], // Trần Thị Bình
    unreadCount: 0,
    messages: [
      Message(
        id: 'msg_5',
        text: 'Báo cáo tháng trước xong chưa em?',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isSender: false,
      ),
      Message(
        id: 'msg_6',
        text: 'Dạ phần dữ liệu thô e chuẩn bị xong rồi ạ, chiều nay e gửi nha.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isSender: true,
      ),
      Message(
        id: 'msg_7',
        text: 'Ok em.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isSender: false,
      ),
    ],
  ),
  Conversation(
    id: 'conv_3',
    partner: demoContacts[3], // Phạm Thị Diệu Hằng
    unreadCount: 0,
    messages: [
      Message(
        id: 'msg_8',
        text: 'Nhớ gửi lại file design nha Hằng ơi.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isSender: true,
      ),
      Message(
        id: 'msg_9',
        text: 'Đang upload lên Drive, xíu gửi link nha.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isSender: false,
      ),
    ],
  ),
  Conversation(
    id: 'conv_4',
    partner: demoContacts[5], // Đặng Quốc Phong
    unreadCount: 1,
    messages: [
      Message(
        id: 'msg_10',
        text: 'Anh update API cho login màn hình mới rồi.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isSender: false,
        isRead: false,
      ),
    ],
  ),
];
