import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/models/venda_model.dart';

class VendaProvider with ChangeNotifier {
  final Box<Venda> _vendasBox = Hive.box<Venda>('vendas');
  List<Venda> _vendas = [];

  List<Venda> get vendas => _vendas;

  // Propriedades calculadas para a contabilidade
  double get faturamentoTotal =>
      _vendas.fold(0, (sum, item) => sum + item.totalVenda);
  double get custoTotal =>
      _vendas.fold(0, (sum, item) => sum + item.totalCusto);
  double get lucroTotal => faturamentoTotal - custoTotal;

  VendaProvider() {
    loadVendas();
  }

  void loadVendas() {
    _vendas = _vendasBox.values.toList();
    _vendas.sort(
        (a, b) => b.dataVenda.compareTo(a.dataVenda)); // Mais recentes primeiro
    notifyListeners();
  }

  Future<void> registrarVenda(Produto produto, int quantidadeVendida) async {
    if (quantidadeVendida <= 0 || quantidadeVendida > produto.quantidade) {
      // Impede a venda se a quantidade for inválida ou não houver estoque
      return;
    }

    // Cria o registro da venda
    final novaVenda = Venda(
      id: const Uuid().v4(),
      produtoId: produto.id,
      produtoNome: produto.nome,
      quantidade: quantidadeVendida,
      totalCusto: produto.precoCusto * quantidadeVendida,
      totalVenda: produto.precoVenda * quantidadeVendida,
      dataVenda: DateTime.now(),
    );

    await _vendasBox.put(novaVenda.id, novaVenda);

    // Atualiza o estoque do produto
    produto.quantidade -= quantidadeVendida;
    await produto.save();

    loadVendas();
  }
}
