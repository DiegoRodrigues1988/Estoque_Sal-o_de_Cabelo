import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/providers/produto_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/venda_provider.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/add_edit_produto_page.dart';
import 'package:intl/intl.dart';

class EstoquePage extends StatelessWidget {
  const EstoquePage({super.key});

  // --- NOVA FUNÇÃO PARA MOSTRAR O DIÁLOGO DE VENDA ---
  void _mostrarDialogoDeVenda(BuildContext context, Produto produto) {
    final quantidadeController = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Registrar Venda / Uso'),
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

                // Usamos listen: false aqui porque estamos dentro de uma função
                final vendaProvider =
                    Provider.of<VendaProvider>(context, listen: false);
                final produtoProvider =
                    Provider.of<ProdutoProvider>(context, listen: false);

                // Chama o método para registrar a venda
                vendaProvider.registrarVenda(produto, quantidade).then((_) {
                  // Atualiza a lista de produtos para refletir o novo estoque
                  produtoProvider.loadProdutos();
                  Navigator.of(ctx).pop(); // Fecha o diálogo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Venda registrada com sucesso!'),
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
                    trailing: Text('Qtd: ${produto.quantidade}',
                        style: TextStyle(
                            color: corQuantidade,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    onTap: () => _mostrarDialogoDeVenda(
                        context, produto), // Ação ao tocar
                  ),
                );
              },
            ),
    );
  }
}
