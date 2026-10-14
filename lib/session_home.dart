import 'package:flutter/material.dart';

import 'cart_controller.dart';
import 'home_page.dart';

/// Mantém um único carrinho durante a sessão autenticada.
class SessionHome extends StatefulWidget {
  const SessionHome({super.key});

  @override
  State<SessionHome> createState() => _SessionHomeState();
}

class _SessionHomeState extends State<SessionHome> {
  final CartController _cart = CartController();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HomePage(cartController: _cart);
}
