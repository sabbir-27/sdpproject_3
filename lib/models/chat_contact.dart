class ChatContact {
  final String name;
  final String lastMessage;
  final DateTime timestamp;
  final String imageUrl;
  final bool isRead;

  ChatContact({
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.imageUrl,
    this.isRead = true,
  });
}
