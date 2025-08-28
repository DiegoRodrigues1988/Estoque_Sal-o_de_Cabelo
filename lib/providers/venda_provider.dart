import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/models/venda_model.dart';

class VendaProvider with ChangeNotifier {
  final Box<Venda> _vendasBox = Hive.box<Venda>('vendas');
  List<Venda> _vendas = [];

  List<Venda> get vendas => _vendas;

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
    _vendas.sort((a, b) => b.dataVenda.compareTo(a.dataVenda));
    notifyListeners();
  }

  Future<void> registrarVenda(Produto produto, int quantidadeVendida) async {
    if (quantidadeVendida <= 0 || quantidadeVendida > produto.quantidade) {
      return;
    }

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

    produto.quantidade -= quantidadeVendida;
    await produto.save();

    loadVendas();
  }

  // --- NOVA FUNÇÃO ADICIONADA AQUI ---
  Future<void> limparHistoricoVendas() async {
    await _vendasBox.clear(); // Apaga todos os registros da caixa de vendas
    loadVendas(); // Recarrega a lista (que agora estará vazia) e notifica a UI
  }
}
