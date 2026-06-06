import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final String categoria;
  final String imagem;
  final bool disponivel;
  final int ordem;

  const Product({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoria,
    this.imagem = '',
    this.disponivel = true,
    this.ordem = 0,
  });

  // ── Firestore → Product ──────────────────────────────────────────────────
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      descricao: data['descricao'] as String? ?? '',
      preco: (data['preco'] as num?)?.toDouble() ?? 0.0,
      categoria: data['categoria'] as String? ?? '',
      imagem: data['imagem'] as String? ?? '',
      disponivel: data['disponivel'] as bool? ?? true,
      ordem: data['ordem'] as int? ?? 0,
    );
  }

  // ── Product → Firestore ──────────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'categoria': categoria,
      'imagem': imagem,
      'disponivel': disponivel,
      'ordem': ordem,
    };
  }

  // ── Cópia com campos alterados ───────────────────────────────────────────
  Product copyWith({
    String? id,
    String? nome,
    String? descricao,
    double? preco,
    String? categoria,
    String? imagem,
    bool? disponivel,
    int? ordem,
  }) {
    return Product(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      categoria: categoria ?? this.categoria,
      imagem: imagem ?? this.imagem,
      disponivel: disponivel ?? this.disponivel,
      ordem: ordem ?? this.ordem,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Product(id: $id, nome: $nome, preco: $preco)';
}
