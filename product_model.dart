import 'package:flutter/material.dart';
import 'cart_controller.dart';
import 'firestore_service.dart';
import 'product_model.dart';
import 'product_detail_page.dart';

/// Lista de produtos de uma categoria, carregados em tempo real do Firestore.
/// Substitui a versão anterior que usava [mockProducts].
class ProductListPage extends StatelessWidget {
  final String categoria;
  final CartController cartController;

  const ProductListPage({
    super.key,
    required this.categoria,
    required this.cartController,
  });

  IconData _getCategoryIcon() {
    switch (categoria) {
      case 'Doces':
        return Icons.cake_rounded;
      case 'Refrigerantes':
      case 'Sucos':
        return Icons.local_drink_rounded;
      case 'Lanches Naturais':
        return Icons.lunch_dining_rounded;
      case 'Guloseimas':
        return Icons.icecream_rounded;
      case 'Salgados':
      default:
        return Icons.fastfood_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoria),
        centerTitle: true,
      ),
      body: SafeArea(
        // ── StreamBuilder lê o Firestore em tempo real ───────────────────
        child: StreamBuilder<List<Product>>(
          stream: FirestoreService.instance.produtosPorCategoria(categoria),
          builder: (context, snapshot) {
            // Estado de carregamento
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Erro de conexão / permissão
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Erro ao carregar produtos.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            }

            final produtos = snapshot.data ?? [];

            // Lista vazia
            if (produtos.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getCategoryIcon(),
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhum produto encontrado nesta categoria.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Lista de produtos
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: produtos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final produto = produtos[index];

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 26,
                      // Usa imagem de rede se disponível; caso contrário,
                      // usa ícone da categoria
                      backgroundImage: produto.imagem.isNotEmpty
                          ? NetworkImage(produto.imagem)
                          : null,
                      child: produto.imagem.isEmpty
                          ? Icon(_getCategoryIcon())
                          : null,
                    ),
                    title: Text(
                      produto.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        produto.descricao,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'R\$ ${produto.preco.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(
                            produto: produto,
                            cartController: cartController,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
