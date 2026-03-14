class Message {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isSender;
  final bool isRead;

  const Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isSender,
    this.isRead = true,
  });
}
