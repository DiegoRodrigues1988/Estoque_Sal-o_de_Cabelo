import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/providers/produto_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/venda_provider.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/add_edit_produto_page.dart';
import 'package:intl/intl.dart';

class EstoquePage extends StatelessWidget {
  const EstoquePage({super.key});

  void _mostrarDialogoDeVenda(BuildContext context, Produto produto) {
    final quantidadeController = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registrar Venda / Uso'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: quantidadeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantidade',
              hintText: 'Estoque atual: ${produto.quantidade}',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Obrigatório';
              final qtd = int.tryParse(value);
              if (qtd == null) return 'Número inválido';
              if (qtd <= 0) return 'Deve ser maior que zero';
              if (qtd > produto.quantidade) return 'Estoque insuficiente';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final quantidade = int.parse(quantidadeController.text);

                final vendaProvider =
                    Provider.of<VendaProvider>(context, listen: false);
                final produtoProvider =
                    Provider.of<ProdutoProvider>(context, listen: false);

                vendaProvider.registrarVenda(produto, quantidade).then((_) {
                  produtoProvider.loadProdutos();
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Venda registrada!'),
                        backgroundColor: Colors.green),
                  );
                });
              }
            },
            child: const Text('Confirmar'),
          )
        ],
      ),
    );
  }

  // --- NOVA FUNÇÃO PARA CONFIRMAR A EXCLUSÃO DO PRODUTO ---
  void _confirmarExclusao(BuildContext context, Produto produto) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir "${produto.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ProdutoProvider>(context, listen: false)
                  .deleteProduto(produto);
              Navigator.of(ctx).pop();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produtoProvider = Provider.of<ProdutoProvider>(context);
    final produtos = produtoProvider.produtos;
    final formatadorMoeda =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddEditProdutoPage())),
          ),
        ],
      ),
      body: produtos.isEmpty
          ? const Center(child: Text('Nenhum produto cadastrado.'))
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                final corQuantidade =
                    produto.quantidade <= 5 ? Colors.orange : null;
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(produto.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Venda: ${formatadorMoeda.format(produto.precoVenda)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Qtd: ${produto.quantidade}',
                            style: TextStyle(
                                color: corQuantidade,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        // --- BOTÃO DE LIXEIRA ADICIONADO AQUI ---
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent),
                          onPressed: () => _confirmarExclusao(context, produto),
                        ),
                      ],
                    ),
                    onLongPress: () {
                      // Mantém a edição com um toque longo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddEditProdutoPage(produto: produto)),
                      );
                    },
                    onTap: () => _mostrarDialogoDeVenda(
                        context, produto), // Venda com um toque rápido
                  ),
                );
              },
            ),
    );
  }
}
