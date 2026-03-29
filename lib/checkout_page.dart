import 'package:flutter/material.dart';
import 'cart_controller.dart';

class CheckoutPage extends StatefulWidget {
  final CartController cartController;

  const CheckoutPage({
    super.key,
    required this.cartController,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Future<void> _confirmarPedido() async {
    if (widget.cartController.carrinhoVazio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seu carrinho está vazio.'),
        ),
      );
      return;
    }

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar pedido'),
        content: const Text('Deseja realmente finalizar o pedido?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) {
      return;
    }

    widget.cartController.limparCarrinho();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pedido realizado com sucesso!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final itens = widget.cartController.itens;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: widget.cartController.carrinhoVazio
            ? const Center(
                child: Text(
                  'Nenhum item para finalizar.',
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
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.receipt_long_outlined),
                            ),
                            title: Text(
                              item.produto.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Quantidade: ${item.quantidade}',
                            ),
                            trailing: Text(
                              'R\$ ${item.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
                          'Quantidade total de itens: ${widget.cartController.quantidadeTotalItens}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Valor total: R\$ ${widget.cartController.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _confirmarPedido,
                            child: const Text('Confirmar pedido'),
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
