# 🔥 Back-end – Doce Campus

Guia completo de integração do back-end com Firebase Firestore.

---

## 📁 Arquivos novos / modificados

| Arquivo | Tipo | O que faz |
|---|---|---|
| `firestore_service.dart` | **NOVO** | CRUD central de produtos, pedidos e usuários |
| `order_service.dart` | **NOVO** | Lógica de negócio para criação de pedidos |
| `order_history_page.dart` | **NOVO** | Tela de histórico de pedidos do usuário |
| `product_model.dart` | **MODIFICADO** | Adiciona `fromFirestore()` e `toMap()` |
| `product_list_page.dart` | **MODIFICADO** | Lê do Firestore (antes usava `mockProducts`) |
| `checkout_page.dart` | **MODIFICADO** | Salva o pedido no Firestore ao confirmar |
| `register_page.dart` | **MODIFICADO** | Salva nome e telefone no Firestore ao cadastrar |
| `firestore.rules` | **NOVO** | Regras de segurança do Firestore |
| `seed_firestore.js` | **NOVO** | Script Node.js para popular o banco |

---

## 🚀 Passo a passo de integração

### 1. Ativar o Firestore no Firebase Console

1. Acesse [console.firebase.google.com](https://console.firebase.google.com)
2. Selecione o projeto **parcialdevmob**
3. No menu lateral: **Firestore Database → Criar banco de dados**
4. Escolha **Modo de produção** → Selecione a região **us-east1** → Criar

---

### 2. Adicionar a dependência no `pubspec.yaml`

Abra `pubspec.yaml` e acrescente `cloud_firestore`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0   # ← adicionar esta linha
```

Depois execute:

```bash
flutter pub get
```

---

### 3. Substituir os arquivos modificados

Copie os arquivos desta pasta para `lib/` do seu projeto, **substituindo** os originais:

```
product_model.dart      → lib/product_model.dart
product_list_page.dart  → lib/product_list_page.dart
checkout_page.dart      → lib/checkout_page.dart
register_page.dart      → lib/register_page.dart
```

E copie os arquivos **novos** também para `lib/`:

```
firestore_service.dart    → lib/firestore_service.dart
order_service.dart        → lib/order_service.dart
order_history_page.dart   → lib/order_history_page.dart
```

---

### 4. Publicar as regras de segurança

Copie `firestore.rules` para a raiz do projeto (onde está o `firebase.json`) e execute:

```bash
firebase deploy --only firestore:rules
```

> ⚠️ Lembre-se de alterar o e-mail `admin@docecampus.com` nas regras para o
> e-mail real da conta administradora antes de publicar.

---

### 5. Popular o banco com os produtos (seed)

```bash
# Na raiz do projeto, instale o firebase-admin
npm install firebase-admin

# Baixe a chave de serviço:
# Firebase Console → Configurações → Contas de serviço → Gerar nova chave privada
# Salve como serviceAccountKey.json na mesma pasta do seed_firestore.js

node seed_firestore.js
```

Você verá: `✅ 14 produtos inseridos com sucesso!`

---

### 6. (Opcional) Adicionar botão "Meus Pedidos" na HomePage

Para acessar o histórico de pedidos, adicione em `home_page.dart`:

```dart
import 'order_history_page.dart';

// Dentro do build, após o botão "Meu carrinho":
SizedBox(
  height: 55,
  child: OutlinedButton.icon(
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
    ),
    icon: const Icon(Icons.receipt_long_outlined),
    label: const Text('Meus pedidos'),
  ),
),
```

---

## 🗂️ Estrutura do Firestore

```
firestore/
│
├── produtos/                      ← Catálogo do cardápio
│   └── {produtoId}/
│       ├── nome        : string
│       ├── descricao   : string
│       ├── preco       : number
│       ├── categoria   : string
│       ├── imagem      : string   (URL ou vazio)
│       ├── disponivel  : boolean
│       └── ordem       : number
│
├── pedidos/                       ← Pedidos dos clientes
│   └── {pedidoId}/
│       ├── uid              : string   (Firebase Auth UID)
│       ├── email            : string
│       ├── itens            : array
│       │   └── { produtoId, nome, categoria, preco, quantidade, subtotal }
│       ├── total            : number
│       ├── quantidadeTotal  : number
│       ├── observacao       : string   (opcional)
│       ├── status           : string   (pendente|preparando|pronto|entregue|cancelado)
│       └── criadoEm        : timestamp
│
└── usuarios/                      ← Perfil extra dos usuários
    └── {uid}/
        ├── nome       : string
        ├── email      : string
        ├── telefone   : string
        └── criadoEm  : timestamp
```

---

## 🔐 Regras de segurança (resumo)

| Coleção | Leitura | Escrita |
|---|---|---|
| `produtos` | Usuário autenticado | Somente admin |
| `pedidos` | Dono do pedido ou admin | Criar: dono · Atualizar: admin |
| `usuarios` | Somente o próprio usuário | Somente o próprio usuário |

---

## ✅ Checklist final

- [ ] Firestore ativado no Firebase Console
- [ ] `cloud_firestore` adicionado ao `pubspec.yaml`
- [ ] Arquivos substituídos/adicionados em `lib/`
- [ ] `firestore.rules` publicado via Firebase CLI
- [ ] Seed executado (`node seed_firestore.js`)
- [ ] E-mail admin atualizado nas regras
- [ ] Botão "Meus pedidos" adicionado na HomePage (opcional)
