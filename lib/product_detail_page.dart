import 'package:flutter/material.dart';
import 'cart_controller.dart';
import 'product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product produto;
  final CartController cartController;

  const ProductDetailPage({
    super.key,
    required this.produto,
    required this.cartController,
  });

  void _adicionarAoCarrinho(BuildContext context) {
    cartController.adicionarProduto(produto);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.nome} adicionado ao carrinho!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (produto.categoria) {
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
        title: Text(produto.nome),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Icon(
                _getCategoryIcon(),
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                produto.nome,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                produto.descricao,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Categoria: ${produto.categoria}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'R\$ ${produto.preco.toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => _adicionarAoCarrinho(context),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Adicionar ao carrinho'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
