/**
 * seed_firestore.js
 * -----------------
 * Popula a coleção "produtos" no Firestore com os dados do mock original.
 *
 * Pré-requisitos:
 *   npm install firebase-admin
 *
 * Como usar:
 *   1. Acesse o Firebase Console → Configurações do projeto → Contas de serviço
 *   2. Clique em "Gerar nova chave privada" e salve como serviceAccountKey.json
 *      na mesma pasta deste arquivo.
 *   3. Execute:  node seed_firestore.js
 */

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// ── Produtos idênticos ao mock_products.dart ────────────────────────────────
const produtos = [
  {
    nome: 'Coxinha',
    descricao: 'Massa crocante com recheio de frango desfiado.',
    preco: 7.00,
    categoria: 'Salgados',
    imagem: '',
    disponivel: true,
    ordem: 1,
  },
  {
    nome: 'Esfiha',
    descricao: 'Esfiha aberta recheada com carne temperada.',
    preco: 6.50,
    categoria: 'Salgados',
    imagem: '',
    disponivel: true,
    ordem: 2,
  },
  {
    nome: 'Empada',
    descricao: 'Empada de frango com massa amanteigada.',
    preco: 6.00,
    categoria: 'Salgados',
    imagem: '',
    disponivel: true,
    ordem: 3,
  },
  {
    nome: 'Brigadeiro',
    descricao: 'Doce tradicional de chocolate com granulado.',
    preco: 3.50,
    categoria: 'Doces',
    imagem: '',
    disponivel: true,
    ordem: 1,
  },
  {
    nome: 'Bolo no pote',
    descricao: 'Camadas de bolo com recheio cremoso.',
    preco: 10.00,
    categoria: 'Doces',
    imagem: '',
    disponivel: true,
    ordem: 2,
  },
  {
    nome: 'Beijinho',
    descricao: 'Docinho de coco com cravo.',
    preco: 3.50,
    categoria: 'Doces',
    imagem: '',
    disponivel: true,
    ordem: 3,
  },
  {
    nome: 'Refrigerante Lata',
    descricao: 'Lata 350ml, sabores variados.',
    preco: 6.00,
    categoria: 'Refrigerantes',
    imagem: '',
    disponivel: true,
    ordem: 1,
  },
  {
    nome: 'Refrigerante Garrafa',
    descricao: 'Garrafa 600ml, sabores variados.',
    preco: 8.00,
    categoria: 'Refrigerantes',
    imagem: '',
    disponivel: true,
    ordem: 2,
  },
  {
    nome: 'Suco natural',
    descricao: 'Suco natural feito na hora, sabores da estação.',
    preco: 8.00,
    categoria: 'Sucos',
    imagem: '',
    disponivel: true,
    ordem: 1,
  },
  {
    nome: 'Suco de caixinha',
    descricao: 'Suco industrializado 200ml.',
    preco: 4.00,
    categoria: 'Sucos',
    imagem: '',
    disponivel: true,
    ordem: 2,
  },
  {
    nome: 'Lanche natural',
    descricao: 'Pão integral com recheio leve e saudável.',
    preco: 9.00,
    categoria: 'Lanches Naturais',
    imagem: '',
    disponivel: true,
    ordem: 1,
  },
  {
    nome: 'Wrap de frango',
    descricao: 'Wrap integral com frango grelhado e salada.',
    preco: 12.00,
    categoria: 'Lanches Naturais',
    imagem: '',
    disponivel: true,
    ordem: 2,
  },
  {
    nome: 'Trident',
    descricao: 'Chiclete sabor menta.',
    preco: 2.50,
    categoria: 'Guloseimas',
    imagem: '',
    disponivel: true,
    ordem: 1,
  },
  {
    nome: 'Chocolate',
    descricao: 'Barra de chocolate ao leite 25g.',
    preco: 4.00,
    categoria: 'Guloseimas',
    imagem: '',
    disponivel: true,
    ordem: 2,
  },
];

// ── Upload para o Firestore ──────────────────────────────────────────────────
async function seed() {
  const colecao = db.collection('produtos');
  const batch = db.batch();

  for (const produto of produtos) {
    const ref = colecao.doc(); // ID automático
    batch.set(ref, produto);
  }

  await batch.commit();
  console.log(`✅ ${produtos.length} produtos inseridos com sucesso!`);
  process.exit(0);
}

seed().catch((err) => {
  console.error('❌ Erro ao inserir produtos:', err);
  process.exit(1);
});
