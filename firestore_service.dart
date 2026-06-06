import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'order_service.dart';

/// Exibe o histórico de pedidos do usuário logado,
/// atualizado em tempo real via Firestore Stream.
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: OrderService.instance.meusPedidos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar pedidos:\n${snapshot.error}'),
              );
            }

            final pedidos = snapshot.data ?? [];

            if (pedidos.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        size: 72, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum pedido realizado ainda.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                final itens =
                    (pedido['itens'] as List<dynamic>?) ?? [];
                final status = pedido['status'] as String? ?? 'pendente';
                final total =
                    (pedido['total'] as num?)?.toStringAsFixed(2) ?? '0.00';
                final criadoEm = pedido['criadoEm'] as Timestamp?;
                final data = criadoEm != null
                    ? _formatarData(criadoEm.toDate())
                    : '—';

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.receipt_outlined),
                    ),
                    title: Text(
                      'Pedido de $data',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(OrderService.labelStatus(status)),
                    trailing: Text(
                      'R\$ $total',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    children: [
                      const Divider(height: 1),
                      ...itens.map((item) {
                        final nome = item['nome'] as String? ?? '';
                        final qtd = item['quantidade'] as int? ?? 1;
                        final sub =
                            (item['subtotal'] as num?)?.toStringAsFixed(2) ??
                                '0.00';
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.circle, size: 8),
                          title: Text(nome),
                          subtitle: Text('Qtd: $qtd'),
                          trailing: Text('R\$ $sub'),
                        );
                      }),
                      if ((pedido['observacao'] as String?)?.isNotEmpty ==
                          true)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Row(
                            children: [
                              const Icon(Icons.notes, size: 16,
                                  color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  pedido['observacao'] as String,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatarData(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}
