import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'posts_controller.dart';

class PostsView extends GetView<PostsController> {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.newPost),
        icon: const Icon(Icons.add),
        label: const Text('New post'),
      ),
      body: Obx(() {
        // 1. First load
        if (controller.isLoading.value && controller.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Failed with nothing to show
        if (controller.error.value != null && controller.posts.isEmpty) {
          return _ErrorState(
            message: controller.error.value!,
            onRetry: controller.fetchPosts,
          );
        }

        // 3. Data (pull down to refresh, swipe left to delete)
        return RefreshIndicator(
          onRefresh: controller.fetchPosts,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: controller.posts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final post = controller.posts[i];
              return Dismissible(
                key: ObjectKey(post),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => controller.deletePost(post),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${post.id ?? '-'}')),
                  title: Text(
                    post.title,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
