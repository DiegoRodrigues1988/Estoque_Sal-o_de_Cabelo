import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/providers/venda_provider.dart';
import 'package:estoque_salao_de_cabelo/ui/theme/app_theme.dart';

class ContabilidadePage extends StatelessWidget {
  const ContabilidadePage({super.key});

  @override
  Widget build(BuildContext context) {
    final formatadorMoeda =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Contabilidade')),
      body: Consumer<VendaProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // --- PAINEL DE RESUMO ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResumoItem(
                            'Faturamento',
                            formatadorMoeda.format(provider.faturamentoTotal),
                            Colors.green),
                        _buildResumoItem(
                            'Custo',
                            formatadorMoeda.format(provider.custoTotal),
                            Colors.red),
                        _buildResumoItem(
                            'Lucro',
                            formatadorMoeda.format(provider.lucroTotal),
                            AppTheme.accentGold),
                      ],
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Histórico de Vendas',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              // --- LISTA DE VENDAS ---
              Expanded(
                child: provider.vendas.isEmpty
                    ? const Center(child: Text('Nenhuma venda registrada.'))
                    : ListView.builder(
                        itemCount: provider.vendas.length,
                        itemBuilder: (context, index) {
                          final venda = provider.vendas[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: ListTile(
                              title: Text(
                                  "${venda.quantidade}x ${venda.produtoNome}"),
                              subtitle: Text(DateFormat('dd/MM/yyyy HH:mm')
                                  .format(venda.dataVenda)),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(formatadorMoeda.format(venda.totalVenda),
                                      style:
                                          const TextStyle(color: Colors.green)),
                                  Text(
                                      "Lucro: ${formatadorMoeda.format(venda.lucro)}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.accentSilver)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResumoItem(String label, String valor, Color cor) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, color: AppTheme.accentSilver)),
        const SizedBox(height: 4),
        Text(valor,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: cor)),
      ],
    );
  }
}
