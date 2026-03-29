import 'package:flutter/material.dart';
import 'cart_controller.dart';
import 'product_model.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  final CartController cartController;

  const CartPage({
    super.key,
    required this.cartController,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _aumentarQuantidade(Product produto) {
    setState(() {
      widget.cartController.aumentarQuantidade(produto);
    });
  }

  void _diminuirQuantidade(Product produto) {
    setState(() {
      widget.cartController.diminuirQuantidade(produto);
    });
  }

  void _removerProduto(Product produto) {
    setState(() {
      widget.cartController.removerProduto(produto);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.nome} removido do carrinho.'),
      ),
    );
  }

  void _finalizarPedido() {
    if (widget.cartController.carrinhoVazio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seu carrinho está vazio.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          cartController: widget.cartController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itens = widget.cartController.itens;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Carrinho'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: widget.cartController.carrinhoVazio
            ? const Center(
                child: Text(
                  'Seu carrinho está vazio.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: itens.length,
                      itemBuilder: (context, index) {
                        final item = itens[index];

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.shopping_bag_outlined),
                                  ),
                                  title: Text(
                                    item.produto.nome,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(item.produto.descricao),
                                  trailing: IconButton(
                                    onPressed: () =>
                                        _removerProduto(item.produto),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => _diminuirQuantidade(
                                            item.produto,
                                          ),
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),
                                        Text(
                                          '${item.quantidade}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _aumentarQuantidade(
                                            item.produto,
                                          ),
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'R\$ ${item.subtotal.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: const Border(
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Total de itens: ${widget.cartController.quantidadeTotalItens}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: R\$ ${widget.cartController.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _finalizarPedido,
                            child: const Text('Finalizar pedido'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}