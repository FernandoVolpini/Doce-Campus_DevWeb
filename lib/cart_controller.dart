import 'package:flutter/material.dart';
import 'cart_item_model.dart';
import 'product_model.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _itens = [];

  List<CartItem> get itens => _itens;

  void adicionarProduto(Product produto) {
    final index = _itens.indexWhere(
      (item) => item.produto.id == produto.id,
    );

    if (index >= 0) {
      _itens[index].quantidade++;
    } else {
      _itens.add(
        CartItem(
          produto: produto,
          quantidade: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removerProduto(Product produto) {
    _itens.removeWhere(
      (item) => item.produto.id == produto.id,
    );
    notifyListeners();
  }

  void aumentarQuantidade(Product produto) {
    final index = _itens.indexWhere(
      (item) => item.produto.id == produto.id,
    );

    if (index >= 0) {
      _itens[index].quantidade++;
      notifyListeners();
    }
  }

  void diminuirQuantidade(Product produto) {
    final index = _itens.indexWhere(
      (item) => item.produto.id == produto.id,
    );

    if (index >= 0) {
      if (_itens[index].quantidade > 1) {
        _itens[index].quantidade--;
      } else {
        _itens.removeAt(index);
      }
      notifyListeners();
    }
  }

  void limparCarrinho() {
    _itens.clear();
    notifyListeners();
  }

  double get total {
    double soma = 0;

    for (final item in _itens) {
      soma += item.subtotal;
    }

    return soma;
  }

  int get quantidadeTotalItens {
    int totalItens = 0;

    for (final item in _itens) {
      totalItens += item.quantidade;
    }

    return totalItens;
  }

  bool get carrinhoVazio => _itens.isEmpty;
}