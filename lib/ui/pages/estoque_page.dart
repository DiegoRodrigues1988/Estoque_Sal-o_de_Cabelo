import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/providers/produto_provider.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/add_edit_produto_page.dart';

class EstoquePage extends StatelessWidget {
  const EstoquePage({super.key});

  @override
  Widget build(BuildContext context) {
    final produtoProvider = Provider.of<ProdutoProvider>(context);
    final produtos = produtoProvider.produtos;

    return Scaffold(
      appBar: AppBar(title: const Text('Estoque')),
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
                    subtitle: Text(produto.categoria),
                    trailing: Text('Qtd: ${produto.quantidade}',
                        style: TextStyle(
                            color: corQuantidade, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddEditProdutoPage(produto: produto)),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditProdutoPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
