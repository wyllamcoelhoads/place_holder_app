import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Necessário para compute()
import 'package:http/http.dart' as http;
import '../models/post_item.dart'; // Importa seu modelo

// 1. Função de parsing de lista em segundo plano (Isolate)
// Esta função converte a string de resposta HTTP em List<PostItem>.
List<PostItem> parsePosts(String responseBody) {
  // 1. Decodifica o corpo da resposta em uma lista de Mapas [9]
  final parsed = (jsonDecode(responseBody) as List<Object?>)
      .cast<Map<String, Object?>>(); 
      
  // 2. Mapeia cada Map JSON para um objeto PostItem
  return parsed.map<PostItem>(PostItem.fromJson).toList(); 
}

// 2. Função de busca com limite
Future<List<PostItem>> fetchPostsList(int limit) async {
  // Faz a requisição usando http.get() [10]
  final response = await http.get(
    // Adiciona o parâmetro de query '_limit' para controlar a quantidade de registros
    Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=$limit'),
  );

  if (response.statusCode == 200) { // O código 200 OK indica sucesso [11]
    // Move o parsing (tarefa cara) para um Isolate de segundo plano [5]
    return compute(parsePosts, response.body); 
  } else {
    // Se não for 200 OK, lançamos uma exceção (importante para o FutureBuilder) [12]
    throw Exception('Falha ao carregar a lista de Posts. Status: ${response.statusCode}'); 
  }
}