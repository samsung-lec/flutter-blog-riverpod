import 'package:flutter_blog/data/models/post.dart';

class PageDTO {
  bool isFirst;
  bool isLast;
  int pageNumber;
  int size;
  int totalPage;
  List<Post> posts;

  PageDTO.fromJson(Map<String, dynamic> json)
      : isFirst = json["isFirst"],
        isLast = json["isLast"],
        pageNumber = json["pageNumber"],
        size = json["size"],
        totalPage = json["totalPage"],
        posts = List<Post>.from((json["posts"] ?? []).map((post) => Post.fromJson(post)));
}
