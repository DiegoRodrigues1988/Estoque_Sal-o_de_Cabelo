import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/providers/produto_provider.dart';

class AddEditProdutoPage extends StatefulWidget {
  final Produto? produto;
  const AddEditProdutoPage({super.key, this.produto});

  @override
  State<AddEditProdutoPage> createState() => _AddEditProdutoPageState();
}

class _AddEditProdutoPageState extends State<AddEditProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _categoriaController;
  late TextEditingController _quantidadeController;
  late TextEditingController _custoController;
  late TextEditingController _vendaController;

  bool get _isEditing => widget.produto != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto?.nome ?? '');
    _categoriaController =
        TextEditingController(text: widget.produto?.categoria ?? '');
    _quantidadeController = TextEditingController(
        text: widget.produto?.quantidade.toString() ?? '');
    _custoController = TextEditingController(
        text: widget.produto?.precoCusto.toString() ?? '');
    _vendaController = TextEditingController(
        text: widget.produto?.precoVenda.toString() ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _categoriaController.dispose();
    _quantidadeController.dispose();
    _custoController.dispose();
    _vendaController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ProdutoProvider>(context, listen: false);
      final nome = _nomeController.text;
      final categoria = _categoriaController.text;
      final quantidade = int.tryParse(_quantidadeController.text) ?? 0;
      final custo = double.tryParse(_custoController.text) ?? 0.0;
      final venda = double.tryParse(_vendaController.text) ?? 0.0;

      if (_isEditing) {
        provider.updateProduto(
            widget.produto!, nome, categoria, quantidade, custo, venda);
      } else {
        provider.addProduto(nome, categoria, quantidade, custo, venda);
      }
      Navigator.pop(context);
    }
  }

  void _deleteProduto() {
    // Adiciona um diálogo de confirmação para segurança
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este produto?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Provider.of<ProdutoProvider>(context, listen: false)
                  .deleteProduto(widget.produto!);
              Navigator.of(ctx).pop(); // Fecha o diálogo
              Navigator.of(context).pop(); // Volta para a tela anterior
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Produto' : 'Adicionar Produto'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteProduto,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          // Usa ListView para evitar que o teclado cubra os campos
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obrigatório'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obrigatório'
                    : null,
              ),
              const SizedBox(height: 16),
              // Campos de preço em uma linha
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _custoController,
                      decoration:
                          const InputDecoration(labelText: 'Preço Custo (R\$)'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Obrigatório';
                        if (double.tryParse(value) == null)
                          return 'Número inválido';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _vendaController,
                      decoration:
                          const InputDecoration(labelText: 'Preço Venda (R\$)'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Obrigatório';
                        if (double.tryParse(value) == null)
                          return 'Número inválido';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantidadeController,
                decoration:
                    const InputDecoration(labelText: 'Quantidade em Estoque'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Obrigatório';
                  if (int.tryParse(value) == null) return 'Número inválido';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(
                    _isEditing ? 'Salvar Alterações' : 'Adicionar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
