import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';

class ProdutoProvider with ChangeNotifier {
  final Box<Produto> _produtosBox = Hive.box<Produto>('produtos');
  List<Produto> _produtos = [];

  List<Produto> get produtos => _produtos;
  List<Produto> get produtosComEstoqueBaixo =>
      _produtos.where((p) => p.quantidade <= 5).toList();

  ProdutoProvider() {
    loadProdutos();
  }

  void loadProdutos() {
    _produtos = _produtosBox.values.toList();
    _produtos
        .sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
    notifyListeners();
  }

  Future<void> addProduto(String nome, String categoria, int quantidade,
      double precoCusto, double precoVenda) async {
    final novoProduto = Produto(
      id: const Uuid().v4(),
      nome: nome,
      categoria: categoria,
      quantidade: quantidade,
      precoCusto: precoCusto,
      precoVenda: precoVenda,
      dataAdicao: DateTime.now(), // <-- DATA E HORA SÃO REGISTRADAS AQUI
    );
    await _produtosBox.put(novoProduto.id, novoProduto);
    loadProdutos();
  }

  Future<void> updateProduto(Produto produto, String nome, String categoria,
      int quantidade, double precoCusto, double precoVenda) async {
    produto.nome = nome;
    produto.categoria = categoria;
    produto.quantidade = quantidade;
    produto.precoCusto = precoCusto;
    produto.precoVenda = precoVenda;
    // A data de adição não é alterada na edição

    await produto.save();
    loadProdutos();
  }

  Future<void> deleteProduto(Produto produto) async {
    await produto.delete();
    loadProdutos();
  }
}
