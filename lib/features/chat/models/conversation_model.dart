import '../../contacts/models/contact_model.dart';
import 'message_model.dart';

class Conversation {
  final String id;
  final Contact partner;
  final List<Message> messages;
  final int unreadCount;

  const Conversation({
    required this.id,
    required this.partner,
    required this.messages,
    this.unreadCount = 0,
  });

  Message? get lastMessage => messages.isNotEmpty ? messages.last : null;
}
