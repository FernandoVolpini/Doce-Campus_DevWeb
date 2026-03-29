import 'package:flutter/material.dart';
import 'about_page.dart';
import 'cart_page.dart';
import 'categories_page.dart';
import 'cart_controller.dart';

class HomePage extends StatelessWidget {
  final CartController cartController;

  const HomePage({
    super.key,
    required this.cartController,
  });

  void _abrirCategorias(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoriesPage(),
      ),
    );
  }

  void _abrirCarrinho(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cartController: cartController,
        ),
      ),
    );
  }

  void _abrirSobre(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doce Campus'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Icon(
                Icons.storefront_rounded,
                size: 90,
              ),
              const SizedBox(height: 16),
              const Text(
                'Bem-vindo ao cardápio digital',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visualize categorias, conheça os produtos e monte seu pedido com praticidade.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.cake_rounded,
                        size: 50,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Doces, salgados, bebidas e muito mais.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => _abrirCategorias(context),
                  icon: const Icon(Icons.grid_view_rounded),
                  label: const Text('Ver categorias'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => _abrirCarrinho(context),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Meu carrinho'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () => _abrirSobre(context),
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Sobre o aplicativo'),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Destaques',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.local_pizza_outlined),
                  title: const Text('Salgados variados'),
                  subtitle: const Text('Coxinha, esfiha, empada e muito mais'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () => _abrirCategorias(context),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.icecream_outlined),
                  title: const Text('Doces especiais'),
                  subtitle: const Text('Brigadeiro, bolo no pote e sobremesas'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () => _abrirCategorias(context),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.local_drink_outlined),
                  title: const Text('Bebidas geladas'),
                  subtitle: const Text('Refrigerantes, sucos e água'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () => _abrirCategorias(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}