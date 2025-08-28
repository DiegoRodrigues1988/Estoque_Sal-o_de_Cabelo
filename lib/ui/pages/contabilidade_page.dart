import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/providers/venda_provider.dart';
import 'package:estoque_salao_de_cabelo/ui/theme/app_theme.dart';

class ContabilidadePage extends StatelessWidget {
  const ContabilidadePage({super.key});

  // --- NOVA FUNÇÃO PARA CONFIRMAR A LIMPEZA ---
  void _confirmarLimpeza(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Limpeza'),
        content: const Text(
            'Tem certeza que deseja apagar todo o histórico de vendas? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<VendaProvider>(context, listen: false)
                  .limparHistoricoVendas();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Histórico de contabilidade limpo!'),
                    backgroundColor: Colors.green),
              );
            },
            child:
                const Text('Limpar Tudo', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatadorMoeda =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contabilidade'),
        // --- BOTÃO DE LIMPAR ADICIONADO AQUI ---
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined),
            tooltip: 'Limpar histórico',
            onPressed: () => _confirmarLimpeza(context),
          ),
        ],
      ),
      body: Consumer<VendaProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
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
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Histórico de Vendas',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
              ),
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
