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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 24),
              const Text(
                'SonhoDoce - Cardápio Digital Universitário',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Versão 1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              
              // Seção: Objetivo
              const Text(
                'Objetivo do Aplicativo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'O Doce Campus é um aplicativo multiplataforma que funciona como um cardápio digital universitário. Seu principal objetivo é permitir que os alunos e clientes visualizem os produtos disponíveis no estabelecimento e realizem pedidos de forma rápida, prática e intuitiva.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 32),
              
              // Seção: Equipe
              const Text(
                'Equipe de Desenvolvimento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const ListTile(
                leading: Icon(Icons.person),
                title: Text('[Fernando Mogno Volpini - RA: 840608]'),
                contentPadding: EdgeInsets.zero,
              ),
              
              
              
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              
              // Seção: Instituição
              const Text(
                'Universidade de Ribeirão Preto (UNAERP)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Engenharia da Computação - 2026',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                'Projeto Prático - Desenvolvimento Mobile 20261_AJ322A e Prática Extensionista VIII 20261_HJ422A',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}