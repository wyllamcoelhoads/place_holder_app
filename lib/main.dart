import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <--- Importante
import 'providers/post_provider.dart';   // <--- Seu novo arquivo
import 'screens/todo_page.dart';

void main() {
  runApp(
    // Injeção de Dependência: Criamos o Provider aqui no topo
    ChangeNotifierProvider(
      create: (context) => PostProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Place Holder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}