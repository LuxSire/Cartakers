class MessageRecipient {
  final int id;
  final int messageId;
  final String recipientType;
  final int recipientId;
  final String? recipientLabel;

  MessageRecipient({
    required this.id,
    required this.messageId,
    required this.recipientType,
    required this.recipientId,
    this.recipientLabel,
  });

  factory MessageRecipient.fromJson(Map<String, dynamic> json) {
    return MessageRecipient(
      id: json['id'],
      messageId: json['message_id'],
      recipientType: json['recipient_type'],
      recipientId: json['recipient_id'],
      recipientLabel: json['recipient_label'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'message_id': messageId,
    'recipient_type': recipientType,
    'recipient_id': recipientId,
    'recipient_label': recipientLabel,
  };
}
