import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parcial_devmob/cart_controller.dart';
import 'package:parcial_devmob/cart_item_model.dart';
import 'package:parcial_devmob/checkout_page.dart';
import 'package:parcial_devmob/product_model.dart';

const produto = Product(
  id: 'p1',
  nome: 'Coxinha',
  descricao: 'Frango',
  preco: 7.5,
  categoria: 'Salgados',
);

Future<void> abrirConfirmacao(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Confirmar pedido'));
  await tester.tap(find.text('Confirmar pedido'));
  // O indicador de envio mantém uma animação ativa atrás do diálogo.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  expect(find.text('Deseja enviar os itens selecionados?'), findsOneWidget);
}

void main() {
  test('Agrupa pelo ID e mantém uma cópia imutável dos itens anteriores', () {
    final cart = CartController();
    addTearDown(cart.dispose);
    cart.adicionarProduto(produto);
    final snapshot = cart.itens;
    cart.adicionarProduto(produto.copyWith(nome: 'Coxinha atualizada'));
    expect(cart.itens.length, 1);
    expect(cart.quantidadeTotalItens, 2);
    expect(snapshot.single.quantidade, 1);
    expect(() => snapshot.clear(), throwsUnsupportedError);
    cart.diminuirQuantidade(produto);
    cart.diminuirQuantidade(produto);
    expect(cart.carrinhoVazio, isTrue);
  });

  test('Calcula preços em centavos sem acúmulo de erro decimal', () {
    final cart = CartController();
    addTearDown(cart.dispose);
    for (var i = 0; i < 3; i++) {
      cart.adicionarProduto(produto.copyWith(preco: 0.10));
    }
    expect(cart.total, 0.30);
    expect(
      () => CartItem(produto: produto, quantidade: 0),
      throwsArgumentError,
    );
  });

  testWidgets('Cancelamento mantém o carrinho e não envia pedido', (
    tester,
  ) async {
    final cart = CartController()..adicionarProduto(produto);
    addTearDown(cart.dispose);
    var chamadas = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: CheckoutPage(
          cartController: cart,
          submitOrder: ({required itens, observacao}) async {
            chamadas++;
            return 'pedido';
          },
        ),
      ),
    );
    await abrirConfirmacao(tester);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(chamadas, 0);
    expect(cart.quantidadeTotalItens, 1);
  });

  testWidgets(
    'Só limpa o carrinho após a gravação e bloqueia envios concorrentes',
    (tester) async {
      final cart = CartController()..adicionarProduto(produto);
      addTearDown(cart.dispose);
      final resultado = Completer<String>();
      var chamadas = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: CheckoutPage(
            cartController: cart,
            submitOrder: ({required itens, observacao}) {
              chamadas++;
              return resultado.future;
            },
          ),
        ),
      );
      await abrirConfirmacao(tester);
      await tester.tap(find.text('Confirmar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(chamadas, 1);
      expect(cart.quantidadeTotalItens, 1);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      resultado.complete('pedido-123');
      await tester.pumpAndSettle();
      expect(cart.carrinhoVazio, isTrue);
      expect(find.text('Pedido enviado'), findsOneWidget);
      expect(find.textContaining('pedido-123'), findsOneWidget);
    },
  );

  testWidgets('Falha mantém os itens e permite uma nova tentativa', (
    tester,
  ) async {
    final cart = CartController()..adicionarProduto(produto);
    addTearDown(cart.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: CheckoutPage(
          cartController: cart,
          submitOrder: ({required itens, observacao}) async =>
              throw Exception('indisponível'),
        ),
      ),
    );
    await abrirConfirmacao(tester);
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(cart.quantidadeTotalItens, 1);
    expect(find.textContaining('Seus itens foram mantidos'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
    expect(find.text('Pedido enviado'), findsNothing);
  });
}
