import 'package:flutter/material.dart';
import 'cart_controller.dart';
import 'order_service.dart';

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
  final TextEditingController _observacaoController = TextEditingController();
  bool _salvando = false;

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _confirmarPedido() async {
    if (widget.cartController.carrinhoVazio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seu carrinho está vazio.')),
      );
      return;
    }

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar pedido'),
        content: const Text('Deseja realmente finalizar o pedido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() => _salvando = true);

    try {
      // ── Salva o pedido no Firestore ──────────────────────────────────
      final pedidoId = await OrderService.instance.finalizarPedido(
        itens: widget.cartController.itens,
        observacao: _observacaoController.text.trim(),
      );

      if (!mounted) return;

      // Limpa o carrinho apenas após sucesso
      widget.cartController.limparCarrinho();

      // Exibe confirmação com o número do pedido
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('🎉 Pedido realizado!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seu pedido foi enviado com sucesso.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Número do pedido:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pedidoId,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // fecha dialog
                Navigator.pop(context); // volta ao carrinho
                Navigator.pop(context); // volta ao início
              },
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      );
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao finalizar pedido: $e')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            : Column(
                children: [
                  // ── Lista de itens ─────────────────────────────────
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ...itens.map((item) => Card(
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.receipt_long_outlined),
                                ),
                                title: Text(
                                  item.produto.nome,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text('Quantidade: ${item.quantidade}'),
                                trailing: Text(
                                  'R\$ ${item.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),

                        // ── Campo de observação ──────────────────────
                        const SizedBox(height: 8),
                        TextField(
                          controller: _observacaoController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Observações (opcional)',
                            hintText:
                                'Ex: sem cebola, alergia a amendoim...',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.notes_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // ── Rodapé com total e botão ───────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border:
                          const Border(top: BorderSide(color: Colors.black12)),
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
                            onPressed: _salvando ? null : _confirmarPedido,
                            child: _salvando
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Confirmar pedido'),
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
