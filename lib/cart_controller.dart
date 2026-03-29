import 'package:flutter/material.dart';
import 'cart_item_model.dart';
import 'product_model.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _itens = [];

  List<CartItem> get itens => List.unmodifiable(_itens);

  int _indexDoProduto(Product produto) {
    return _itens.indexWhere(
      (item) => item.produto.id == produto.id,
    );
  }

  void adicionarProduto(Product produto) {
    final index = _indexDoProduto(produto);

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
    final quantidadeAnterior = _itens.length;

    _itens.removeWhere(
      (item) => item.produto.id == produto.id,
    );

    if (_itens.length != quantidadeAnterior) {
      notifyListeners();
    }
  }

  void aumentarQuantidade(Product produto) {
    final index = _indexDoProduto(produto);

    if (index >= 0) {
      _itens[index].quantidade++;
      notifyListeners();
    }
  }

  void diminuirQuantidade(Product produto) {
    final index = _indexDoProduto(produto);

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
    if (_itens.isEmpty) {
      return;
    }

    _itens.clear();
    notifyListeners();
  }

  double get total => _itens.fold(0, (soma, item) => soma + item.subtotal);

  int get quantidadeTotalItens =>
      _itens.fold(0, (totalItens, item) => totalItens + item.quantidade);

  bool get carrinhoVazio => _itens.isEmpty;
}
