import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/agendamento_provider.dart';

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
  bool get _isEditing => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cliente?.nome ?? '');
    _telefoneController =
        TextEditingController(text: widget.cliente?.telefone ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ClienteProvider>(context, listen: false);
      if (_isEditing) {
        provider.updateCliente(
            widget.cliente!, _nomeController.text, _telefoneController.text);
      } else {
        provider.addCliente(_nomeController.text, _telefoneController.text);
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

  void _confirmarVisita() {
    Provider.of<ClienteProvider>(context, listen: false)
        .registrarVisita(widget.cliente!);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Visita registrada!'), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  // --- Função para agendar ---
  Future<void> _agendarHorario() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
          const Duration(days: 1)), // Permite agendar para ontem, se necessário
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (dataSelecionada == null || !mounted) return;

    final horaSelecionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horaSelecionada == null) return;

    final dataHoraFinal = DateTime(
      dataSelecionada.year,
      dataSelecionada.month,
      dataSelecionada.day,
      horaSelecionada.hour,
      horaSelecionada.minute,
    );

    final provider = Provider.of<AgendamentoProvider>(context, listen: false);
    await provider.addAgendamento(widget.cliente!, dataHoraFinal);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cliente agendado com sucesso!'),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
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
              const Spacer(), // Empurra os botões para baixo

              // --- BOTÕES QUE SÓ APARECEM AO EDITAR ---
              if (_isEditing) ...[
                ElevatedButton.icon(
                  onPressed: _agendarHorario,
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Agendar Horário Futuro'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _confirmarVisita,
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmar Visita de Hoje'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
                const SizedBox(height: 12),
              ],

              ElevatedButton(
                onPressed: _saveForm,
                child: Text(
                    _isEditing ? 'Salvar Alterações' : 'Adicionar Cliente'),
                style: ElevatedButton.styleFrom(
                  // Muda o estilo do botão principal para não competir com o de agendar
                  backgroundColor:
                      _isEditing ? null : Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
