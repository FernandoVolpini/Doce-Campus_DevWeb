# Integração com o Firebase

O código executável fica em `lib/`. Os arquivos de integração que estavam na raiz com nomes trocados foram recuperados de `files.zip` e incorporados à aplicação. Não é necessário copiar arquivos manualmente. O arquivo ZIP permanece como registro da entrega original.

## Preparação

1. Instale o Flutter 3.47.7 (versão usada na validação, com Dart 3.13.5) e execute `flutter pub get`.
2. No projeto Firebase usado por `lib/firebase_options.dart`, habilite Authentication por e-mail/senha e crie o Cloud Firestore.
3. Instale as ferramentas com `npm ci` (Node 22 ou superior).
4. Depois de revisar o projeto de destino, publique regras e índices:

```bash
npx firebase deploy --project parcialdevmob --only firestore:rules,firestore:indexes
```

Aguarde os índices ficarem prontos antes de validar as consultas de categorias e histórico. A publicação do código no GitHub não publica a aplicação nem configura o Firebase.

## Catálogo inicial

O script usa Application Default Credentials. Mantenha eventuais arquivos de conta de serviço fora do repositório e informe seu caminho pela variável `GOOGLE_APPLICATION_CREDENTIALS` na máquina autorizada. O destino precisa ser explícito:

```bash
node seed_firestore.js --project=parcialdevmob
```

Os produtos usam IDs estáveis. Executar novamente cria apenas os itens ausentes, preservando preços e demais alterações de produtos existentes. Os dados são exemplos acadêmicos; revise nomes, preços e disponibilidade antes do uso no estabelecimento.

## Dados e permissões

| Coleção | Conteúdo | Acesso |
| --- | --- | --- |
| `produtos` | Nome, descrição, preço, categoria, imagem, disponibilidade e ordem | Leitura autenticada; escrita administrativa |
| `pedidos` | Usuário, itens, total, observação, status e data | Cliente cria e lê seus pedidos; administrador pode atualizar somente o status |
| `usuarios` | Nome, e-mail, telefone e data | Leitura e escrita apenas pelo próprio usuário |

Administradores são identificados pela custom claim `admin: true`, atribuída em ambiente confiável com o Firebase Admin SDK. Ter um endereço de e-mail específico ou adicionar `admin` ao perfil não concede essa permissão. A aplicação não possui interface administrativa.

As regras validam autoria, campos, tipos básicos e status inicial. Os preços e totais dos itens ainda são calculados no cliente. Antes de integrar pagamentos ou usar valores como cobrança definitiva, implemente o cálculo autoritativo em um backend confiável que consulte o catálogo. O sistema registra solicitações de pedido; não processa pagamentos, estoque ou confirmação automática de preparo.

## Validação

```bash
flutter analyze
flutter test
flutter build web --release
npm run test:rules
```

Os testes de regras usam o emulador com o projeto fictício `demo-doce-campus` e precisam de Java 21 ou superior. Eles verificam isolamento entre usuários, controle administrativo, validação dos pedidos e repetição segura do seed. O workflow em `.github/workflows/ci.yml` executa essas verificações em pull requests, sem credenciais de produção.

O teste do checkout verifica cancelamento, bloqueio de envios concorrentes, preservação do carrinho após falha e limpeza somente depois de uma gravação bem-sucedida. Depois da configuração do Firebase, valide também cadastro, login, catálogo, envio e histórico em um ambiente de homologação.

## Publicação da aplicação

Após validar a configuração e os testes no projeto desejado:

```bash
flutter build web --release
npx firebase deploy --project parcialdevmob --only hosting
```

Os comandos de publicação e cadastro inicial são instruções para o responsável pelo projeto. Não fazem parte dos testes automatizados.
