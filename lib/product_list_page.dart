import 'package:flutter/material.dart';
import 'mock_products.dart';
import 'product_model.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatelessWidget {
  final String categoria;

  const ProductListPage({
    super.key,
    required this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    final List<Product> produtosFiltrados = mockProducts
        .where((produto) => produto.categoria == categoria)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoria),
        centerTitle: true,
      ),
      body: SafeArea(
        child: produtosFiltrados.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum produto encontrado nesta categoria.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: produtosFiltrados.length,
                itemBuilder: (context, index) {
                  final produto = produtosFiltrados[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.fastfood),
                      ),
                      title: Text(
                        produto.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(produto.descricao),
                      trailing: Text(
                        'R\$ ${produto.preco.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(produto: produto),
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