class ChatItemModel {
  final String chatId;
  final String profileImage; // Profile image URL
  final String name; // User name
  final String receiverId; // New property for receiver ID
  final String message; // Last message
  final String time; // Timestamp
  final int unreadMessages; // New property for unread message count

  ChatItemModel({
    required this.chatId,
    required this.profileImage,
    required this.name,
    required this.receiverId,
    required this.message,
    required this.time,
    this.unreadMessages = 0, // Default to 0 if no unread messages
  });
}
