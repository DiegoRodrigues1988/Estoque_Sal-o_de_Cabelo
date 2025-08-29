import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';

class AddEditClientePage extends StatefulWidget {
  final Cliente? cliente;
  const AddEditClientePage({super.key, this.cliente});

  @override
  State<AddEditClientePage> createState() => _AddEditClientePageState();
}

class _AddEditClientePageState extends State<AddEditClientePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController;
  bool get _isEditing => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cliente?.nome ?? '');
    _telefoneController =
        TextEditingController(text: widget.cliente?.telefone ?? '');
    _emailController = TextEditingController(text: widget.cliente?.email ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ClienteProvider>(context, listen: false);
      final email =
          _emailController.text.isEmpty ? null : _emailController.text;
      if (_isEditing) {
        provider.updateCliente(widget.cliente!, _nomeController.text,
            _telefoneController.text, email);
      } else {
        provider.addCliente(
            _nomeController.text, _telefoneController.text, email);
      }
      Navigator.pop(context);
    }
  }

  void _deleteCliente() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content:
            Text('Tem certeza que deseja excluir "${widget.cliente!.nome}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Provider.of<ClienteProvider>(context, listen: false)
                  .deleteCliente(widget.cliente!);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
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
        title: Text(_isEditing ? 'Editar Cliente' : 'Adicionar Cliente'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteCliente,
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
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obrigatório'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obrigatório'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'E-mail (opcional)'),
                keyboardType: TextInputType.emailAddress,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(
                    _isEditing ? 'Salvar Alterações' : 'Adicionar Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
