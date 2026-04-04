import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();

  bool carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _enviarRecuperacao() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe seu e-mail.'),
        ),
      );
      return;
    }

    setState(() {
      carregando = true;
    });

    try {
      await authService.recuperarSenha(email: email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail de recuperação enviado com sucesso.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      final mensagem = authService.tratarErroAuth(e);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao enviar recuperação.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  void _voltarParaLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Icon(
                Icons.lock_reset_rounded,
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                'Esqueceu sua senha?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Digite seu e-mail cadastrado para receber as instruções de recuperação.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Digite seu e-mail cadastrado',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: carregando ? null : _enviarRecuperacao,
                  child: carregando
                      ? const CircularProgressIndicator()
                      : const Text('Enviar'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _voltarParaLogin,
                child: const Text('Voltar para login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}