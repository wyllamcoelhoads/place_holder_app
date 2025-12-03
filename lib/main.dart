import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <--- Importante para usar provider
import 'providers/post_provider.dart';   // <--- Arquivo que busca na api
import 'screens/todo_page.dart';

void main() {
  runApp(
    // Injeção de Dependência: Cria a instancia, onde a class de logica nasce
    ChangeNotifierProvider(
      create: (context) => PostProvider(),
      child: const MyApp(),// o filho que enxerga tudo de PostProvider
    ), // nofitica musanças que correram no app
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