import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get usuarioAtual => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> entrar({
    required String email,
    required String senha,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha.trim(),
    );
  }

  Future<UserCredential> cadastrar({
    required String email,
    required String senha,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha.trim(),
    );
  }

  Future<void> recuperarSenha({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<void> sair() async {
    await _auth.signOut();
  }

  String tratarErroAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'E-mail inválido.';

      case 'user-not-found':
        return 'Usuário não encontrado.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';

      case 'email-already-in-use':
        return 'Este e-mail já está em uso.';

      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';

      case 'network-request-failed':
        return 'Sem conexão com a internet.';

      case 'operation-not-allowed':
        return 'Login por e-mail e senha não está ativado no Firebase.';

      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';

      case 'unknown':
      case 'internal-error':
        return 'Erro interno do Firebase. Verifique a configuração do Authentication e da plataforma.';

      default:
        return 'Erro Firebase: ${e.code}';
    }
  }
}