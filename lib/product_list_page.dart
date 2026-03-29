import 'package:flutter/material.dart';
import 'cart_controller.dart';
import 'mock_products.dart';
import 'product_model.dart';
import 'product_detail_page.dart';

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
    final List<Product> produtosFiltrados = mockProducts
        .where((produto) => produto.categoria == categoria)
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    return Scaffold(
      appBar: AppBar(
        title: Text(categoria),
        centerTitle: true,
      ),
      body: SafeArea(
        child: produtosFiltrados.isEmpty
            ? Center(
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
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: produtosFiltrados.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final produto = produtosFiltrados[index];

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 26,
                        child: Icon(_getCategoryIcon()),
                      ),
                      title: Text(
                        produto.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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
                            builder: (context) => ProductDetailPage(
                              produto: produto,
                              cartController: cartController,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
