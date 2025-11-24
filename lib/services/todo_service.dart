import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/todo_model.dart'; // Importando o modelo que criamos acima

class TodoService {
  
  // Método que vai na internet buscar uma tarefa aleatória
  Future<TodoModel> fetchRandomTodo() async {
    final idAleatorio = Random().nextInt(100) + 1;
    final url = Uri.parse('https://jsonplaceholder.typicode.com/todos/$idAleatorio');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return TodoModel.fromJson(body);
    } else {
      throw Exception('Falha no servidor: ${response.statusCode}');
    }
  }
}