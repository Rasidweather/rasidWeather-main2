enum ChatMessageType {
  sent,
  received,
}

class Chat {
  Chat({required this.message, required this.type, required this.time});

  factory Chat.sent({required String message}) => Chat(message: message, type: ChatMessageType.sent, time: DateTime.now());
  final String message;
  final ChatMessageType type;
  final DateTime time;
}
