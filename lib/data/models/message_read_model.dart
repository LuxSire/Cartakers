class MessageRead {
  final int tenantId;
  final DateTime readAt;

  MessageRead({required this.tenantId, required this.readAt});

  factory MessageRead.fromJson(Map<String, dynamic> json) {
    return MessageRead(
      tenantId: json['tenant_id'],
      readAt: DateTime.parse(json['read_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'tenant_id': tenantId,
    'read_at': readAt.toIso8601String(),
  };
}
