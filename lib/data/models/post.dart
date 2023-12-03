import 'package:flutter_blog/data/models/user.dart';
import 'package:intl/intl.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final User user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? bookmarkCount;
  final bool? isBookmark;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.user,
    required this.bookmarkCount,
    required this.isBookmark,
    required this.createdAt,
    required this.updatedAt,
  });

  // 통신을 위해서 json 처럼 생긴 문자열 {"id":1} => Dart 오브젝트
  Post.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"] ?? "",
        content = json["content"] ?? "",
        user = User.fromJson(json["user"]),
        bookmarkCount = json["bookmarkCount"] ?? 0,
        isBookmark = json["isBookmark"] ?? false,
        createdAt = json["createdAt"] != null ? DateFormat("yyyy-mm-dd").parse(json["createdAt"]) : null,
        updatedAt = json["updatedAt"] != null ? DateFormat("yyyy-mm-dd").parse(json["updatedAt"]) : null;
}
