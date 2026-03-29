import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  void _abrirProdutos(BuildContext context, String categoria) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lista de produtos da categoria "$categoria" será conectada em seguida.'),
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
                'Explore os produtos disponíveis no cardápio digital.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              _buildCategoryCard(
                context,
                icon: Icons.fastfood_rounded,
                titulo: 'Salgados',
                descricao: 'Coxinha, empada, esfiha e outros salgados.',
              ),
              _buildCategoryCard(
                context,
                icon: Icons.cake_rounded,
                titulo: 'Doces',
                descricao: 'Brigadeiro, beijinho, bolo no pote e sobremesas.',
              ),
              _buildCategoryCard(
                context,
                icon: Icons.local_drink_rounded,
                titulo: 'Refrigerantes',
                descricao: 'Refrigerantes em lata, garrafa e combos.',
              ),
              _buildCategoryCard(
                context,
                icon: Icons.emoji_food_beverage_rounded,
                titulo: 'Sucos',
                descricao: 'Sucos naturais e industrializados.',
              ),
              _buildCategoryCard(
                context,
                icon: Icons.lunch_dining_rounded,
                titulo: 'Lanches Naturais',
                descricao: 'Lanches leves e práticos para o dia a dia.',
              ),
              _buildCategoryCard(
                context,
                icon: Icons.shopping_bag_rounded,
                titulo: 'Guloseimas',
                descricao: 'Balas, trident, chocolates e outros itens.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}