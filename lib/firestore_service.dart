import 'package:cloud_firestore/cloud_firestore.dart';

import 'product_model.dart';

/// Serviço central de acesso ao Firestore.
///
/// Coleções:
///   produtos/   – catálogo do cardápio
///   pedidos/    – pedidos realizados pelos clientes
///   usuarios/   – perfil extra dos usuários (nome, telefone)
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Referências ──────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _produtos =>
      _db.collection('produtos');

  CollectionReference<Map<String, dynamic>> get _pedidos =>
      _db.collection('pedidos');

  CollectionReference<Map<String, dynamic>> get _usuarios =>
      _db.collection('usuarios');

  // ════════════════════════════════════════════════════════════════════════
  // PRODUTOS
  // ════════════════════════════════════════════════════════════════════════

  /// Stream em tempo real de todos os produtos disponíveis,
  /// filtrados por [categoria] quando informada.
  Stream<List<Product>> produtosPorCategoria(String categoria) {
    return _produtos
        .where('disponivel', isEqualTo: true)
        .where('categoria', isEqualTo: categoria)
        .orderBy('ordem')
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Product.fromFirestore(doc)).toList(),
        );
  }

  /// Stream de TODOS os produtos (para painel admin).
  Stream<List<Product>> todosProdutos() {
    return _produtos
        .orderBy('categoria')
        .orderBy('ordem')
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Product.fromFirestore(doc)).toList(),
        );
  }

  /// Busca um único produto pelo ID.
  Future<Product?> buscarProduto(String id) async {
    final doc = await _produtos.doc(id).get();
    if (!doc.exists) return null;
    return Product.fromFirestore(doc);
  }

  /// Adiciona um novo produto e retorna o ID gerado.
  Future<String> adicionarProduto(Product produto) async {
    final ref = await _produtos.add(produto.toMap());
    return ref.id;
  }

  /// Atualiza um produto existente (merge parcial).
  Future<void> atualizarProduto(String id, Map<String, dynamic> dados) async {
    await _produtos.doc(id).update(dados);
  }

  /// Marca o produto como indisponível (soft delete).
  Future<void> desativarProduto(String id) async {
    await _produtos.doc(id).update({'disponivel': false});
  }

  /// Remove permanentemente um produto (uso apenas admin).
  Future<void> excluirProduto(String id) async {
    await _produtos.doc(id).delete();
  }

  // ════════════════════════════════════════════════════════════════════════
  // PEDIDOS
  // ════════════════════════════════════════════════════════════════════════

  /// Salva um pedido no Firestore e retorna o ID gerado.
  Future<String> salvarPedido(Map<String, dynamic> pedido) async {
    final ref = await _pedidos.add({
      ...pedido,
      'criadoEm': FieldValue.serverTimestamp(),
      'status': 'pendente',
    });
    return ref.id;
  }

  /// Stream de pedidos de um usuário específico, ordenados por data.
  Stream<List<Map<String, dynamic>>> pedidosDoUsuario(String uid) {
    return _pedidos
        .where('uid', isEqualTo: uid)
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(),
        );
  }

  /// Stream de todos os pedidos (painel admin).
  Stream<List<Map<String, dynamic>>> todosPedidos() {
    return _pedidos
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(),
        );
  }

  /// Atualiza o status de um pedido.
  /// Status possíveis: pendente | preparando | pronto | entregue | cancelado
  Future<void> atualizarStatusPedido(String id, String novoStatus) async {
    await _pedidos.doc(id).update({'status': novoStatus});
  }

  // ════════════════════════════════════════════════════════════════════════
  // USUÁRIOS
  // ════════════════════════════════════════════════════════════════════════

  /// Salva perfil extra do usuário (nome, telefone) no cadastro.
  Future<void> salvarPerfil({
    required String uid,
    required String nome,
    required String email,
    required String telefone,
  }) async {
    await _usuarios.doc(uid).set({
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'criadoEm': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Recupera o perfil de um usuário.
  Future<Map<String, dynamic>?> buscarPerfil(String uid) async {
    final doc = await _usuarios.doc(uid).get();
    if (!doc.exists) return null;
    return doc.data();
  }
}
