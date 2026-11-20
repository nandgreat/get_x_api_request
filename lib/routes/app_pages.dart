
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/post_form_view.dart';
import '../modules/posts_binding.dart';
import '../modules/posts_view.dart';

abstract class Routes {
  static const posts = '/posts';
  static const newPost = '/posts/new';
}

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.posts,
      page: () => const PostsView(),
      binding: PostsBinding(),
    ),
    GetPage(
      name: Routes.newPost,
      page: () => const PostFormView(),
    ),
  ];
}
