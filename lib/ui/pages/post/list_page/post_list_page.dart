import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_view_model.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_body.dart';
import 'package:flutter_blog/ui/widgets/custom_navigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListPage extends ConsumerWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //PostListModel? model = ref.watch(postListProvider);
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomNavigation(scaffoldKey),
      appBar: AppBar(
        title: const Text("Blog"),
      ),
      body: PostListBody(),
    );
  }
}
