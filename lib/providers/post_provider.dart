import 'package:flutter/material.dart';
import '../models/post_item.dart';
import '../services/post_service.dart';

class PostProvider extends ChangeNotifier {
  // --- ESTADO (Variáveis que a tela precisa) ---
  List<PostItem> _posts = [];
  Set<int> _favorites = {};
  int _currentLimit = 10;
  bool _isLoading = false;
  String _errorMessage = '';

  // --- GETTERS (Para proteger as variáveis) ---
  List<PostItem> get posts => _posts;
  Set<int> get favorites => _favorites;
  int get currentLimit => _currentLimit;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // --- AÇÕES (O que o app faz) ---

  // 1. Carregar Posts
  Future<void> loadPosts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // 📢 Avisa a UI: "Mostre o carregando!"

    try {
      _posts = await fetchPostsList(_currentLimit);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // 📢 Avisa a UI: "Terminei, desenhe a lista ou o erro!"
    }
  }

  // 2. Mudar o limite de itens
  void changeLimit(int newLimit) {
    _currentLimit = newLimit;
    loadPosts(); // Recarrega automaticamente
  }

  // 3. Favoritar/Desfavoritar
  void toggleFavorite(int id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners(); // 📢 Avisa a UI: "Atualize as estrelinhas!"
  }
}