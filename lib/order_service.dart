import 'package:firebase_auth/firebase_auth.dart';

import 'cart_item_model.dart';
import 'firestore_service.dart';

/// Contém a lógica de negócio para criação e gerenciamento de pedidos.
class OrderService {
  OrderService._();
  static final OrderService instance = OrderService._();

  final FirestoreService _firestore = FirestoreService.instance;

  // ════════════════════════════════════════════════════════════════════════
  // CRIAR PEDIDO
  // ════════════════════════════════════════════════════════════════════════

  /// Converte os itens do carrinho em um pedido e salva no Firestore.
  /// Retorna o ID do pedido criado.
  ///
  /// Lança [Exception] se o carrinho estiver vazio ou o usuário não estiver
  /// autenticado.
  Future<String> finalizarPedido({
    required List<CartItem> itens,
    String? observacao,
  }) async {
    if (itens.isEmpty) {
      throw Exception('Carrinho vazio. Adicione produtos antes de finalizar.');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }

    if (itens.any(
      (item) =>
          item.quantidade < 1 ||
          !item.produto.preco.isFinite ||
          item.produto.preco <= 0,
    )) {
      throw ArgumentError('O pedido contém quantidade ou preço inválido.');
    }
    if ((observacao?.length ?? 0) > 500) {
      throw ArgumentError('A observação deve ter até 500 caracteres.');
    }

    // Serializa uma seleção imutável do carrinho.
    final itensSerialized = itens
        .map(
          (item) => {
            'produtoId': item.produto.id,
            'nome': item.produto.nome,
            'categoria': item.produto.categoria,
            'preco': item.produto.preco,
            'quantidade': item.quantidade,
            'subtotal': item.subtotal,
          },
        )
        .toList();

    final totalPedido =
        itens.fold<int>(0, (soma, item) => soma + item.subtotalEmCentavos) /
        100;

    final pedido = {
      'uid': user.uid,
      'email': user.email ?? '',
      'itens': itensSerialized,
      'total': totalPedido,
      'quantidadeTotal': itens.fold<int>(0, (s, i) => s + i.quantidade),
      if (observacao != null && observacao.isNotEmpty) 'observacao': observacao,
    };

    return await _firestore.salvarPedido(pedido);
  }

  // ════════════════════════════════════════════════════════════════════════
  // HISTÓRICO
  // ════════════════════════════════════════════════════════════════════════

  /// Stream dos pedidos do usuário logado.
  Stream<List<Map<String, dynamic>>> meusPedidos() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);
    return _firestore.pedidosDoUsuario(uid);
  }

  // ════════════════════════════════════════════════════════════════════════
  // FORMATAÇÃO / UTILITÁRIOS
  // ════════════════════════════════════════════════════════════════════════

  /// Rótulo legível para o status do pedido.
  static String labelStatus(String status) {
    switch (status) {
      case 'pendente':
        return '⏳ Pendente';
      case 'preparando':
        return '👨‍🍳 Preparando';
      case 'pronto':
        return '✅ Pronto para retirada';
      case 'entregue':
        return '🎉 Entregue';
      case 'cancelado':
        return '❌ Cancelado';
      default:
        return status;
    }
  }
}
