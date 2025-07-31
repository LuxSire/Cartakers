import 'package:xm_frontend/data/models/message_read_model.dart';
import 'package:xm_frontend/data/models/message_recipient_model.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class MessageModel {
  final String id;
  final String? title;
  final String? content;
  final int? senderUserId;
  final int? companyId;
  final DateTime? createdAt;
  final DateTime? scheduledAt;
  final List<MessageRecipient> recipients;
  final List<MessageRead> reads;
  final List<String> channels;
  final int? statusId;
  final String? statusName;
  final List<int> objectIds; // new (list of ids)

  MessageModel({
    required this.id,
    this.title,
    this.content,
    this.senderUserId,
    this.companyId,
    this.createdAt,
    this.scheduledAt,
    this.recipients = const [],
    this.reads = const [],
    this.channels = const [],
    this.statusId,
    this.statusName,
    this.objectIds = const [],
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] != null ? json['id'].toString() : '',
      title: json['title'] ?? '',
      content: json['body'] ?? '',
      senderUserId: json['created_by'] ?? 0,
      companyId: json['company_id'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at']).toLocal()
              : DateTime.now(),
      scheduledAt:
          json['scheduled_at'] != null
              ? DateTime.parse(json['scheduled_at']).toLocal()
              // If scheduled_at is null or invalid, default to null
              : null,

      recipients:
          (json['recipients'] as List<dynamic>?)
              ?.map((r) => MessageRecipient.fromJson(r))
              .toList() ??
          [],
      reads:
          (json['reads'] as List<dynamic>?)
              ?.map((r) => MessageRead.fromJson(r))
              .toList() ??
          [],

      channels:
          json['channels'] != null ? List<String>.from(json['channels']) : [],
      statusId: json['status_id'],
      statusName: json['status_name'],
      objectIds:
          json['object_ids'] != null
              ? (json['object_ids'] as List)
                  .map((id) => int.tryParse(id.toString()) ?? 0)
                  .where((id) => id != 0)
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': content,
    'created_by': senderUserId,
    'company_id': companyId,
    'created_at': createdAt!.toIso8601String(),
    'scheduled_at': scheduledAt?.toIso8601String(),
    'recipients': recipients.map((r) => r.toJson()).toList(),
    'reads': reads.map((r) => r.toJson()).toList(),
    'channels': channels,
    'object_ids': objectIds,
    'status_id': statusId,
    'status_name': statusName,
  };

  String get formattedDate => TFormatter.formatDate(createdAt);

  bool get isEmpty => id == null || id!.isEmpty;

  /// Static function to create an empty request model.
  static MessageModel empty() => MessageModel(id: '');
}
