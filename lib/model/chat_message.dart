enum ChatMessageType { sender, bot }

class ChatMessage {
  final String message;
  final ChatMessageType chatMessageType;

  ChatMessage({required this.message, required this.chatMessageType});
}
