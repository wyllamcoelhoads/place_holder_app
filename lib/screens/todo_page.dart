import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <--- Importante
import '../models/post_item.dart';
import '../providers/post_provider.dart'; // <--- Conecta com o Provider
import 'post_details_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<int> _limitOptions = [10, 20, 50, 100];

  // Cores do Tema
  final Color _bgColor = const Color(0xFF121212);
  final Color _cardColor = const Color(0xFF1E1E1E);
  final Color _accentColor = const Color(0xFFBB86FC);
  final Color _textColor = const Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    // ⚠️ AQUI: Pedimos ao Provider para carregar os dados assim que a tela abre
    // O listen: false é obrigatório dentro do initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 📡 AQUI: "Escutamos" o Provider. Qualquer notifyListeners() lá reconstrói aqui.
    final provider = Provider.of<PostProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: _cardColor,
          elevation: 50,
          centerTitle: true,
          title: Text(
            'Place Holder',
            style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  dropdownColor: _cardColor,
                  // Lemos o valor direto do Provider
                  value: provider.currentLimit,
                  icon: Icon(Icons.filter_list, color: _accentColor),
                  style: TextStyle(color: _textColor),
                  items: _limitOptions.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value itens'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      // Chamamos a função do Provider
                      provider.changeLimit(val);
                    }
                  },
                ),
              ),
            )
          ],
        ),

        // CORPO: Agora usamos if/else baseados no estado do Provider
        // Não precisamos mais de FutureBuilder!
        body: Builder(
          builder: (context) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator(color: _accentColor));
            }

            if (provider.errorMessage.isNotEmpty) {
              return _buildErrorState(provider);
            }

            // Se chegou aqui, temos dados!
            final allPosts = provider.posts;
            final favoritePosts = allPosts.where((p) => provider.favorites.contains(p.id)).toList();

            return TabBarView(
              children: [
                _buildElegantList(allPosts, provider),
                favoritePosts.isEmpty
                    ? _buildEmptyState()
                    : _buildElegantList(favoritePosts, provider),
              ],
            );
          },
        ),

        bottomNavigationBar: Container(
          color: _cardColor,
          child: SafeArea(
            child: TabBar(
              indicatorColor: _accentColor,
              indicatorWeight: 3,
              labelColor: _accentColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.list), text: 'Todos'),
                Tab(icon: Icon(Icons.star), text: 'Favoritos'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Passamos o provider como argumento para usar as funções dele
  Widget _buildElegantList(List<PostItem> posts, PostProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final isFav = provider.favorites.contains(post.id);

        return Hero(
          tag: 'post_hero_${post.id}',
          child: Card(
            color: _cardColor,
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetalhesPage(post: post),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _accentColor.withOpacity(0.5)),
                          ),
                          child: Text(
                            'ID #${post.id}',
                            style: TextStyle(
                              color: _accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        GestureDetector(
                          // AQUI: Chamamos o método do Provider
                          onTap: () => provider.toggleFavorite(post.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFav ? Colors.amber.withOpacity(0.1) : Colors.transparent,
                            ),
                            child: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.amber : Colors.grey,
                              size: 28,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),

                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.body.replaceAll('\n', ' '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(PostProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 80, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              "Ops! Algo deu errado.",
              style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage.replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              // AQUI: Chamamos o método do Provider
              onPressed: provider.loadPosts,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text("Tentar Novamente"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border, size: 80, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text("Nenhum favorito ainda", style: TextStyle(color: Colors.grey[600], fontSize: 18)),
        ],
      ),
    );
  }
}