import 'package:flutter/material.dart';
import 'cart_controller.dart';
import 'cart_page.dart';
import 'product_list_page.dart';

class CategoriesPage extends StatelessWidget {
  final CartController cartController;

  static const List<({IconData icon, String titulo, String descricao})>
      _categorias = [
    (
      icon: Icons.fastfood_rounded,
      titulo: 'Salgados',
      descricao: 'Coxinha, empada, esfiha e outros salgados.',
    ),
    (
      icon: Icons.cake_rounded,
      titulo: 'Doces',
      descricao: 'Brigadeiro, beijinho, bolo no pote e sobremesas.',
    ),
    (
      icon: Icons.local_drink_rounded,
      titulo: 'Refrigerantes',
      descricao: 'Refrigerantes em lata, garrafa e combos.',
    ),
    (
      icon: Icons.emoji_food_beverage_rounded,
      titulo: 'Sucos',
      descricao: 'Sucos naturais e industrializados.',
    ),
    (
      icon: Icons.lunch_dining_rounded,
      titulo: 'Lanches Naturais',
      descricao: 'Lanches leves e praticos para o dia a dia.',
    ),
    (
      icon: Icons.shopping_bag_rounded,
      titulo: 'Guloseimas',
      descricao: 'Balas, trident, chocolates e outros itens.',
    ),
  ];

  const CategoriesPage({
    super.key,
    required this.cartController,
  });

  void _abrirProdutos(BuildContext context, String categoria) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListPage(
          categoria: categoria,
          cartController: cartController,
        ),
      ),
    );
  }

  void _abrirCarrinho(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cartController: cartController,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required IconData icon,
    required String titulo,
    required String descricao,
  }) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(descricao),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () => _abrirProdutos(context, titulo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        centerTitle: true,
        actions: [
          AnimatedBuilder(
            animation: cartController,
            builder: (context, child) {
              final totalItens = cartController.quantidadeTotalItens;

              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () => _abrirCarrinho(context),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    tooltip: 'Meu carrinho',
                  ),
                  if (totalItens > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$totalItens',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const Icon(
                Icons.grid_view_rounded,
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                'Escolha uma categoria',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore os produtos disponiveis no cardapio digital.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              ..._categorias.map(
                (categoria) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCategoryCard(
                    context,
                    icon: categoria.icon,
                    titulo: categoria.titulo,
                    descricao: categoria.descricao,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
