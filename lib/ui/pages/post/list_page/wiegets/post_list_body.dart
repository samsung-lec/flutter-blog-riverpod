import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_view_model.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostListBody extends ConsumerWidget {
  PostListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostListModel? model = ref.watch(postListProvider);
    PostListViewModel viewModel = ref.read(postListProvider.notifier);
    List<Post> posts = [];

    if (model != null) {
      posts = model.posts;
    }

    return SmartRefresher(
      onLoading: () async => await viewModel.nextList(),
      onRefresh: () async => await viewModel.notifyInit(0),
      enablePullDown: true,
      enablePullUp: true,
      controller: viewModel.refreshCtrl,
      child: ListView.separated(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PostDetailPage(posts[index].id)), // 코드 추가 (파라메터)
              );
            },
            child: PostListItem(posts[index]),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
