import 'dart:io';
import 'package:csv/csv.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/models/venda_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  // --- FUNÇÃO PARA EXPORTAR O ESTOQUE ---
  Future<String> exportarEstoqueCsv(List<Produto> produtos) async {
    final List<List<dynamic>> rows = [];
    // Cabeçalho
    rows.add([
      'Produto',
      'Categoria',
      'Quantidade',
      'Preço de Custo',
      'Preço de Venda',
      'Data de Adição'
    ]);

    // Linhas de dados
    for (var produto in produtos) {
      rows.add([
        produto.nome,
        produto.categoria,
        produto.quantidade,
        produto.precoCusto.toStringAsFixed(2),
        produto.precoVenda.toStringAsFixed(2),
        DateFormat('dd/MM/yyyy').format(produto.dataAdicao),
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    return _salvarArquivo('relatorio_estoque', csv);
  }

  // --- FUNÇÃO PARA EXPORTAR A CONTABILIDADE ---
  Future<String> exportarContabilidadeCsv(List<Venda> vendas) async {
    final List<List<dynamic>> rows = [];
    // Cabeçalho
    rows.add([
      'Data',
      'Produto',
      'Quantidade',
      'Total Custo',
      'Total Venda',
      'Lucro'
    ]);

    // Linhas de dados
    for (var venda in vendas) {
      rows.add([
        DateFormat('dd/MM/yyyy HH:mm').format(venda.dataVenda),
        venda.produtoNome,
        venda.quantidade,
        venda.totalCusto.toStringAsFixed(2),
        venda.totalVenda.toStringAsFixed(2),
        venda.lucro.toStringAsFixed(2),
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    return _salvarArquivo('relatorio_contabilidade', csv);
  }

  // Função auxiliar para salvar o arquivo no celular
  Future<String> _salvarArquivo(String nomeBase, String dados) async {
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/${nomeBase}_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(dados);
    return path;
  }
}
