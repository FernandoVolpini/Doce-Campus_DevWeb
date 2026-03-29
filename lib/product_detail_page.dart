import 'package:flutter/material.dart';
import 'product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product produto;

  const ProductDetailPage({
    super.key,
    required this.produto,
  });

  void _adicionarAoCarrinho(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.nome} adicionado ao carrinho!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.nome),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.fastfood,
                size: 100,
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
              const SizedBox(height: 20),
              Text(
                'Categoria: ${produto.categoria}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'R\$ ${produto.preco.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
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