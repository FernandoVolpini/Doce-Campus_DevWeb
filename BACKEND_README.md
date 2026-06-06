rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // ── Funções auxiliares ──────────────────────────────────────────────
    function estaAutenticado() {
      return request.auth != null;
    }

    function ehDono(uid) {
      return request.auth.uid == uid;
    }

    // ── produtos/ ───────────────────────────────────────────────────────
    // Qualquer usuário autenticado pode LER produtos.
    // Somente o admin (e-mail específico) pode escrever.
    match /produtos/{produtoId} {
      allow read: if estaAutenticado();
      allow write: if estaAutenticado()
                   && request.auth.token.email == 'admin@docecampus.com';
    }

    // ── pedidos/ ────────────────────────────────────────────────────────
    // Usuário autenticado pode criar pedidos e ler SOMENTE os seus próprios.
    // Admin pode ler e atualizar status de qualquer pedido.
    match /pedidos/{pedidoId} {
      allow create: if estaAutenticado()
                    && request.resource.data.uid == request.auth.uid;

      allow read: if estaAutenticado()
                  && (resource.data.uid == request.auth.uid
                      || request.auth.token.email == 'admin@docecampus.com');

      allow update: if estaAutenticado()
                    && request.auth.token.email == 'admin@docecampus.com';

      allow delete: if false; // pedidos nunca são deletados
    }

    // ── usuarios/ ───────────────────────────────────────────────────────
    // Cada usuário pode ler e escrever somente o seu próprio documento.
    match /usuarios/{uid} {
      allow read, write: if estaAutenticado() && ehDono(uid);
    }
  }
}
