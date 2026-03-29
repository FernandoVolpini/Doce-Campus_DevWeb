import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.info_outline,
                size: 90,
              ),
              const SizedBox(height: 20),

              const Text(
                'Doce Campus',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Aplicativo de cardápio digital desenvolvido para facilitar a visualização de produtos e realização de pedidos de forma prática e rápida.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 10),

              const Text(
                'Desenvolvedor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Fernando Mogno Volpini'),

              const SizedBox(height: 16),

              const Text(
                'Curso',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Engenharia da Computação'),

              const SizedBox(height: 16),

              const Text(
                'Instituição',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('UNAERP'),

              const SizedBox(height: 16),

              const Text(
                'Disciplina',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Desenvolvimento Mobile'),

              const SizedBox(height: 16),

              const Text(
                'Professor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Seu Professor Aqui'),

              const Spacer(),

              const Divider(),

              const SizedBox(height: 10),

              const Text(
                'Versão 1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}