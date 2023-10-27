import 'package:flutter/material.dart';
import 'package:flutter_blog/data/dtos/post_request.dart';
import 'package:flutter_blog/data/dtos/response_dto.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/repositories/post_repository.dart';
import 'package:flutter_blog/data/stores/session_store.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// 창고 관리자
final postDetailProvider = StateNotifierProvider.family
    .autoDispose<PostDetailViewModel, PostDetailModel?, int>((ref, postId) {
  Logger().d("post 창고 만들어짐 $postId");
  return PostDetailViewModel(ref, null)..notifyInit(postId);
});

// 창고 데이터
class PostDetailModel {
  Post post;
  PostDetailModel({required this.post});
}

// 창고
class PostDetailViewModel extends StateNotifier<PostDetailModel?> {
  final mContext = navigatorKey.currentContext;
  final Ref ref;

  PostDetailViewModel(this.ref, super.state);

  Future<void> notifyInit(int id) async {
    Logger().d("notifyInit");

    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPost(sessionUser.jwt!, id);

    state = PostDetailModel(post: responseDTO.data);
  }

  Future<void> notifyUpdate(int postId, PostUpdateReqDTO reqDTO) async {
    Logger().d("notifyUpdate");

    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().updatePost(sessionUser.jwt!, postId, reqDTO);
    if (responseDTO.code != 1) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("게시물 수정 실패 : ${responseDTO.msg}")));
    } else {
      await ref.read(postListProvider.notifier).notifyUpdate(responseDTO.data);

      state = PostDetailModel(post: responseDTO.data);
      Navigator.pop(mContext!);
    }
  }
}
