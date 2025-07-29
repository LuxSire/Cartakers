import 'package:xm_frontend/data/models/comment_model.dart';

class PostModel {
  final int id;
  String? title;
  final String body;
  DateTime date;
  String time;
  int totalLikes;
  int totalComments;
  final String createdBy;
  final String createdById;
  final String userProfilePic;
  int acceptPrivateChat;
  List<Comment> comments; // Stores a list of comments
  List<String> photoUrls; // Stores multiple photo URLs
  bool areCommentsVisible;
  bool showTranslation;
  String? translatedBody;
  String? translatedTitle;
  int hasLiked;

  PostModel({
    required this.id,
    this.title,
    required this.body,
    required this.date,
    required this.time,
    this.totalLikes = 0,
    this.totalComments = 0,
    required this.hasLiked,
    required this.createdBy,
    required this.userProfilePic,
    required this.acceptPrivateChat,
    this.comments = const [],
    this.photoUrls = const [],
    this.areCommentsVisible = false,
    this.showTranslation = false,
    this.translatedBody,
    this.translatedTitle,
    required this.createdById,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['description'],
      date: DateTime.parse(json['created_at']).toLocal(),
      time: json['created_at'].substring(11, 16), // Extracts time (HH:mm)
      totalLikes: json['total_likes'] ?? 0,
      hasLiked: json['has_liked'] ?? 0,
      totalComments: json['total_comments'] ?? 0,
      createdBy: json['creator_name'],
      userProfilePic: json['user_profile_pic'] ?? '',
      acceptPrivateChat: json['isReceivePrivateMsg'],
      createdById: json['creator_id'].toString(),
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((comment) => Comment.fromJson(comment))
              .toList() ??
          [],
      photoUrls:
          (json['photos'] as List<dynamic>?)
              ?.map((photo) => photo['url'] as String)
              .toList() ??
          [],
    );
  }
}
