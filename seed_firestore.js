// Cadastro inicial: cria apenas os produtos ausentes, sem sobrescrever preços.
const { initializeApp, applicationDefault } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');

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


function produtoId(produto) {
  return `${produto.categoria}-${produto.nome}`.normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '').toLowerCase()
    .replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
}

async function seed(db) {
  let criados = 0;
  for (const produto of produtos) {
    const ref = db.collection('produtos').doc(produtoId(produto));
    const criado = await db.runTransaction(async transaction => {
      if ((await transaction.get(ref)).exists) return false;
      transaction.create(ref, produto);
      return true;
    });
    if (criado) criados++;
  }
  return criados;
}

if (require.main === module) {
  const projectId = process.argv.find(arg => arg.startsWith('--project='))?.slice(10);
  if (!projectId) {
    console.error('Informe o destino: node seed_firestore.js --project=ID_DO_PROJETO');
    process.exitCode = 1;
  } else {
    initializeApp(process.env.FIRESTORE_EMULATOR_HOST
      ? { projectId }
      : { projectId, credential: applicationDefault() });
    seed(getFirestore()).then(n => console.log(`${n} produtos criados. Itens existentes preservados.`))
      .catch(error => { console.error('Não foi possível cadastrar os produtos:', error.message); process.exitCode = 1; });
  }
}
module.exports = { seed, produtos, produtoId };
