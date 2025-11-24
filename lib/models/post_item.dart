class PostItem {
  final int userId;
  final int id;
  final String title;
  final String body;

  const PostItem({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  // Construtor de fábrica para desserialização
  factory PostItem.fromJson(Map<String, dynamic> json) {
    // Usamos um switch para desserialização, conforme documentação [3]
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
        'body': String body,
      } =>
        PostItem(
          userId: userId,
          id: id,
          title: title,
          body: body,
        ),
      _ => throw const FormatException('Failed to load post.'),
    };
  }
}