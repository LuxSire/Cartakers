import 'package:flutter/rendering.dart';

class Comment {
  final int id;
  final int commenterId; // ID of the person who commented
  final String commenterName; // Name of the person who commented
  final String commenterProfilePic; // Profile picture of the commenter
  final String content; // Comment text
  String? translatedContent; // Translated comment text
  final DateTime dateTime; // Date and time of the comment
  bool showTranslation;

  Comment({
    required this.id,
    required this.commenterId,
    required this.commenterName,
    required this.commenterProfilePic,
    required this.content,
    this.translatedContent,
    required this.dateTime,
    this.showTranslation = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    // debugPrint("🔹 Raw created_at from API: ${json['comment_created_at']}");

    DateTime parsedDateTime = DateTime.parse(json['comment_created_at']);

    //  If timestamp has 'Z', it's UTC → Convert to Local
    bool isUtc =
        json['comment_created_at'].endsWith('Z') || parsedDateTime.isUtc;
    DateTime finalDateTime = isUtc
        ? parsedDateTime
        : parsedDateTime
            .toLocal(); //  Don't apply toLocal() if it's already local

    //debugPrint("🔹 Parsed DateTime (Swiss assumed): $parsedDateTime");
    // debugPrint("🔹 Final DateTime (Corrected Swiss Time): $finalDateTime");

    return Comment(
      id: json['comment_id'],
      commenterId: json['comment_creator_id'],
      commenterName: json['commenter_name'],
      commenterProfilePic: json['commenter_profile_pic'] ?? '',
      content: json['comment_content'],
      dateTime: finalDateTime, //  Corrected conversion
    );
  }
}
