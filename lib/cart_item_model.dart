import 'product_model.dart';

class CartItem {
  final Product produto;
  int quantidade;

  CartItem({
    required this.produto,
    this.quantidade = 1,
  }) : assert(quantidade > 0, 'A quantidade deve ser maior que zero.');

  double get subtotal => produto.preco * quantidade;

  @override
  String toString() {
    return 'CartItem(produto: ${produto.nome}, quantidade: $quantidade, subtotal: $subtotal)';
  }
}
