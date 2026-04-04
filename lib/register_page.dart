import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'auth_service.dart';
import 'cart_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  final AuthService authService = AuthService();
  final CartController cartController = CartController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool carregando = false;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final telefone = telefoneController.text.trim();
    final senha = senhaController.text.trim();
    final confirmarSenha = confirmarSenhaController.text.trim();

    if (nome.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos.'),
        ),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um e-mail válido.'),
        ),
      );
      return;
    }

    if (senha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem.'),
        ),
      );
      return;
    }

    setState(() {
      carregando = true;
    });

    try {
      await authService.cadastrar(
        email: email,
        senha: senha,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            cartController: cartController,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('ERRO CADASTRO FIREBASE: ${e.code} | ${e.message}');
      }

      final mensagem = authService.tratarErroAuth(e);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERRO GERAL CADASTRO: $e');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao criar conta.'),
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
        title: const Text('Criar conta'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.person_add_alt_1_rounded,
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                'Cadastre-se no SonhoDoce',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crie sua conta para acessar o cardápio digital',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  hintText: 'Digite seu nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Digite seu e-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'Digite seu telefone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: senhaController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Crie uma senha',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmarSenhaController,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  hintText: 'Repita sua senha',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: carregando ? null : _cadastrar,
                  child: carregando
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Cadastrar'),
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