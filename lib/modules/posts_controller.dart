import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/post.dart';
import '../../data/network/api_exception.dart';
import '../data/repositories/PostRepository.dart';

class PostsController extends GetxController {
  PostsController(this._repo);

  final PostRepository _repo;

  // Reactive state: any Obx() reading these rebuilds when they change.
  final posts = <Post>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  /// GET: load the list (also used by pull-to-refresh).
  Future<void> fetchPosts() async {
    isLoading.value = true;
    error.value = null;
    try {
      var postResponse = await _repo.fetchPosts();
      posts.assignAll(postResponse);

      // posts.add(Post(id: 12, title: "Kodex 3", body: "This is a kodex 3 class", userId: 4));
      // posts.addAll([Post(id: 12, title: "Kodex 3", body: "This is a kodex 3 class", userId: 4)]);
      //
    } on ApiException catch (e) {
      error.value = e.message;
      if (posts.isNotEmpty) _showError(e.message); // keep old list, just warn
    } finally {
      isLoading.value = false;
    }
  }

  /// POST: create a post, add it to the top of the list, close the form.
  Future<void> createPost({required String title, required String body}) async {
    isSubmitting.value = true;
    try {
      final created = await _repo.createPost(
        Post(userId: 1, title: title, body: body),
      );
      posts.insert(0, created);
      Get.back();
      Get.snackbar('Created', 'Post "${created.title}" was added.',
          snackPosition: SnackPosition.BOTTOM);
    } on ApiException catch (e) {
      _showError(e.message);
    } finally {
      isSubmitting.value = false;
    }
  }

  /// DELETE: remove right away (optimistic), put it back if the call fails.
  Future<void> deletePost(Post post) async {
    final index = posts.indexOf(post);
    posts.removeAt(index);
    try {
      if (post.id != null) await _repo.deletePost(post.id!);
    } on ApiException catch (e) {
      posts.insert(index, post);
      _showError(e.message);
    }
  }

  void _showError(String message) => Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
}
