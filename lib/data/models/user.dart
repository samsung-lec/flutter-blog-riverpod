import 'package:intl/intl.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String imgUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.imgUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // 응답 받은 데이터를 json 처럼 생긴 Map => Dart 오브젝트로 변환하는 함수
  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"] ?? "",
        email = json["email"] ?? "",
        imgUrl = json["imgUrl"] ?? "",
        createdAt = json["created"] != null ? DateFormat("yyyy-mm-dd").parse(json["createdAt"]) : null,
        updatedAt = json["created"] != null ? DateFormat("yyyy-mm-dd").parse(json["updatedAt"]) : null;
}
