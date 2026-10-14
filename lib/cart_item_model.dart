import 'product_model.dart';

class CartItem {
  final Product produto;
  final int quantidade;

  CartItem({required this.produto, this.quantidade = 1}) {
    if (quantidade < 1) {
      throw ArgumentError.value(
        quantidade,
        'quantidade',
        'Deve ser maior que zero.',
      );
    }
  }

  int get subtotalEmCentavos => (produto.preco * 100).round() * quantidade;

  double get subtotal => subtotalEmCentavos / 100;

  @override
  String toString() {
    return 'CartItem(produto: ${produto.nome}, quantidade: $quantidade, subtotal: $subtotal)';
  }
}
