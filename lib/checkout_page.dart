import 'package:flutter/material.dart';

import 'cart_controller.dart';
import 'cart_item_model.dart';
import 'order_service.dart';

typedef SubmitOrder =
    Future<String> Function({
      required List<CartItem> itens,
      String? observacao,
    });

class CheckoutPage extends StatefulWidget {
  final CartController cartController;
  final SubmitOrder? submitOrder;

  const CheckoutPage({
    super.key,
    required this.cartController,
    this.submitOrder,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _observacaoController = TextEditingController();
  bool _salvando = false;

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _confirmarPedido() async {
    if (_salvando || widget.cartController.carrinhoVazio) return;
    // O bloqueio começa antes do diálogo para impedir confirmações concorrentes.
    setState(() => _salvando = true);
    try {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Confirmar pedido'),
          content: const Text('Deseja enviar os itens selecionados?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );
      if (confirmar != true || !mounted) return;
      final enviar =
          widget.submitOrder ?? OrderService.instance.finalizarPedido;
      final pedidoId = await enviar(
        itens: widget.cartController.itens,
        observacao: _observacaoController.text.trim(),
      );
      if (!mounted) return;
      // Só remove os itens após a confirmação da gravação pelo serviço.
      widget.cartController.limparCarrinho();
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Pedido enviado'),
          content: Text('Seu pedido foi registrado.\nNúmero: $pedidoId'),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Concluir'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      setState(() => _salvando = false);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      debugPrint('Falha ao registrar pedido: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível enviar o pedido. Seus itens foram mantidos. Tente novamente.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_salvando,
      child: Scaffold(
        appBar: AppBar(title: const Text('Finalizar pedido')),
        body: SafeArea(
          child: ListenableBuilder(
            listenable: widget.cartController,
            builder: (context, _) {
              final itens = widget.cartController.itens;
              if (itens.isEmpty) {
                return const Center(child: Text('Nenhum item para finalizar.'));
              }
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  for (final item in itens)
                    Card(
                      child: ListTile(
                        title: Text(item.produto.nome),
                        subtitle: Text('Quantidade: ${item.quantidade}'),
                        trailing: Text(
                          'R\$ ${item.subtotal.toStringAsFixed(2).replaceAll('.', ',')}',
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _observacaoController,
                    enabled: !_salvando,
                    maxLines: 3,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      labelText: 'Observações (opcional)',
                      hintText: 'Informações adicionais sobre o pedido',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total de itens: ${widget.cartController.quantidadeTotalItens}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: R\$ ${widget.cartController.total.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _salvando ? null : _confirmarPedido,
                    child: _salvando
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : const Text('Confirmar pedido'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
