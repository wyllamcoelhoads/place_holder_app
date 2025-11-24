// Define a estrutura dos dados (o "molde" da tarefa)
class TodoModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  TodoModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body
  });

  // Converte o JSON que vem da internet para um objeto Dart
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}