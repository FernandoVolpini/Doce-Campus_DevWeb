const { before, after, beforeEach, test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const { initializeTestEnvironment, assertSucceeds, assertFails } = require('@firebase/rules-unit-testing');
const { doc, setDoc, getDoc, updateDoc, deleteDoc, serverTimestamp, collection, query, where, getDocs } = require('firebase/firestore');
let env;
const userDb = uid => env.authenticatedContext(uid, { email: `${uid}@example.com` }).firestore();
const pedido = (uid, overrides = {}) => ({
  uid, email: `${uid}@example.com`, itens: [{ produtoId: 'coxinha', quantidade: 1, preco: 7.5, subtotal: 7.5 }],
  total: 7.5, quantidadeTotal: 1, status: 'pendente', criadoEm: serverTimestamp(), ...overrides,
});
before(async () => {
  if (!process.env.FIRESTORE_EMULATOR_HOST) throw Error('Execute os testes no emulador.');
  env = await initializeTestEnvironment({ projectId: 'demo-doce-campus', firestore: { rules: fs.readFileSync('firestore.rules', 'utf8') } });
});
beforeEach(async () => env.clearFirestore());
after(async () => env?.cleanup());
test('Cliente cria e consulta apenas seus pedidos', async () => {
  const ana = userDb('ana');
  await assertSucceeds(setDoc(doc(ana, 'pedidos/p1'), pedido('ana')));
  await assertSucceeds(getDoc(doc(ana, 'pedidos/p1')));
  await assertFails(getDoc(doc(userDb('bia'), 'pedidos/p1')));
  await assertFails(setDoc(doc(userDb('bia'), 'pedidos/p2'), pedido('ana')));
  await assertSucceeds(getDocs(query(collection(ana, 'pedidos'), where('uid', '==', 'ana'))));
});
test('Recusa pedido sem autenticação, vazio, valor inválido ou status falsificado', async () => {
  await assertFails(setDoc(doc(env.unauthenticatedContext().firestore(), 'pedidos/p1'), pedido('ana')));
  const db = userDb('ana');
  for (const payload of [pedido('ana', { itens: [] }), pedido('ana', { total: -1 }), pedido('ana', { status: 'entregue' }), pedido('ana', { admin: true })]) {
    await assertFails(setDoc(doc(db, 'pedidos/p1'), payload));
  }
});
test('Nome de e-mail administrativo não concede privilégios', async () => {
  const impostor = env.authenticatedContext('x', { email: 'admin@docecampus.com' }).firestore();
  await assertFails(setDoc(doc(impostor, 'produtos/p1'), { nome: 'Produto' }));
  const admin = env.authenticatedContext('admin', { admin: true }).firestore();
  await assertSucceeds(setDoc(doc(admin, 'produtos/p1'), { nome: 'Produto' }));
});
test('Somente admin altera status, sem reescrever total ou dono', async () => {
  const ana = userDb('ana');
  await setDoc(doc(ana, 'pedidos/p1'), pedido('ana'));
  await assertFails(updateDoc(doc(ana, 'pedidos/p1'), { status: 'entregue' }));
  const admin = env.authenticatedContext('admin', { admin: true }).firestore();
  await assertSucceeds(updateDoc(doc(admin, 'pedidos/p1'), { status: 'preparando' }));
  await assertFails(updateDoc(doc(admin, 'pedidos/p1'), { total: 1 }));
  await assertFails(deleteDoc(doc(admin, 'pedidos/p1')));
});
test('Perfil é privado e não aceita campos de privilégio', async () => {
  const db = userDb('ana');
  const perfil = { nome: 'Ana', email: 'ana@example.com', telefone: '16999999999', criadoEm: serverTimestamp() };
  await assertSucceeds(setDoc(doc(db, 'usuarios/ana'), perfil));
  await assertFails(getDoc(doc(userDb('bia'), 'usuarios/ana')));
  await assertFails(setDoc(doc(db, 'usuarios/ana'), { ...perfil, admin: true }));
});
test('Catálogo exige login e proíbe escrita por clientes', async () => {
  await env.withSecurityRulesDisabled(async ctx => setDoc(doc(ctx.firestore(), 'produtos/p1'), { nome: 'Coxinha' }));
  await assertSucceeds(getDoc(doc(userDb('ana'), 'produtos/p1')));
  await assertFails(getDoc(doc(env.unauthenticatedContext().firestore(), 'produtos/p1')));
  await assertFails(updateDoc(doc(userDb('ana'), 'produtos/p1'), { preco: 0.01 }));
});
test('Seed cria IDs estáveis e preserva produtos já existentes', async () => {
  const { initializeApp, deleteApp } = require('firebase-admin/app');
  const { getFirestore } = require('firebase-admin/firestore');
  const { seed, produtos, produtoId } = require('../seed_firestore.js');
  const app = initializeApp({ projectId: 'demo-doce-campus' }, 'test-seed');
  try {
    const db = getFirestore(app);
    assert.equal(await seed(db), produtos.length);
    const ref = db.collection('produtos').doc(produtoId(produtos[0]));
    await ref.update({ preco: 123 });
    assert.equal(await seed(db), 0);
    assert.equal((await db.collection('produtos').get()).size, produtos.length);
    assert.equal((await ref.get()).data().preco, 123);
  } finally { await deleteApp(app); }
});
