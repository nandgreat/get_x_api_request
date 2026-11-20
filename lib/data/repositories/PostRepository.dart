import '../models/post.dart';
import '../network/api_client.dart';
class PostRepository {
  PostRepository(this._api);

  final ApiClient _api;

  // GET /posts?_limit=20
  Future<List<Post>> fetchPosts() async {
    final data = await _api.get('/posts', query: {'_limit': 20}) as List;
    return data.map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // POST /posts
  Future<Post> createPost(Post post) async {
    final data = await _api.post('/posts', data: post.toJson());
    return Post.fromJson(data as Map<String, dynamic>);
  }

  // DELETE /posts/:id
  Future<void> deletePost(int id) => _api.delete('/posts/$id');
}
