class Post {
  const Post({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  final int? id;
  final int userId;
  final String title;
  final String body;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: (json['id'] as num?)?.toInt(),
        userId: (json['userId'] as num?)?.toInt() ?? 1,
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'userId': userId,
        'title': title,
        'body': body,
      };
}
