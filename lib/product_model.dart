class Product {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final String categoria;
  final String imagem;

  const Product({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoria,
    required this.imagem,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product(id: $id, nome: $nome, preco: $preco)';
  }
}
