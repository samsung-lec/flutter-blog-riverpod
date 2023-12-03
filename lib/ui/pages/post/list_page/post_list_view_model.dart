import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dtos/page_dto.dart';
import 'package:flutter_blog/data/dtos/post_request.dart';
import 'package:flutter_blog/data/dtos/response_dto.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/repositories/post_repository.dart';
import 'package:flutter_blog/data/stores/session_store.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// 창고 관리자
final postListProvider = StateNotifierProvider<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(ref, null)..notifyInit(0);
});

// 창고 데이터
class PostListModel {
  PageDTO pageDTO;
  List<Post> posts;
  PostListModel({required this.posts, required this.pageDTO});
}

// 창고
class PostListViewModel extends StateNotifier<PostListModel?> {
  final mContext = navigatorKey.currentContext;
  final Ref ref;
  final refreshCtrl = RefreshController();

  PostListViewModel(this.ref, super.state);

  Future<void> notifyInit(int page) async {
    Logger().d("notifyInit");
    SessionUser sessionUser = ref.read(sessionProvider);
    Logger().d("accessToken : ${sessionUser.accessToken}");
    ResponseDTO responseDTO = await PostRepository().fetchPostList(sessionUser.accessToken, page: page);
    PageDTO pageDTO = responseDTO.response;

    List<Post> allPost = [];
    if (page > 0) {
      allPost = [...state!.posts, ...pageDTO.posts];
      state = PostListModel(posts: allPost, pageDTO: pageDTO);
    } else {
      state = PostListModel(posts: pageDTO.posts, pageDTO: pageDTO);
    }

    refreshCtrl.refreshCompleted();
  }

  Future<void> notifyAdd(PostSaveReqDTO reqDTO) async {
    Logger().d("notifyAdd");

    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO = await PostRepository().savePost(sessionUser.accessToken!, reqDTO);

    if (responseDTO.success) {
      Post newPost = responseDTO.response;

      List<Post> posts = state!.posts;
      PageDTO pageDTO = state!.pageDTO;
      List<Post> newPosts = [newPost, ...posts];

      state = PostListModel(posts: newPosts, pageDTO: pageDTO);
      Navigator.pop(mContext!, Move.postListPage);
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(SnackBar(content: Text("게시물 작성 실패 : ${responseDTO.errorMessage}")));
    }
  }

  Future<void> notifyUpdate(Post post) async {
    List<Post> posts = state!.posts;
    PageDTO pageDTO = state!.pageDTO;
    List<Post> newPosts = posts.map((e) => e.id == post.id ? post : e).toList();

    state = PostListModel(posts: newPosts, pageDTO: pageDTO);
  }

  Future<void> notifyRemove(int id) async {
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO = await PostRepository().fetchDelete(sessionUser.accessToken, id);

    if (responseDTO.success) {
      List<Post> posts = state!.posts;
      PageDTO pageDTO = state!.pageDTO;
      List<Post> newPosts = posts.where((e) => e.id != id).toList();

      state = PostListModel(posts: newPosts, pageDTO: pageDTO);
      Navigator.pop(mContext!);
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(SnackBar(content: Text("게시물 삭제 실패 : ${responseDTO.errorMessage}")));
    }
  }

  Future<void> nextList() async {
    Logger().d("nextList 실행");
    PageDTO pageDTO = state!.pageDTO;

    if (pageDTO.isLast) {
      Logger().d("isLast 실행");
      await Future.delayed(const Duration(milliseconds: 500));
      refreshCtrl.loadComplete();
      return;
    }
    Logger().d("pageDTO.pageNumber + 1 : ${pageDTO.pageNumber + 1}");
    await notifyInit(pageDTO.pageNumber + 1);

    refreshCtrl.loadComplete();
  }
}
