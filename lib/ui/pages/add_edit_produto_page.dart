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
  bool get _isEditing => widget.produto != null;
  bool get _isAddingToStock => _isEditing; // Para clareza da lógica

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto?.nome ?? '');
    _categoriaController =
        TextEditingController(text: widget.produto?.categoria ?? '');
    // Se estiver editando, o campo de quantidade começa zerado para adicionar ao estoque
    _quantidadeController = TextEditingController(text: _isEditing ? '0' : '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _categoriaController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ProdutoProvider>(context, listen: false);
      final nome = _nomeController.text;
      final categoria = _categoriaController.text;
      final quantidade = int.parse(_quantidadeController.text);

      if (_isAddingToStock) {
        // A lógica de adicionar ao estoque já está no provider (addProduto)
        provider.addProduto(nome, categoria, quantidade);
      } else {
        provider.addProduto(nome, categoria, quantidade);
      }
      Navigator.pop(context);
    }
  }

  void _deleteProduto() {
    Provider.of<ProdutoProvider>(context, listen: false)
        .deleteProduto(widget.produto!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isEditing ? 'Editar / Adicionar Estoque' : 'Adicionar Produto'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              TextFormField(
                controller: _quantidadeController,
                decoration: InputDecoration(
                  labelText: _isAddingToStock
                      ? 'Adicionar Quantidade'
                      : 'Quantidade Inicial',
                  hintText: _isAddingToStock
                      ? 'Estoque atual: ${widget.produto!.quantidade}'
                      : '',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Campo obrigatório';
                  if (int.tryParse(value) == null) return 'Número inválido';
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(
                    _isEditing ? 'Atualizar Estoque' : 'Adicionar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
