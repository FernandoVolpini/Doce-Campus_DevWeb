import 'product_model.dart';

class CartItem {
  final Product produto;
  int quantidade;

  CartItem({
    required this.produto,
    this.quantidade = 1,
  });

  double get subtotal => produto.preco * quantidade;
}